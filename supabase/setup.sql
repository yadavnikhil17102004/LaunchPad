-- LaunchPad Database Schema
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/_/sql

-- ========================================
-- 1. CREATE TABLES
-- ========================================

-- Opportunities Table
CREATE TABLE IF NOT EXISTS public.opportunities (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  title TEXT NOT NULL,
  type TEXT NOT NULL CHECK (type IN ('hackathon', 'internship', 'contest')),
  organization TEXT NOT NULL,
  description TEXT,
  deadline TIMESTAMPTZ NOT NULL,
  apply_url TEXT NOT NULL,
  location TEXT,
  prize TEXT,
  tags TEXT[] DEFAULT '{}',
  source TEXT,
  is_featured BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id)
);

-- User Profiles Table
CREATE TABLE IF NOT EXISTS public.profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  bio TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Favorites Table (Many-to-Many)
CREATE TABLE IF NOT EXISTS public.favorites (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  opportunity_id UUID REFERENCES public.opportunities(id) ON DELETE CASCADE NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, opportunity_id)
);

-- Admins Table
CREATE TABLE IF NOT EXISTS public.admins (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL UNIQUE,
  role TEXT DEFAULT 'admin' CHECK (role IN ('admin', 'super_admin')),
  granted_by UUID REFERENCES auth.users(id),
  granted_at TIMESTAMPTZ DEFAULT NOW()
);

-- ========================================
-- 2. CREATE INDEXES FOR PERFORMANCE
-- ========================================

CREATE INDEX IF NOT EXISTS idx_opportunities_type ON public.opportunities(type);
CREATE INDEX IF NOT EXISTS idx_opportunities_deadline ON public.opportunities(deadline);
CREATE INDEX IF NOT EXISTS idx_opportunities_created_at ON public.opportunities(created_at);
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON public.favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_opportunity_id ON public.favorites(opportunity_id);
CREATE INDEX IF NOT EXISTS idx_admins_user_id ON public.admins(user_id);

-- ========================================
-- 3. ENABLE ROW LEVEL SECURITY (RLS)
-- ========================================

ALTER TABLE public.opportunities ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;

-- ========================================
-- 4. CREATE RLS POLICIES
-- ========================================

-- Opportunities Policies
-- Anyone can view opportunities
CREATE POLICY "Anyone can view opportunities"
  ON public.opportunities FOR SELECT
  USING (true);

-- Only admins can insert opportunities
CREATE POLICY "Only admins can insert opportunities"
  ON public.opportunities FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Only admins can update opportunities
CREATE POLICY "Only admins can update opportunities"
  ON public.opportunities FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Only admins can delete opportunities
CREATE POLICY "Only admins can delete opportunities"
  ON public.opportunities FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid()
    )
  );

-- Profiles Policies
-- Anyone can view profiles
CREATE POLICY "Anyone can view profiles"
  ON public.profiles FOR SELECT
  USING (true);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
  ON public.profiles FOR INSERT
  WITH CHECK (auth.uid() = id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Favorites Policies
-- Users can view their own favorites
CREATE POLICY "Users can view own favorites"
  ON public.favorites FOR SELECT
  USING (auth.uid() = user_id);

-- Users can insert their own favorites
CREATE POLICY "Users can insert own favorites"
  ON public.favorites FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own favorites
CREATE POLICY "Users can delete own favorites"
  ON public.favorites FOR DELETE
  USING (auth.uid() = user_id);

-- Admins Policies
-- Only super_admins can view admins table
CREATE POLICY "Only super_admins can view admins"
  ON public.admins FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid() AND admins.role = 'super_admin'
    )
  );

-- Only super_admins can manage admins
CREATE POLICY "Only super_admins can insert admins"
  ON public.admins FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid() AND admins.role = 'super_admin'
    )
  );

CREATE POLICY "Only super_admins can delete admins"
  ON public.admins FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM public.admins
      WHERE admins.user_id = auth.uid() AND admins.role = 'super_admin'
    )
  );

-- ========================================
-- 5. CREATE FUNCTIONS & TRIGGERS
-- ========================================

-- Function to automatically create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name, avatar_url)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'full_name',
    NEW.raw_user_meta_data->>'avatar_url'
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to create profile on user signup
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
DROP TRIGGER IF EXISTS opportunities_updated_at ON public.opportunities;
CREATE TRIGGER opportunities_updated_at
  BEFORE UPDATE ON public.opportunities
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS profiles_updated_at ON public.profiles;
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ========================================
-- 6. INSERT SAMPLE DATA (OPTIONAL)
-- ========================================

-- Sample opportunities (you can remove this if you want)
INSERT INTO public.opportunities (title, type, organization, description, deadline, apply_url, location, prize, tags, source)
VALUES
  (
    'Smart India Hackathon 2025',
    'hackathon',
    'Government of India',
    'India''s largest open innovation model. Solve real government problems!',
    NOW() + INTERVAL '30 days',
    'https://sih.gov.in/',
    'India (Multiple Cities)',
    '₹1,00,000',
    ARRAY['Government', 'Innovation', 'National'],
    'SIH (Curated)'
  ),
  (
    'Google Summer of Code 2025',
    'internship',
    'Google',
    'Work with open source organizations and get paid for your contributions',
    NOW() + INTERVAL '45 days',
    'https://summerofcode.withgoogle.com/',
    'Remote',
    '$3,000 - $6,600',
    ARRAY['Open Source', 'Remote', 'Paid'],
    'GSoC (Curated)'
  ),
  (
    'LeetCode Weekly Contest 500',
    'contest',
    'LeetCode',
    'Weekly competitive programming contest with exciting problems',
    NOW() + INTERVAL '7 days',
    'https://leetcode.com/contest/',
    'Virtual',
    NULL,
    ARRAY['Competitive Programming', 'Algorithms', 'DSA'],
    'LeetCode (Curated)'
  )
ON CONFLICT DO NOTHING;

-- ========================================
-- 7. CREATE YOUR FIRST ADMIN (IMPORTANT!)
-- ========================================

-- ⚠️ IMPORTANT: Replace 'YOUR_EMAIL_HERE' with your actual email
-- Run this AFTER you've signed up on your app
-- Find your user_id in: Authentication → Users in Supabase dashboard

-- Step 1: Sign up on your app first
-- Step 2: Check auth.users table to get your user ID
-- Step 3: Run this query with your user_id:

-- INSERT INTO public.admins (user_id, role)
-- VALUES (
--   'your-user-id-here', -- Replace with your actual user ID from auth.users
--   'super_admin'
-- );

-- Or use this helper to make yourself admin automatically:
-- (Only works if you're the ONLY user who signed up, otherwise specify user_id)
-- INSERT INTO public.admins (user_id, role)
-- SELECT id, 'super_admin'
-- FROM auth.users
-- WHERE email = 'yadavnikhil17102004@gmail.com' -- Replace with your email
-- ON CONFLICT (user_id) DO NOTHING;

-- ========================================
-- DONE! ✅
-- ========================================

-- Next steps:
-- 1. Verify all tables were created: Go to Table Editor
-- 2. Check RLS policies: Go to Authentication → Policies
-- 3. Create your first admin user (see section 7 above)
-- 4. Test the setup by signing up on your app
