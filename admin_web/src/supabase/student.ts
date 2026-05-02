import { supabase } from "./supabase-client";

/** CREATE */
export const createStudent = async (studentData: Record<string, any>) => {
  const { data, error } = await supabase
    .from("student")
    .insert([{
      roll_number:              studentData.roll_no,        
      subject_ids:          studentData.subject_ids,    
      avatar_url:           studentData.avatar_url,     
      class_id:             studentData.class_id,      
      last_checked_notices: studentData.last_checked_notices, 
    }])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** READ ALL */
export const getAllStudents = async () => {
  const { data, error } = await supabase
    .from("student")
    .select("*")
    .order("roll_number", { ascending: true });  

  if (error) throw error;
  return data;
};

/** READ BY ID */
export const getStudentById = async (id: string) => {  // added missing function
  const { data, error } = await supabase
    .from("student")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/** UPDATE */
export const updateStudent = async (id: string, updates: Record<string, any>) => {
  const { data, error } = await supabase
    .from("student")
    .update({
      roll_number:              updates.roll_number,        
      subject_ids:          updates.subject_ids,    
      avatar_url:           updates.avatar_url,     
      class_id:             updates.class_id,       
      last_checked_notices: updates.last_checked_notices, 
    })
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** DELETE */
export const deleteStudent = async (id: string) => {
  const { error } = await supabase
    .from("student")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};