-- ============================================================================
-- Migration 00005: Carpool Rides & Passengers
-- Supports ride creation, joining, and automatic seat counter updates.
-- ============================================================================

create table public.carpool_rides (
  id                uuid primary key default uuid_generate_v4(),
  driver_id         uuid not null references public.profiles(id) on delete cascade,
  origin            text not null,
  destination       text not null,
  departure_time    text not null,
  departure_date    text not null default 'Today',
  total_seats       int  not null default 4,
  taken_seats       int  not null default 0,
  estimated_minutes int  not null default 0,
  filter_slot       text not null default 'all' check (filter_slot in ('all', 'morning', 'evening', 'weekend')),
  map_image_url     text,
  created_at        timestamptz not null default now(),

  constraint seats_check check (taken_seats >= 0 and taken_seats <= total_seats)
);

create index idx_carpool_rides_driver on public.carpool_rides(driver_id);

alter table public.carpool_rides enable row level security;

-- ── Passengers ───────────────────────────────────────────────────────────────

create table public.carpool_passengers (
  id        uuid primary key default uuid_generate_v4(),
  ride_id   uuid not null references public.carpool_rides(id) on delete cascade,
  user_id   uuid not null references public.profiles(id) on delete cascade,
  joined_at timestamptz not null default now(),

  -- A user can only join a ride once
  constraint unique_ride_passenger unique (ride_id, user_id)
);

create index idx_carpool_passengers_ride on public.carpool_passengers(ride_id);

alter table public.carpool_passengers enable row level security;

-- Auto-update taken_seats when a passenger joins or leaves
create or replace function public.handle_carpool_seats()
returns trigger as $$
begin
  if (tg_op = 'INSERT') then
    update public.carpool_rides set taken_seats = taken_seats + 1 where id = new.ride_id;
    return new;
  elsif (tg_op = 'DELETE') then
    update public.carpool_rides set taken_seats = greatest(taken_seats - 1, 0) where id = old.ride_id;
    return old;
  end if;
  return null;
end;
$$ language plpgsql security definer;

create trigger on_passenger_change
  after insert or delete on public.carpool_passengers
  for each row execute function public.handle_carpool_seats();

-- Increment ride count on driver profile (karma)
create or replace function public.handle_ride_karma()
returns trigger as $$
begin
  if (tg_op = 'INSERT') then
    update public.profiles set karma_score = karma_score + 5 where id = new.driver_id;
  end if;
  return new;
end;
$$ language plpgsql security definer;

create trigger on_ride_created_karma
  after insert on public.carpool_rides
  for each row execute function public.handle_ride_karma();

comment on table public.carpool_rides      is 'Carpool rides offered by drivers.';
comment on table public.carpool_passengers is 'Users who joined a carpool ride.';
