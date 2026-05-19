-- ============================================================================
-- Migration 00001: Universities
-- Stores university metadata for multi-campus support.
-- ============================================================================

create extension if not exists "uuid-ossp";

create table public.universities (
  id            uuid primary key default uuid_generate_v4(),
  name          text not null unique,
  region        text not null default '',
  logo_text     text not null default '',
  description   text not null default '',
  member_count  int  not null default 0,
  activity_score int not null default 0,
  created_at    timestamptz not null default now()
);

-- Enable RLS (policies added in migration 00009)
alter table public.universities enable row level security;

comment on table public.universities is 'Registry of supported universities.';
