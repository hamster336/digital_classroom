import { supabase } from "./supabase-client";
import { supabaseAdmin } from "./supabase-admin-client";
import { Teacher } from "../models/teacher";

export const createTeacherDB = async (
  teacher: Teacher
): Promise<Teacher> => {

  const { data, error } = await supabase
    .from("teacher")
    .insert([
      {
        id: teacher.id,
        fullName: teacher.fullName,
        email: teacher.email,
        employeeId: teacher.employeeId,
        subjectIds: teacher.subjectIds,
        classIds: teacher.classIds,
        avatarPath: teacher.avatarPath,
      }
    ])
    .select()
    .single();

  if (error) throw error;

  return Teacher.fromMap(data);
};

export const getAllTeachersDB = async (): Promise<Teacher[]> => {

  const { data, error } = await supabase
    .from("teacher")
    .select("*");

  if (error) throw error;

  return (data || []).map((t) => Teacher.fromMap(t));
};

export const getTeacherByIdDB = async (
  id: string
): Promise<Teacher | null> => {

  const { data, error } = await supabase
    .from("teacher")
    .select("*")
    .eq("id", id)
    .single();

  if (error) return null;

  return data ? Teacher.fromMap(data) : null;
};

export const updateTeacherDB = async (
  id: string,
  updates: Partial<Teacher>
): Promise<Teacher | null> => {

  const dbUpdates: any = {};

  if (updates.fullName !== undefined) {
    dbUpdates.fullName = updates.fullName;
  }

  if (updates.employeeId !== undefined) {
    dbUpdates.employeeId = updates.employeeId;
  }

  if (updates.subjectIds !== undefined) {
    dbUpdates.subjectIds = updates.subjectIds;
  }

  if (updates.classIds !== undefined) {
    dbUpdates.classIds = updates.classIds;
  }

  if (updates.avatarPath !== undefined) {
    dbUpdates.avatarPath = updates.avatarPath;
  }

  const { data, error } = await supabase
    .from("teacher")
    .update(dbUpdates)
    .eq("id", id)
    .select("*")
    .single();

  if (error) return null;

  return data ? Teacher.fromMap(data) : null;
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

// Upload avatar to avatars bucket

export const uploadTeacherAvatarDB = async (
  file: File,
  teacherId: string
): Promise<string> => {

  const filePath = `${teacherId}-${file.name}`;

  const { error } = await supabaseAdmin.storage
    .from("avatars")
    .upload(filePath, file, {
      upsert: true
    });

  if (error) throw error;

  const { data: urlData } = supabaseAdmin.storage
    .from("avatars")
    .getPublicUrl(filePath);

  return urlData.publicUrl;
};