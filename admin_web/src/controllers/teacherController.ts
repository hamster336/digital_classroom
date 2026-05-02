import { Teacher } from "../models/teacher";
import { User } from "../models/user";
import {
  createTeacherDB,
  getAllTeachersDB,
  getTeacherByIdDB,
  updateTeacherDB,
  deleteTeacherDB,
} from "../supabase/teacher";
import { deleteUserDB } from "../supabase/user";
import { supabaseAdmin } from "../supabase/supabase-admin-client";

export const createTeacher = async (
  fullName: string,
  email: string,
  employeeId: string,
  subjectIds: string[] = [],
  classIds: string[] = []
): Promise<Teacher> => {
  const password = '@user123';

  // Step 1: create auth user
  const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
    email,
    password,
    email_confirm: true,
  });

  if (authError) throw authError;
  if (!authData.user) throw new Error("Failed to create auth user.");

  // Step 2: insert into users table
  const user = new User(
    authData.user.id,
    fullName,
    email,
    "teacher",
    new Date().toISOString()
  );

  const { error: userInsertError } = await supabaseAdmin
    .from("users")
    .insert([user.toInsertMap()]);

  if (userInsertError) throw userInsertError;

  // Step 3: insert into teacher table
  const teacher = new Teacher(
    authData.user.id,
    employeeId,
    subjectIds,
    classIds
  );

  return await createTeacherDB(teacher);
};

export const getAllTeachers = async (): Promise<Teacher[]> => {
  return await getAllTeachersDB();
};

export const getTeacherById = async (id: string): Promise<Teacher | null> => {
  return await getTeacherByIdDB(id);
};

export const updateTeacher = async (
  id: string,
  updates: Partial<Teacher>
): Promise<Teacher | null> => {
  return await updateTeacherDB(id, updates);
};

export const deleteTeacher = async (id: string): Promise<boolean> => {
  const teacher = await getTeacherByIdDB(id);
  if (!teacher) return false;

  await deleteTeacherDB(id);
  await deleteUserDB(teacher.id);

  const { error } = await supabaseAdmin.auth.admin.deleteUser(teacher.id);
  if (error) console.warn("Auth delete failed:", error.message);

  return true;
};