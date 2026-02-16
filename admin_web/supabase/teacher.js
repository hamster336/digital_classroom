import { supabase } from "./client";

/** * CREATE: Add a new teacher 
 */
export const createTeacher = async (teacherData) => {
  const { data, error } = await supabase
    .from("teacher")
    .insert([{
      // Matches your screenshot columns exactly
      employee_id: teacherData.employeeId, 
      subject_ids: teacherData.subjectIds, // text[] array
      class_ids:   teacherData.classIds,   // text[] array
      avatar_url:  teacherData.avatarUrl
    }])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** * READ ALL: Get all teachers 
 */
export const getAllTeachers = async () => {
  const { data, error } = await supabase
    .from("teacher")
    .select("*")
    // Sorting by employee_id since created_at is missing in your screenshot
    .order("employee_id", { ascending: true }); 

  if (error) throw error;
  return data;
};

/** * UPDATE: Explicitly map the update fields
 */
export const updateTeacher = async (id, updates) => {
  const { data, error } = await supabase
    .from("teacher")
    .update({
      employee_id: updates.employeeId,
      subject_ids: updates.subjectIds,
      class_ids:   updates.classIds,
      avatar_url:  updates.avatarUrl
    })
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** * DELETE 
 */
export const deleteTeacher = async (id) => {
  const { error } = await supabase
    .from("teacher")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};