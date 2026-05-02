
import { supabase } from "./supabase-client";

/** CREATE */
export const createSubject = async (subjectData: Record<string, any>) => {
  console.log("Insert payload:", subjectData); 

  const { data, error } = await supabase
    .from("subjects")
    .insert([
      {
        name: subjectData.name,
        class_id: subjectData.class_id,
        teacher_id: subjectData.teacher_id,
      },
    ])
    .select()
    .single();

  if (error) {
    console.error("Supabase INSERT error:", error.message, error.details);
    throw error;
  }

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
export const updateSubject = async (
  id: string,
  updates: Record<string, any>
) => {
  console.log("Update payload:", updates); // 🔍 debug

  const { data, error } = await supabase
    .from("subjects")
    .update({
      name: updates.name,
      class_id: updates.class_id,
      teacher_id: updates.teacher_id,
    })
    .eq("id", id)
    .select()
    .single();

  if (error) {
    console.error("Supabase UPDATE error:", error.message);
    throw error;
  }

  return data;
};

/** DELETE */
export const deleteSubject = async (id: string): Promise<void> => {
  const { error } = await supabase
    .from("subjects")
    .delete()
    .eq("id", id);

  if (error) {
    console.error("Supabase DELETE error:", error.message);
    throw error;
  }
};