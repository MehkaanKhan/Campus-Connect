-- ============================================================================
-- Migration 00008: Views
-- Database views for leaderboard and university graph visualization.
-- Defined with security_invoker = true to respect underlying RLS policies.
-- ============================================================================

-- ── Leaderboard View ─────────────────────────────────────────────────────────
-- Ranks users by karma_score descending. The Flutter app reads from this view.

create or replace view public.leaderboard_view
with (security_invoker = true) as
select
  p.id,
  p.full_name  as name,
  p.department,
  p.karma_score as score,
  coalesce(p.avatar_url, '') as avatar_url,
  row_number() over (order by p.karma_score desc) as rank
from public.profiles p
where p.full_name != ''
order by p.karma_score desc;

comment on view public.leaderboard_view is 'Ranked leaderboard of users by karma score.';

-- Revoke public access and grant select only to authenticated users
revoke all on public.leaderboard_view from public;
revoke all on public.leaderboard_view from anon;
grant select on public.leaderboard_view to authenticated;

-- ── University Graph View ────────────────────────────────────────────────────
-- Aggregates university activity for the network visualization.

create or replace view public.uni_graph_view
with (security_invoker = true) as
select
  u.id,
  u.name,
  u.activity_score,
  u.member_count,
  (select count(*) from public.profiles p where p.university_id = u.id) as actual_members
from public.universities u
order by u.activity_score desc;

comment on view public.uni_graph_view is 'University network graph data.';

-- Revoke public access and grant select only to authenticated users
revoke all on public.uni_graph_view from public;
revoke all on public.uni_graph_view from anon;
grant select on public.uni_graph_view to authenticated;
