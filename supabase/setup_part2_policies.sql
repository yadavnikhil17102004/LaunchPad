-- LaunchPad Database Schema - Part 2: RLS POLICIES
-- Run this AFTER Part 1 succeeds

-- ========================================
-- ENABLE ROW LEVEL SECURITY
-- ========================================

ALTER TABLE public.opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;

-- ========================================
-- RLS POLICIES FOR OPPORTUNITIES
-- ========================================

DROP POLICY IF EXISTS "Anyone can view opportunities" ON public.opportunities;
CREATE POLICY "Anyone can view opportunities"
  ON public.opportunities FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Only admins can insert opportunities" ON public.opportunities;
CREATE POLICY "Only admins can insert opportunities"
  ON public.opportunities FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Only admins can update opportunities" ON public.opportunities;
CREATE POLICY "Only admins can update opportunities"
  ON public.opportunities FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

DROP POLICY IF EXISTS "Only admins can delete opportunities" ON public.opportunities;
CREATE POLICY "Only admins can delete opportunities"
  ON public.opportunities FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- ========================================
-- RLS POLICIES FOR PROFILES
-- ========================================

DROP POLICY IF EXISTS "Anyone can view profiles" ON public.profiles;
CREATE POLICY "Anyone can view profiles"
  ON public.profiles FOR SELECT
  USING (true);

DROP POLICY IF EXISTS "Users can insert own profile" ON public.profiles;
CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

DROP POLICY IF EXISTS "Users can update own profile" ON public.profiles;
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id);

-- ========================================
-- RLS POLICIES FOR FAVORITES
-- ========================================

DROP POLICY IF EXISTS "Users can view own favorites" ON public.favorites;
CREATE POLICY "Users can view own favorites"
  ON public.favorites FOR SELECT
  USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own favorites" ON public.favorites;
CREATE POLICY "Users can insert own favorites"
  ON public.favorites FOR INSERT
  WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own favorites" ON public.favorites;
CREATE POLICY "Users can delete own favorites"
  ON public.favorites FOR DELETE
  USING (auth.uid() = user_id);

-- ========================================
-- RLS POLICIES FOR ADMINS
-- ========================================

DROP POLICY IF EXISTS "Only super_admins can view admins" ON public.admins;
CREATE POLICY "Only super_admins can view admins"
  ON public.admins FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid() AND admins.role = 'super_admin'
    )
  );

DROP POLICY IF EXISTS "Only super_admins can insert admins" ON public.admins;
CREATE POLICY "Only super_admins can insert admins"
  ON public.admins FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid() AND admins.role = 'super_admin'
    )
  );

DROP POLICY IF EXISTS "Only super_admins can delete admins" ON public.admins;
CREATE POLICY "Only super_admins can delete admins"
  ON public.admins FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid() AND admins.role = 'super_admin'
    )
  );
