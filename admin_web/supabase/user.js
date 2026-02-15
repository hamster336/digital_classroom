import { supabase } from "./client";

/**
 * FETCH ALL USERS
 * Joins both tables; data will appear in 'student' or 'teacher' keys.
 * Admins will simply have 'null' for both profile keys.
 */
export const getAllUsersWithProfiles = async () => {
  const { data, error } = await supabase
    .from("users")
    .select(`
      *,
      student (*),
      teacher (*)
    `)
    .order("created_at", { ascending: false });

  if (error) throw error;
  return data;
};


/**
 * FETCH SINGLE USER BY ID (DYNAMIC)
 * Updated to handle roles that don't have extra profile tables (like Admin)
 */
export const getUserFullProfile = async (id, role) => {
  const roleLower = role.toLowerCase();
  
  // Define which roles actually have extra profile tables
  const rolesWithProfiles = ["student", "teacher"];
  const hasProfile = rolesWithProfiles.includes(roleLower);

  // Build the query string dynamically
  // If admin, we just select '*', if student/teacher, we join the profile
  const query = hasProfile 
    ? `*, profile: ${roleLower} (*)` 
    : `*`;

  const { data, error } = await supabase
    .from("users")
    .select(query)
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};



/**
 * CREATE USER + PROFILE
 * Now checks if the role needs a second insert
 */
export const createFullUser = async (baseData, profileData) => {
  // 1. Insert into core 'users' table
  const { data: user, error: userError } = await supabase
    .from("users")
    .insert([baseData])
    .select()
    .single();

  if (userError) throw userError;

  const roleLower = baseData.role.toLowerCase();
  const rolesWithProfiles = ["student", "teacher"];

  // 2. Only insert into a profile table if the role requires it
  if (rolesWithProfiles.includes(roleLower) && profileData) {
    const { data: profile, error: profileError } = await supabase
      .from(roleLower)
      .insert([{ ...profileData, id: user.id }])
      .select()
      .single();

    if (profileError) throw profileError;
    return { ...user, profile };
  }

  // If Admin or no profile needed, just return the user
  return { ...user, profile: null };
};



/**
 * UPDATE PROFILE DATA
 * Added a guard clause to prevent errors if trying to update an Admin profile
 */
export const updateSpecificProfile = async (id, role, updates) => {
  const roleLower = role.toLowerCase();
  const rolesWithProfiles = ["student", "teacher"];

  if (!rolesWithProfiles.includes(roleLower)) {
    // Admins don't have a separate profile table to update
    console.warn("This role does not have a separate profile table.");
    return null;
  }
  
  const { data, error } = await supabase
    .from(roleLower)
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};


/**
 * DELETE USER
 * Because of "On Delete Cascade" in your Database, 
 * deleting from 'users' automatically handles everything.
 */
export const deleteUserFull = async (id) => {
  const { data, error } = await supabase
    .from("users")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return data;
};