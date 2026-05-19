-- ============================================================================
-- Migration 00004: Project Listings & Skills
-- Stores project partner listings with required skills.
-- ============================================================================

create table public.project_listings (
  id          uuid primary key default uuid_generate_v4(),
  creator_id  uuid not null references public.profiles(id) on delete cascade,
  badge       text not null default 'ACADEMIC PROJECT',
  badge_color text not null default '#8B6F4E',
  title       text not null,
  description text not null default '',
  created_at  timestamptz not null default now()
);

create index idx_project_listings_creator on public.project_listings(creator_id);

alter table public.project_listings enable row level security;

-- ── Skills required for a project listing ────────────────────────────────────

create table public.project_skills (
  id         uuid primary key default uuid_generate_v4(),
  listing_id uuid not null references public.project_listings(id) on delete cascade,
  skill_name text not null
);

create index idx_project_skills_listing on public.project_skills(listing_id);

alter table public.project_skills enable row level security;

comment on table public.project_listings is 'Project partner listing posts.';
comment on table public.project_skills   is 'Skills required for a project listing.';
