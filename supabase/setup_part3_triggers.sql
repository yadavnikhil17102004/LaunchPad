-- LaunchPad Database Schema - Part 3: TRIGGERS & SAMPLE DATA
-- Run this AFTER Part 2 succeeds

-- ========================================
-- FUNCTIONS & TRIGGERS
-- ========================================

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

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS opportunities_updated_at ON public.opportunities;
CREATE TRIGGER opportunities_updated_at
  BEFORE UPDATE ON public.opportunities
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS profiles_updated_at ON public.profiles;
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON public.profiles
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- ========================================
-- SAMPLE DATA
-- ========================================

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
