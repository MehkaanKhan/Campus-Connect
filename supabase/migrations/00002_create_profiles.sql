-- ============================================================================
-- Migration 00002: Profiles
-- Extends Supabase auth.users with app-specific profile data.
-- A trigger auto-creates a row when a new user signs up.
-- .edu email enforcement is handled by a CHECK constraint.
-- ============================================================================

create table public.profiles (
  id               uuid primary key references auth.users(id) on delete cascade,
  full_name        text not null default '',
  email            text not null unique,
  department       text not null default '',
  semester         text not null default '',
  bio              text not null default '',
  avatar_url       text,
  university_id    uuid references public.universities(id) on delete set null,
  karma_score      int  not null default 0,
  onboarding_seen  boolean not null default false,
  created_at       timestamptz not null default now(),
  updated_at       timestamptz not null default now(),

  -- Enforce .edu email addresses at the database level
  constraint email_must_be_edu check (email ~* '^[^@]+@[^@]+\.edu(\.[a-z]{2,})?$')
);

-- Index for fast university-based lookups (other unis feed)
create index idx_profiles_university on public.profiles(university_id);

-- Auto-update the updated_at timestamp on every profile change
create or replace function public.handle_updated_at()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql security definer;

create trigger on_profile_updated
  before update on public.profiles
  for each row execute function public.handle_updated_at();

-- Auto-create a profile row when a new user signs up via Supabase Auth
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id, email, full_name)
  values (
    new.id,
    new.email,
    coalesce(new.raw_user_meta_data->>'full_name', '')
  );
  return new;
end;
$$ language plpgsql security definer;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- Enable RLS (policies added in migration 00009)
alter table public.profiles enable row level security;

-- Enable Realtime for profiles (for live avatar/name updates)
alter publication supabase_realtime add table public.profiles;

comment on table public.profiles is 'User profiles — extends auth.users with campus-specific data.';
