import { supabase } from "./client";

/**
 * FETCH ALL USERS WITH PROFILES
 * Correct: Matches your users, student, and teacher table names exactly.
 */
export const getAllUsersWithProfiles = async () => {
  const { data, error } = await supabase
    .from("users")
    .select(`
      *,
      student (*),
      teacher (*)
    `)
    .order("created_at", { ascending: false }); // Correct: created_at exists in users table

  if (error) throw error;
  return data;
};

/**
 * CREATE USER + PROFILE (Explicit Mapping)
 * Ensures frontend data maps to your specific DB columns.
 */
export const createFullUser = async (baseData, profileData) => {
  // 1. Insert into core 'users' table (id, full_name, email, role)
  const { data: user, error: userError } = await supabase
    .from("users")
    .insert([{
      full_name: baseData.fullName,
      email:     baseData.email,
      role:      baseData.role
    }])
    .select().single();

  if (userError) throw userError;

  const roleLower = baseData.role.toLowerCase();

  // 2. Profile insertion with explicit column mapping based on your screenshots
  if (roleLower === "student" && profileData) {
    const { error: profileError } = await supabase
      .from("student")
      .insert([{ 
        id:          user.id, 
        roll_number: profileData.rollNumber, 
        subject_ids: profileData.subjectIds, 
        class_id:    profileData.classId,
        avatar_url:  profileData.avatarUrl
      }]);
    if (profileError) throw profileError;
  } 
  else if (roleLower === "teacher" && profileData) {
    const { error: profileError } = await supabase
      .from("teacher")
      .insert([{ 
        id:          user.id, 
        employee_id: profileData.employeeId, 
        subject_ids: profileData.subjectIds, 
        class_ids:   profileData.classIds,   
        avatar_url:  profileData.avatarUrl
      }]);
    if (profileError) throw profileError;
  }

  return user;
};

/**
 * UPDATE PROFILE DATA
 * Explicitly maps based on the role to prevent column name errors.
 */
export const updateSpecificProfile = async (id, role, updates) => {
  const roleLower = role.toLowerCase();
  let mappedUpdates = {};

  if (roleLower === "student") {
    mappedUpdates = {
      roll_number: updates.rollNumber,
      subject_ids: updates.subjectIds,
      class_id:    updates.classId,
      avatar_url:  updates.avatarUrl
    };
  } else if (roleLower === "teacher") {
    mappedUpdates = {
      employee_id: updates.employeeId,
      subject_ids: updates.subjectIds,
      class_ids:   updates.classIds,
      avatar_url:  updates.avatarUrl
    };
  } else {
    return null;
  }
  
  const { data, error } = await supabase
    .from(roleLower)
    .update(mappedUpdates)
    .eq("id", id)
    .select().single();

  if (error) throw error;
  return data;
};