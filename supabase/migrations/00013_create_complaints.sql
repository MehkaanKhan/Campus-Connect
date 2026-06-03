-- Complaints table for Hostellite Exchange Board
create table if not exists complaints (
  id          uuid primary key default gen_random_uuid(),
  reporter_id uuid references profiles(id) on delete cascade not null,
  item_id     uuid references exchange_items(id) on delete cascade not null,
  reason      text not null,
  details     text not null,
  created_at  timestamptz default now() not null
);

alter table complaints enable row level security;

-- Users can only insert complaints they own
create policy "users insert own complaints"
  on complaints for insert
  with check (auth.uid() = reporter_id);

-- Users can view their own complaints
create policy "users view own complaints"
  on complaints for select
  using (auth.uid() = reporter_id);
