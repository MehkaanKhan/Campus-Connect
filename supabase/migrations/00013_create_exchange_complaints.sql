-- ============================================================================
-- Migration 00013: Exchange Complaints
-- Allow students to report issues with items on the exchange board.
-- ============================================================================

create table public.exchange_complaints (
  id          uuid primary key default uuid_generate_v4(),
  item_id     uuid not null references public.exchange_items(id) on delete cascade,
  reporter_id uuid not null references public.profiles(id) on delete cascade,
  reason      text not null,
  details     text not null,
  status      text not null default 'pending' check (status in ('pending', 'reviewed', 'resolved', 'dismissed')),
  created_at  timestamptz not null default now()
);

create index idx_exchange_complaints_item on public.exchange_complaints(item_id);
create index idx_exchange_complaints_reporter on public.exchange_complaints(reporter_id);

alter table public.exchange_complaints enable row level security;

create policy "Complaints are viewable by authenticated users"
  on public.exchange_complaints for select
  using (auth.role() = 'authenticated');

create policy "Users can insert own complaints"
  on public.exchange_complaints for insert
  with check (auth.uid() = reporter_id);

create policy "Users can update own complaints"
  on public.exchange_complaints for update
  using (auth.uid() = reporter_id)
  with check (auth.uid() = reporter_id);

create policy "Users can delete own complaints"
  on public.exchange_complaints for delete
  using (auth.uid() = reporter_id);

comment on table public.exchange_complaints is 'Complaints submitted by users regarding exchange items.';
