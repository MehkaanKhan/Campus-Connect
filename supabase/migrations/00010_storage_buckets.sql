-- ============================================================================
-- Migration 00010: Storage Buckets
-- Creates storage buckets for avatars and post images with RLS policies.
-- ============================================================================

-- ── Avatars Bucket ───────────────────────────────────────────────────────────
insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true)
on conflict (id) do nothing;

create policy "Avatars are publicly accessible"
  on storage.objects for select
  using ( bucket_id = 'avatars' );

create policy "Users can upload their own avatar"
  on storage.objects for insert
  with check ( bucket_id = 'avatars' and auth.uid() = owner );

create policy "Users can update their own avatar"
  on storage.objects for update
  using ( bucket_id = 'avatars' and auth.uid() = owner );

create policy "Users can delete their own avatar"
  on storage.objects for delete
  using ( bucket_id = 'avatars' and auth.uid() = owner );

-- ── Post Images Bucket ───────────────────────────────────────────────────────
insert into storage.buckets (id, name, public)
values ('post-images', 'post-images', true)
on conflict (id) do nothing;

create policy "Post images are publicly accessible"
  on storage.objects for select
  using ( bucket_id = 'post-images' );

create policy "Users can upload post images"
  on storage.objects for insert
  with check ( bucket_id = 'post-images' and auth.uid() = owner );

create policy "Users can update their own post images"
  on storage.objects for update
  using ( bucket_id = 'post-images' and auth.uid() = owner );

create policy "Users can delete their own post images"
  on storage.objects for delete
  using ( bucket_id = 'post-images' and auth.uid() = owner );
