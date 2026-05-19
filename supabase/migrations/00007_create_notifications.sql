-- ============================================================================
-- Migration 00007: Notifications
-- In-app notifications with type categorization and read tracking.
-- ============================================================================

create table public.notifications (
  id         uuid primary key default uuid_generate_v4(),
  user_id    uuid not null references public.profiles(id) on delete cascade,
  type       text not null default 'general' check (type in ('comment', 'carpool', 'club', 'marketplace', 'general')),
  message    text not null,
  is_read    boolean not null default false,
  has_action boolean not null default false,
  avatar_url text,
  created_at timestamptz not null default now()
);

create index idx_notifications_user    on public.notifications(user_id);
create index idx_notifications_unread  on public.notifications(user_id) where is_read = false;

alter table public.notifications enable row level security;

-- Enable Realtime for live notification badges
alter publication supabase_realtime add table public.notifications;

-- Auto-create a notification when someone comments on your post
create or replace function public.notify_on_comment()
returns trigger as $$
declare
  post_author_id uuid;
  commenter_name text;
begin
  -- Get the post author
  select author_id into post_author_id from public.posts where id = new.post_id;

  -- Don't notify yourself
  if post_author_id = new.author_id then
    return new;
  end if;

  -- Get commenter name
  select full_name into commenter_name from public.profiles where id = new.author_id;

  insert into public.notifications (user_id, type, message)
  values (
    post_author_id,
    'comment',
    coalesce(commenter_name, 'Someone') || ' commented on your post.'
  );

  -- Also give the post author karma
  update public.profiles set karma_score = karma_score + 1 where id = post_author_id;

  return new;
end;
$$ language plpgsql security definer;

create trigger on_comment_notify
  after insert on public.comments
  for each row execute function public.notify_on_comment();

comment on table public.notifications is 'In-app notification center — comment, carpool, marketplace, and general alerts.';
