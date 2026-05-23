import { supabase } from "./supabase-client";
import { supabaseAdmin } from "./supabase-admin-client";
import { Student } from "../models/student";

export const createStudentDB = async (student: Student): Promise<Student> => {
  console.log("Creating student in DB:", student);

  const { data, error } = await supabase
    .from("student")
    .insert([student.toInsertMap()]) //  excludes id
    .select()
    .single();

  if (error) {
    console.error("CREATE ERROR:", error);
    throw error;
  }

  // full_name comes from users table — pass from memory after insert
  return Student.fromMap({
    ...data,
    full_name: student.fullName,
  });
};

export const getAllStudentsDB = async (): Promise<Student[]> => {
  // JOIN users to get full_name (not stored in student table)
  const { data, error } = await supabase
    .from("student")
    .select("*, users(full_name)");

  if (error) {
    console.error("FETCH ERROR:", error);
    return [];
  }

  if (!data || data.length === 0) return [];

  return data
    .map((item: any) => {
      try {
        return Student.fromMap({
          ...item,
          full_name: (item.users as any)?.full_name || "",
        });
      } catch (err) {
        console.error("Mapping error:", item, err);
        return null;
      }
    })
    .filter(Boolean) as Student[];
};

export const getStudentByIdDB = async (id: string): Promise<Student | null> => {
  const { data, error } = await supabase
    .from("student")
    .select("*, users(full_name)")
    .eq("id", id)
    .single();

  if (error) {
    console.error("GET BY ID ERROR:", error);
    return null;
  }

  return data
    ? Student.fromMap({
        ...data,
        full_name: (data.users as any)?.full_name || "",
      })
    : null;
};

export const updateStudentDB = async (
  id: string,
  updates: Partial<Student>
): Promise<Student | null> => {
  // convert camelCase → snake_case for Supabase
  const dbUpdates: any = {};
  if (updates.rollNumber !== undefined) dbUpdates.roll_number = updates.rollNumber;
  if (updates.classId !== undefined) dbUpdates.class_id = updates.classId;
  if (updates.avatarPath !== undefined) dbUpdates.avatar_path = updates.avatarPath;
  if (updates.subjectIds !== undefined) dbUpdates.subject_ids = updates.subjectIds;
  if (updates.lastCheckedNotices instanceof Date) {
    dbUpdates.last_checked_notices = updates.lastCheckedNotices.toISOString();
  }

  const { data, error } = await supabase
    .from("student")
    .update(dbUpdates)
    .eq("id", id)
    .select("*, users(full_name)")
    .single();

  if (error) {
    console.error("UPDATE ERROR:", error);
    return null;
  }

  return data
    ? Student.fromMap({
        ...data,
        full_name: (data.users as any)?.full_name || "",
      })
    : null;
};

export const deleteStudentDB = async (id: string): Promise<boolean> => {
  const { error } = await supabase
    .from("student")
    .delete()
    .eq("id", id);

  if (error) {
    console.error("DELETE ERROR:", error);
    return false;
  }

  return true;
};

export const uploadStudentAvatarDB = async (
  file: File,
  studentId: string
): Promise<string> => {
  const filePath = `${studentId}-${file.name}`;

  const { error } = await supabaseAdmin.storage
    .from("avatars")
    .upload(filePath, file, { upsert: true });

  if (error) throw error;

  return filePath;
};
