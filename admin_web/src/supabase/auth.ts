import { supabase } from './supabase-client'; 

/** LOGIN */
export const loginAdmin = async (email: string, password: string) => { 
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) throw error; // throw instead of return error

  return {
    user: data.user,
    session: data.session,
  };
};

/** LOGOUT */
export const logoutAdmin = async () => {
  const { error } = await supabase.auth.signOut();

  if (error) throw error; //  throw instead of return error

  return { success: true };
};

/** GET CURRENT USER  if any admin user is logged in*/
export const getCurrentAdmin = async () => {
  const { data, error } = await supabase.auth.getUser();

  if (error) throw error; //  throw instead of return null

  return data.user;
};