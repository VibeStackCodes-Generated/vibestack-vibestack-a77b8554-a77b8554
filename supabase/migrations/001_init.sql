CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TABLE IF NOT EXISTS profiles (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  display_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view all profiles" ON profiles FOR SELECT TO authenticated USING (true);

CREATE POLICY "Users can update own profile" ON profiles FOR UPDATE TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can insert own profile" ON profiles FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

CREATE INDEX idx_profiles_user_id ON profiles (user_id);

CREATE TRIGGER trg_profiles_updated_at BEFORE UPDATE ON profiles FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TABLE IF NOT EXISTS wards (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  floor TEXT,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE wards ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own wards" ON wards FOR SELECT TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can insert own wards" ON wards FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "Users can update own wards" ON wards FOR UPDATE TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can delete own wards" ON wards FOR DELETE TO authenticated USING ((select auth.uid()) = user_id);

CREATE INDEX idx_wards_user_id ON wards (user_id);

CREATE TRIGGER trg_wards_updated_at BEFORE UPDATE ON wards FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TABLE IF NOT EXISTS messages (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  content TEXT NOT NULL,
  channel_id TEXT NOT NULL DEFAULT 'default',
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view messages" ON messages FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can send messages" ON messages FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

CREATE INDEX idx_messages_user_id ON messages (user_id);

CREATE TABLE IF NOT EXISTS beds (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE beds ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own beds" ON beds FOR SELECT TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can insert own beds" ON beds FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "Users can update own beds" ON beds FOR UPDATE TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can delete own beds" ON beds FOR DELETE TO authenticated USING ((select auth.uid()) = user_id);

CREATE INDEX idx_beds_user_id ON beds (user_id);

CREATE TRIGGER trg_beds_updated_at BEFORE UPDATE ON beds FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TABLE IF NOT EXISTS assignments (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID NOT NULL,
  assignment_role TEXT NOT NULL,
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  ward_id UUID NOT NULL REFERENCES wards(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE assignments ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own assignments" ON assignments FOR SELECT TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can insert own assignments" ON assignments FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "Users can update own assignments" ON assignments FOR UPDATE TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can delete own assignments" ON assignments FOR DELETE TO authenticated USING ((select auth.uid()) = user_id);

CREATE INDEX idx_assignments_profile_id ON assignments (profile_id);

CREATE INDEX idx_assignments_ward_id ON assignments (ward_id);

CREATE TRIGGER trg_assignments_updated_at BEFORE UPDATE ON assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TABLE IF NOT EXISTS patients (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  mrn TEXT NOT NULL,
  full_name TEXT NOT NULL,
  dob TIMESTAMPTZ,
  primary_physician_id UUID,
  ward_id UUID NOT NULL REFERENCES wards(id) ON DELETE CASCADE,
  bed_id UUID NOT NULL REFERENCES beds(id) ON DELETE CASCADE,
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE patients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own patients" ON patients FOR SELECT TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can insert own patients" ON patients FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "Users can update own patients" ON patients FOR UPDATE TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can delete own patients" ON patients FOR DELETE TO authenticated USING ((select auth.uid()) = user_id);

CREATE INDEX idx_patients_ward_id ON patients (ward_id);

CREATE INDEX idx_patients_bed_id ON patients (bed_id);

CREATE INDEX idx_patients_profile_id ON patients (profile_id);

CREATE INDEX idx_patients_user_id ON patients (user_id);

CREATE TRIGGER trg_patients_updated_at BEFORE UPDATE ON patients FOR EACH ROW EXECUTE FUNCTION update_updated_at();

CREATE TABLE IF NOT EXISTS clinical_notes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  author_id UUID NOT NULL,
  note TEXT NOT NULL,
  patient_id UUID NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
  profile_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE clinical_notes ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own clinical_notes" ON clinical_notes FOR SELECT TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can insert own clinical_notes" ON clinical_notes FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);

CREATE POLICY "Users can update own clinical_notes" ON clinical_notes FOR UPDATE TO authenticated USING ((select auth.uid()) = user_id);

CREATE POLICY "Users can delete own clinical_notes" ON clinical_notes FOR DELETE TO authenticated USING ((select auth.uid()) = user_id);

CREATE INDEX idx_clinical_notes_patient_id ON clinical_notes (patient_id);

CREATE INDEX idx_clinical_notes_profile_id ON clinical_notes (profile_id);

CREATE INDEX idx_clinical_notes_user_id ON clinical_notes (user_id);

CREATE TRIGGER trg_clinical_notes_updated_at BEFORE UPDATE ON clinical_notes FOR EACH ROW EXECUTE FUNCTION update_updated_at();