import { supabase } from "./supabase-client";
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

  return Student.fromMap(data);
};

export const getAllStudentsDB = async (): Promise<Student[]> => {
  const { data, error } = await supabase
    .from("student")
    .select("*");

  if (error) {
    console.error("FETCH ERROR:", error);
    return [];
  }

  if (!data || data.length === 0) return [];

  return data.map((item: any) => {
    try {
      return Student.fromMap(item);
    } catch (err) {
      console.error("Mapping error:", item, err);
      return null;
    }
  }).filter(Boolean) as Student[];
};

export const getStudentByIdDB = async (id: string): Promise<Student | null> => {
  const { data, error } = await supabase
    .from("student")
    .select("*")
    .eq("id", id)
    .single();

  if (error) {
    console.error("GET BY ID ERROR:", error);
    return null;
  }

  return data ? Student.fromMap(data) : null;
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
    .select()
    .single();

  if (error) {
    console.error("UPDATE ERROR:", error);
    return null;
  }

  return data ? Student.fromMap(data) : null;
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