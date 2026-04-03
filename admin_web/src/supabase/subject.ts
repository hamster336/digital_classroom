import { supabase } from "./supabase-client";

/** CREATE */
export const createSubject = async (subjectData: Record<string, any>) => {
  const { data, error } = await supabase
    .from("subjects")
    .insert([subjectData])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** READ ALL */
export const getAllSubjects = async () => {
  const { data, error } = await supabase
    .from("subjects")
    .select("*");

  if (error) throw error;
  return data;
};

/** READ BY ID */
export const getSubjectById = async (id: string) => {
  const { data, error } = await supabase
    .from("subjects")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/** READ BY CLASS */
export const getSubjectsByClass = async (classId: string) => {
  const { data, error } = await supabase
    .from("subjects")
    .select("*")
    .eq("class_id", classId);

  if (error) throw error;
  return data;
};

/** UPDATE */
export const updateSubject = async (id: string, updates: Record<string, any>) => {
  const { data, error } = await supabase
    .from("subjects")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** DELETE */
export const deleteSubject = async (id: string): Promise<void> => {
  const { error } = await supabase
    .from("subjects")
    .delete()
    .eq("id", id);

  if (error) throw error;
};