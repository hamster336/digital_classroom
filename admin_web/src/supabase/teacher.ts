import { supabase } from "./supabase-client";
import { supabaseAdmin } from "./supabase-admin-client";
import { Teacher } from "../models/teacher";

export const createTeacherDB = async (
  teacher: Teacher
): Promise<Teacher> => {
  const { data, error } = await supabase
    .from("teacher")
    .insert([teacher.toInsertMap()])
    .select()
    .single();

  if (error) throw error;

  // full_name and email come from users table — pass from memory after insert
  return Teacher.fromMap({
    ...data,
    full_name: teacher.fullName,
    email: teacher.email,
  });
};

export const getAllTeachersDB = async (): Promise<Teacher[]> => {
  // JOIN users to get full_name and email (not stored in teacher table)
  const { data, error } = await supabase
    .from("teacher")
    .select("*, users(full_name, email)");

  if (error) throw error;

  return (data || []).map((t) =>
    Teacher.fromMap({
      ...t,
      full_name: (t.users as any)?.full_name || "",
      email: (t.users as any)?.email || "",
    })
  );
};

export const getTeacherByIdDB = async (
  id: string
): Promise<Teacher | null> => {
  const { data, error } = await supabase
    .from("teacher")
    .select("*, users(full_name, email)")
    .eq("id", id)
    .single();

  if (error) return null;

  return data
    ? Teacher.fromMap({
        ...data,
        full_name: (data.users as any)?.full_name || "",
        email: (data.users as any)?.email || "",
      })
    : null;
};

export const updateTeacherDB = async (
  id: string,
  updates: Partial<Teacher>
): Promise<Teacher | null> => {
  const dbUpdates: any = {};

  // full_name and email are NOT in teacher table — skip them here
  if (updates.employeeId !== undefined) dbUpdates.employee_id = updates.employeeId;
  if (updates.subjectIds !== undefined) dbUpdates.subject_ids = updates.subjectIds;
  if (updates.classIds !== undefined) dbUpdates.class_ids = updates.classIds;
  if (updates.avatarPath !== undefined) dbUpdates.avatar_path = updates.avatarPath;

  const { data, error } = await supabase
    .from("teacher")
    .update(dbUpdates)
    .eq("id", id)
    .select("*, users(full_name, email)")
    .single();

  if (error) return null;

  return data
    ? Teacher.fromMap({
        ...data,
        full_name: (data.users as any)?.full_name || "",
        email: (data.users as any)?.email || "",
      })
    : null;
};

export const deleteTeacherDB = async (
  id: string
): Promise<boolean> => {
  const { error } = await supabase
    .from("teacher")
    .delete()
    .eq("id", id);

  if (error) return false;

  return true;
};

export const uploadTeacherAvatarDB = async (
  file: File,
  teacherId: string
): Promise<string> => {
  const filePath = `${teacherId}-${file.name}`;

  const { error } = await supabaseAdmin.storage
    .from("avatars")
    .upload(filePath, file, { upsert: true });

  if (error) throw error;

  const { data: urlData } = supabaseAdmin.storage
    .from("avatars")
    .getPublicUrl(filePath);

  return urlData.publicUrl;
};