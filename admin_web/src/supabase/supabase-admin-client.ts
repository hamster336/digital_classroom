import { createClient } from "@supabase/supabase-js";

export const supabaseAdmin = createClient(
  "https://ksebauxqprpstdvmwwse.supabase.co",
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzZWJhdXhxcHJwc3Rkdm13d3NlIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc2Nzk2NzcwMiwiZXhwIjoyMDgzNTQzNzAyfQ.GMDrzgFPb1g8SNlHXMo-Azq4JMC2KXdWpgpI_HFhuv4" 
);