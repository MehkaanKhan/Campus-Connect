-- ============================================================================
-- Migration 00011: Project Applications
-- Allows students to apply to join project listings.
-- Creators can accept or reject applicants.
-- Applications are unlimited until the project creator marks it complete.
-- ============================================================================

create table public.project_applications (
  id            uuid primary key default uuid_generate_v4(),
  listing_id    uuid not null references public.project_listings(id) on delete cascade,
  applicant_id  uuid not null references public.profiles(id) on delete cascade,
  cover_message text not null default '',
  status        text not null default 'pending'
                  check (status in ('pending', 'accepted', 'rejected')),
  created_at    timestamptz not null default now(),

  -- A user can only apply once per project
  constraint unique_application unique (listing_id, applicant_id)
);

create index idx_project_apps_listing   on public.project_applications(listing_id);
create index idx_project_apps_applicant on public.project_applications(applicant_id);

alter table public.project_applications enable row level security;

-- ── RLS Policies ─────────────────────────────────────────────────────────────

-- Applicants can view their own applications
create policy "Applicants can view their own applications"
  on public.project_applications for select
  using (auth.uid() = applicant_id);

-- Project creators can view all applications to their listings
create policy "Project creators can view applications to their listings"
  on public.project_applications for select
  using (
    exists (
      select 1 from public.project_listings
      where id = listing_id and creator_id = auth.uid()
    )
  );

-- Users can submit applications (cannot apply to own project — enforced by check)
create policy "Users can apply to projects"
  on public.project_applications for insert
  with check (
    auth.uid() = applicant_id
    -- Prevent applying to own listing
    and not exists (
      select 1 from public.project_listings
      where id = listing_id and creator_id = auth.uid()
    )
  );

-- Project creators can update (accept/reject) the status
create policy "Project creators can update application status"
  on public.project_applications for update
  using (
    exists (
      select 1 from public.project_listings
      where id = listing_id and creator_id = auth.uid()
    )
  )
  with check (
    exists (
      select 1 from public.project_listings
      where id = listing_id and creator_id = auth.uid()
    )
  );

-- Applicants can withdraw their own application
create policy "Applicants can delete their own applications"
  on public.project_applications for delete
  using (auth.uid() = applicant_id);

comment on table public.project_applications is 'Applications from students to join project partner listings.';
