-- ============================================================================
-- Migration 00009: Row Level Security (RLS) Policies
-- Defines who can read/write data in the application.
-- ============================================================================

-- ── Universities ─────────────────────────────────────────────────────────────
create policy "Universities are viewable by authenticated users" 
  on public.universities for select using (auth.role() = 'authenticated');

-- ── Profiles ─────────────────────────────────────────────────────────────────
create policy "Profiles are viewable by authenticated users" 
  on public.profiles for select using (auth.role() = 'authenticated');

create policy "Users can update own profile" 
  on public.profiles for update 
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- ── Posts ────────────────────────────────────────────────────────────────────
-- Note: "Other Unis" feed requirement -> students can view posts from other universities (view only)
create policy "Posts are viewable by authenticated users" 
  on public.posts for select using (auth.role() = 'authenticated');

create policy "Users can insert posts in their own university" 
  on public.posts for insert 
  with check (
    auth.uid() = author_id 
    and university_id = (select university_id from public.profiles where id = auth.uid())
  );

create policy "Users can update own posts" 
  on public.posts for update 
  using (auth.uid() = author_id)
  with check (auth.uid() = author_id);

create policy "Users can delete own posts" 
  on public.posts for delete 
  using (auth.uid() = author_id);

-- ── Post Tags ────────────────────────────────────────────────────────────────
create policy "Post tags are viewable by authenticated users" 
  on public.post_tags for select using (auth.role() = 'authenticated');

create policy "Users can insert tags for own posts" 
  on public.post_tags for insert 
  with check (
    exists (select 1 from public.posts where id = post_id and author_id = auth.uid())
  );

create policy "Users can delete tags for own posts" 
  on public.post_tags for delete 
  using (
    exists (select 1 from public.posts where id = post_id and author_id = auth.uid())
  );

-- ── Comments ─────────────────────────────────────────────────────────────────
create policy "Comments are viewable by authenticated users" 
  on public.comments for select using (auth.role() = 'authenticated');

create policy "Users can insert comments in their own university posts" 
  on public.comments for insert 
  with check (
    auth.uid() = author_id
    and (select university_id from public.posts where id = post_id) = (select university_id from public.profiles where id = auth.uid())
  );

create policy "Users can update own comments" 
  on public.comments for update 
  using (auth.uid() = author_id)
  with check (auth.uid() = author_id);

create policy "Users can delete own comments" 
  on public.comments for delete 
  using (auth.uid() = author_id);

-- ── Votes ────────────────────────────────────────────────────────────────────
create policy "Votes are viewable by authenticated users" 
  on public.votes for select using (auth.role() = 'authenticated');

create policy "Users can insert votes in their own university posts/comments" 
  on public.votes for insert 
  with check (
    auth.uid() = user_id
    and (
      (post_id is not null and (select university_id from public.posts where id = post_id) = (select university_id from public.profiles where id = auth.uid()))
      or
      (comment_id is not null and (select university_id from public.posts where id = (select post_id from public.comments where id = comment_id)) = (select university_id from public.profiles where id = auth.uid()))
    )
  );

create policy "Users can update own votes in their own university" 
  on public.votes for update 
  using (auth.uid() = user_id)
  with check (
    auth.uid() = user_id
    and (
      (post_id is not null and (select university_id from public.posts where id = post_id) = (select university_id from public.profiles where id = auth.uid()))
      or
      (comment_id is not null and (select university_id from public.posts where id = (select post_id from public.comments where id = comment_id)) = (select university_id from public.profiles where id = auth.uid()))
    )
  );

create policy "Users can delete own votes" 
  on public.votes for delete 
  using (auth.uid() = user_id);

-- ── Project Listings ─────────────────────────────────────────────────────────
create policy "Project listings are viewable by authenticated users" 
  on public.project_listings for select using (auth.role() = 'authenticated');

create policy "Users can insert own project listings" 
  on public.project_listings for insert 
  with check (auth.uid() = creator_id);

create policy "Users can update own project listings" 
  on public.project_listings for update 
  using (auth.uid() = creator_id)
  with check (auth.uid() = creator_id);

create policy "Users can delete own project listings" 
  on public.project_listings for delete 
  using (auth.uid() = creator_id);

-- ── Project Skills ───────────────────────────────────────────────────────────
create policy "Project skills are viewable by authenticated users" 
  on public.project_skills for select using (auth.role() = 'authenticated');

create policy "Users can insert skills for own listings" 
  on public.project_skills for insert 
  with check (
    exists (select 1 from public.project_listings where id = listing_id and creator_id = auth.uid())
  );

create policy "Users can delete skills for own listings" 
  on public.project_skills for delete 
  using (
    exists (select 1 from public.project_listings where id = listing_id and creator_id = auth.uid())
  );

-- ── Carpool Rides ────────────────────────────────────────────────────────────
create policy "Carpool rides are viewable by authenticated users" 
  on public.carpool_rides for select using (auth.role() = 'authenticated');

create policy "Drivers can insert own rides" 
  on public.carpool_rides for insert 
  with check (auth.uid() = driver_id);

create policy "Drivers can update own rides" 
  on public.carpool_rides for update 
  using (auth.uid() = driver_id)
  with check (auth.uid() = driver_id);

create policy "Drivers can delete own rides" 
  on public.carpool_rides for delete 
  using (auth.uid() = driver_id);

-- ── Carpool Passengers ───────────────────────────────────────────────────────
create policy "Carpool passengers are viewable by authenticated users" 
  on public.carpool_passengers for select using (auth.role() = 'authenticated');

create policy "Users can join rides as passengers" 
  on public.carpool_passengers for insert 
  with check (auth.uid() = user_id);

create policy "Users can leave rides (delete own passenger record)" 
  on public.carpool_passengers for delete 
  using (auth.uid() = user_id);

-- ── Exchange Items ───────────────────────────────────────────────────────────
create policy "Exchange items are viewable by authenticated users" 
  on public.exchange_items for select using (auth.role() = 'authenticated');

create policy "Sellers can insert own exchange items" 
  on public.exchange_items for insert 
  with check (auth.uid() = seller_id);

create policy "Sellers can update own exchange items" 
  on public.exchange_items for update 
  using (auth.uid() = seller_id)
  with check (auth.uid() = seller_id);

create policy "Sellers can delete own exchange items" 
  on public.exchange_items for delete 
  using (auth.uid() = seller_id);

-- ── Cart Items ───────────────────────────────────────────────────────────────
create policy "Users can view own cart items" 
  on public.cart_items for select 
  using (auth.uid() = user_id);

create policy "Users can insert into own cart" 
  on public.cart_items for insert 
  with check (auth.uid() = user_id);

create policy "Users can update own cart items" 
  on public.cart_items for update 
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete from own cart" 
  on public.cart_items for delete 
  using (auth.uid() = user_id);

-- ── Notifications ────────────────────────────────────────────────────────────
create policy "Users can view own notifications" 
  on public.notifications for select 
  using (auth.uid() = user_id);

-- System creates notifications via triggers, but users might need to insert them for specific actions
create policy "Users can insert notifications" 
  on public.notifications for insert 
  with check (true);

create policy "Users can update own notifications" 
  on public.notifications for update 
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create policy "Users can delete own notifications" 
  on public.notifications for delete 
  using (auth.uid() = user_id);
