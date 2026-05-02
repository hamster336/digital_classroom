import { supabase } from "./supabase-client";
import { Teacher } from "../models/teacher";

export const createTeacherDB = async (teacher: Teacher): Promise<Teacher> => {
  const { data, error } = await supabase
    .from("teacher")
    .insert([teacher.toInsertMap()])
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

export const getTeacherByIdDB = async (id: string): Promise<Teacher | null> => {
  const { data, error } = await supabase
    .from("teacher")
    .select("*")
    .eq("user_id", id)
    .single();

  if (error) return null;
  return data ? Teacher.fromMap(data) : null;
};

export const updateTeacherDB = async (
  id: string,
  updates: Partial<Teacher>
): Promise<Teacher | null> => {
  const dbUpdates: any = {};
  if (updates.employeeId !== undefined) dbUpdates.employee_id = updates.employeeId;
  if (updates.subjectIds !== undefined) dbUpdates.subject_ids = updates.subjectIds;
  if (updates.classIds !== undefined) dbUpdates.class_ids = updates.classIds;

  const { data, error } = await supabase
    .from("teacher")
    .update(dbUpdates)
    .eq("user_id", id)
    .select()
    .single();

  if (error) return null;
  return data ? Teacher.fromMap(data) : null;
};

export const deleteTeacherDB = async (id: string): Promise<boolean> => {
  const { error } = await supabase
    .from("teacher")
    .delete()
    .eq("user_id", id);

  if (error) return false;
  return true;
};