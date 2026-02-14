import { supabase } from './supabase-client';

/**
 * LOGIN (Email + Password)
 */
export const loginAdmin = async (email, password) => {
  const { data, error } = await supabase.auth.signInWithPassword({
    email,
    password,
  });

  if (error) {
    return { error: error.message };
  }

  return {
    user: data.user,
    session: data.session,
  };
};

/**
 * LOGOUT
 */
export const logoutAdmin = async () => {
  const { error } = await supabase.auth.signOut();

  if (error) {
    return { error: error.message };
  }

  return { success: true };
};

/**
 * GET CURRENT USER (koi admin user already logged in xa ki nai)
 */
export const getCurrentAdmin = async () => {
  const { data, error } = await supabase.auth.getUser();

  if (error) {
    return null;
  }

  return data.user;
};
