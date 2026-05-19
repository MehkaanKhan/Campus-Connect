-- ============================================================================
-- Migration 00003: Posts, Comments, Votes, Post Tags
-- The core content system — threads, feed posts, nested comments, and voting.
-- Includes trigger functions to keep denormalized counters in sync.
-- ============================================================================

-- ── Posts ─────────────────────────────────────────────────────────────────────

create table public.posts (
  id             uuid primary key default uuid_generate_v4(),
  author_id      uuid not null references public.profiles(id) on delete cascade,
  university_id  uuid references public.universities(id) on delete set null,
  title          text not null default '',
  content        text not null default '',
  image_url      text,
  flair          text not null default 'General',
  flair_color    text not null default '#6B8F6B',
  upvote_count   int  not null default 0,
  downvote_count int  not null default 0,
  comment_count  int  not null default 0,
  allow_replies  boolean not null default true,
  created_at     timestamptz not null default now()
);

create index idx_posts_author     on public.posts(author_id);
create index idx_posts_university  on public.posts(university_id);
create index idx_posts_created     on public.posts(created_at desc);

alter table public.posts enable row level security;

-- Enable Realtime for posts (Instagram-style live feed)
alter publication supabase_realtime add table public.posts;

-- ── Post Tags ────────────────────────────────────────────────────────────────

create table public.post_tags (
  id      uuid primary key default uuid_generate_v4(),
  post_id uuid not null references public.posts(id) on delete cascade,
  tag     text not null
);

create index idx_post_tags_post on public.post_tags(post_id);

alter table public.post_tags enable row level security;

-- ── Comments ─────────────────────────────────────────────────────────────────

create table public.comments (
  id           uuid primary key default uuid_generate_v4(),
  post_id      uuid not null references public.posts(id) on delete cascade,
  author_id    uuid not null references public.profiles(id) on delete cascade,
  parent_id    uuid references public.comments(id) on delete cascade,
  content      text not null default '',
  upvote_count int  not null default 0,
  is_op        boolean not null default false,
  created_at   timestamptz not null default now()
);

create index idx_comments_post   on public.comments(post_id);
create index idx_comments_parent on public.comments(parent_id);

alter table public.comments enable row level security;

-- Enable Realtime for comments (live thread updates)
alter publication supabase_realtime add table public.comments;

-- Auto-increment comment_count on parent post
create or replace function public.handle_comment_count()
returns trigger as $$
begin
  if (tg_op = 'INSERT') then
    update public.posts set comment_count = comment_count + 1 where id = new.post_id;
    return new;
  elsif (tg_op = 'DELETE') then
    update public.posts set comment_count = greatest(comment_count - 1, 0) where id = old.post_id;
    return old;
  end if;
  return null;
end;
$$ language plpgsql security definer;

create trigger on_comment_change
  after insert or delete on public.comments
  for each row execute function public.handle_comment_count();

-- Auto-set is_op flag when the comment author matches the post author
create or replace function public.handle_comment_is_op()
returns trigger as $$
begin
  new.is_op := exists (
    select 1 from public.posts where id = new.post_id and author_id = new.author_id
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_comment_set_op
  before insert on public.comments
  for each row execute function public.handle_comment_is_op();

-- ── Votes ────────────────────────────────────────────────────────────────────

create table public.votes (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  post_id    uuid references public.posts(id) on delete cascade,
  comment_id uuid references public.comments(id) on delete cascade,
  vote_type  text not null check (vote_type in ('up', 'down')),
  created_at timestamptz not null default now(),

  -- A user can only vote once per post and once per comment
  constraint unique_post_vote    unique (user_id, post_id),
  constraint unique_comment_vote unique (user_id, comment_id),
  -- Must vote on either a post or a comment, not both
  constraint vote_target_check   check (
    (post_id is not null and comment_id is null) or
    (post_id is null and comment_id is not null)
  )
);

create index idx_votes_user on public.votes(user_id);
create index idx_votes_post on public.votes(post_id);

alter table public.votes enable row level security;

-- Trigger to keep post vote counters in sync
create or replace function public.handle_post_vote()
returns trigger as $$
begin
  if (tg_op = 'INSERT' and new.post_id is not null) then
    if new.vote_type = 'up' then
      update public.posts set upvote_count = upvote_count + 1 where id = new.post_id;
    else
      update public.posts set downvote_count = downvote_count + 1 where id = new.post_id;
    end if;
    return new;
  elsif (tg_op = 'DELETE' and old.post_id is not null) then
    if old.vote_type = 'up' then
      update public.posts set upvote_count = greatest(upvote_count - 1, 0) where id = old.post_id;
    else
      update public.posts set downvote_count = greatest(downvote_count - 1, 0) where id = old.post_id;
    end if;
    return old;
  elsif (tg_op = 'UPDATE' and new.post_id is not null) then
    -- Switching vote direction
    if old.vote_type = 'up' and new.vote_type = 'down' then
      update public.posts set upvote_count = greatest(upvote_count - 1, 0), downvote_count = downvote_count + 1 where id = new.post_id;
    elsif old.vote_type = 'down' and new.vote_type = 'up' then
      update public.posts set downvote_count = greatest(downvote_count - 1, 0), upvote_count = upvote_count + 1 where id = new.post_id;
    end if;
    return new;
  end if;
  return null;
end;
$$ language plpgsql security definer;

create trigger on_post_vote_change
  after insert or update or delete on public.votes
  for each row execute function public.handle_post_vote();

-- Trigger to keep comment upvote counter in sync
create or replace function public.handle_comment_vote()
returns trigger as $$
begin
  if (tg_op = 'INSERT' and new.comment_id is not null and new.vote_type = 'up') then
    update public.comments set upvote_count = upvote_count + 1 where id = new.comment_id;
  elsif (tg_op = 'DELETE' and old.comment_id is not null and old.vote_type = 'up') then
    update public.comments set upvote_count = greatest(upvote_count - 1, 0) where id = old.comment_id;
  end if;
  return coalesce(new, old);
end;
$$ language plpgsql security definer;

create trigger on_comment_vote_change
  after insert or delete on public.votes
  for each row execute function public.handle_comment_vote();

comment on table public.posts    is 'Feed/thread posts — the main content entity.';
comment on table public.comments is 'Nested comments on posts — supports unlimited depth via parent_id.';
comment on table public.votes    is 'Upvote/downvote tracking for posts and comments.';
