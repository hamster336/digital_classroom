import { supabase } from "./supabase-client"; // ✅ fixed import

export const signUp = async (email: string, password: string) => { 
  const { data, error } = await supabase.auth.signUp({
    email,
    password,
  });

  if (error) throw error;

  return {
    user: data.user,
    session: data.session,
  };
};