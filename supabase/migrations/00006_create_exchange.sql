-- ============================================================================
-- Migration 00006: Exchange Items & Cart
-- Hostellite marketplace — items for borrow/rent/giveaway + shopping cart.
-- ============================================================================

create table public.exchange_items (
  id          uuid primary key default uuid_generate_v4(),
  seller_id   uuid not null references public.profiles(id) on delete cascade,
  title       text not null,
  description text not null default '',
  item_type   text not null default 'borrow' check (item_type in ('borrow', 'rent', 'free')),
  price       decimal(10,2),
  price_unit  text,
  condition   text not null default 'good' check (condition in ('brand_new', 'like_new', 'good', 'fair')),
  image_url   text,
  is_available boolean not null default true,
  created_at  timestamptz not null default now()
);

create index idx_exchange_items_seller on public.exchange_items(seller_id);

alter table public.exchange_items enable row level security;

-- ── Cart ─────────────────────────────────────────────────────────────────────

create table public.cart_items (
  id       uuid primary key default uuid_generate_v4(),
  user_id  uuid not null references public.profiles(id) on delete cascade,
  item_id  uuid not null references public.exchange_items(id) on delete cascade,
  quantity int  not null default 1 check (quantity > 0),

  -- A user can only have one cart entry per item (update quantity instead)
  constraint unique_cart_entry unique (user_id, item_id)
);

create index idx_cart_items_user on public.cart_items(user_id);

alter table public.cart_items enable row level security;

comment on table public.exchange_items is 'Hostellite marketplace items — borrow, rent, or giveaway.';
comment on table public.cart_items     is 'User shopping cart for exchange items.';
