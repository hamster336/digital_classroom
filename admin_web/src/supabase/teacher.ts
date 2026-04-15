import { supabase } from "./supabase-client";

/** CREATE */
export const createTeacher = async (teacherData: Record<string, any>) => {
  const { data, error } = await supabase
    .from("teacher")
    .insert([{
      employee_id:          teacherData.employee_id,
      subject_ids:          teacherData.subject_ids,
      class_ids:            teacherData.class_ids,
      avatar_path:           teacherData.avatar_path,
      last_checked_notices: teacherData.last_checked_notices, //  fixed: was cut off
    }])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** READ ALL */
export const getAllTeachers = async () => {
  const { data, error } = await supabase
    .from("teacher")
    .select("*")
    .order("employee_id", { ascending: true });

  if (error) throw error;
  return data;
};

/** READ BY ID */
export const getTeacherById = async (id: string) => {
  const { data, error } = await supabase
    .from("teacher")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/** UPDATE */
export const updateTeacher = async (id: string, updates: Record<string, any>) => {
  const { data, error } = await supabase
    .from("teacher")
    .update({
      employee_id:          updates.employee_id,
      subject_ids:          updates.subject_ids,
      class_ids:            updates.class_ids,
      avatar_path:           updates.avatar_path,
      last_checked_notices: updates.last_checked_notices,
    })
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** DELETE */
export const deleteTeacher = async (id: string) => {  //  fixed: was incomplete
  const { error } = await supabase
    .from("teacher")
    .delete()
    .eq("id", id);

  if (error) throw error;  //  fixed: was cut off
  return true;
};