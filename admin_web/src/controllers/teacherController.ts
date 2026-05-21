import { Teacher } from "../models/teacher";
import { User } from "../models/user";

import {
  createTeacherDB,
  getAllTeachersDB,
  getTeacherByIdDB,
  updateTeacherDB,
  deleteTeacherDB,
  uploadTeacherAvatarDB,
} from "../supabase/teacher";

import { deleteUserDB } from "../supabase/user";

import { supabaseAdmin } from "../supabase/supabase-admin-client";

// ─── Create Teacher ───────────────────────────────────────────────────────────

export const createTeacher = async (
  fullName: string,
  email: string,
  employeeId: string,
  subjectIds: string[] = [],
  classIds: string[] = [],
  avatarFile: File | null = null
): Promise<Teacher> => {

  const password = "@user123";

  // Step 1: Create Auth User
  const { data: authData, error: authError } =
    await supabaseAdmin.auth.admin.createUser({
      email,
      password,
      email_confirm: true,
    });

  if (authError) throw authError;
  if (!authData.user) throw new Error("Failed to create auth user.");

  const userId = authData.user.id;

  // Step 2: Upload Avatar (optional)
  let finalAvatarPath: string | null = null;

  if (avatarFile) {
    try {
      finalAvatarPath = await uploadTeacherAvatarDB(avatarFile, userId);
    } catch (uploadErr) {
      console.error("Avatar upload failed:", uploadErr);
    }
  }

  // Step 3: Insert into users table (full_name and email live here)
  const user = new User(
    userId,
    fullName,
    email,
    "teacher",
    new Date().toISOString()
  );

  const { error: userInsertError } = await supabaseAdmin
    .from("users")
    .insert([user.toInsertMap()]);

  if (userInsertError) throw userInsertError;

  // Step 4: Insert into teacher table (no full_name/email — those are in users)
  const teacher = new Teacher(
    userId,
    fullName,  // kept in memory/model only
    email,     // kept in memory/model only
    employeeId,
    subjectIds,
    classIds,
    finalAvatarPath
  );

  return await createTeacherDB(teacher);
};

// ─── Get All Teachers ─────────────────────────────────────────────────────────

export const getAllTeachers = async (): Promise<Teacher[]> => {
  return await getAllTeachersDB();
};

// ─── Get Teacher By ID ────────────────────────────────────────────────────────

export const getTeacherById = async (
  id: string
): Promise<Teacher | null> => {
  return await getTeacherByIdDB(id);
};

// ─── Update Teacher ───────────────────────────────────────────────────────────

export const updateTeacher = async (
  id: string,
  updates: Partial<Teacher>
): Promise<Teacher | null> => {

  // If fullName is being updated, save it to the users table (not teacher table)
  if (updates.fullName !== undefined) {
    const { error: userUpdateError } = await supabaseAdmin
      .from("users")
      .update({ full_name: updates.fullName })
      .eq("id", id);

    if (userUpdateError) {
      console.warn("Failed to update full_name in users:", userUpdateError.message);
    }
  }

  return await updateTeacherDB(id, updates);
};

// ─── Delete Teacher ───────────────────────────────────────────────────────────

export const deleteTeacher = async (id: string): Promise<boolean> => {
  const teacher = await getTeacherByIdDB(id);

  if (!teacher) return false;

  await deleteTeacherDB(id);
  await deleteUserDB(id);

  const { error } = await supabaseAdmin.auth.admin.deleteUser(id);

  if (error) {
    console.warn("Auth delete failed:", error.message);
  }

  return true;
};

// ─── Upload Teacher Avatar ────────────────────────────────────────────────────

export const uploadTeacherAvatar = async (
  teacherId: string,
  file: File
): Promise<string> => {
  const avatarUrl = await uploadTeacherAvatarDB(file, teacherId);

  await updateTeacherDB(teacherId, { avatarPath: avatarUrl });

  return avatarUrl;
};