
import { supabase } from "./client";

/** CREATE: Add a new student */
export const createStudent = async (studentData) => {
  const { data, error } = await supabase
    .from("student")
    .insert([{
      roll_number: studentData.rollNumber,
      subject_ids: studentData.subjectIds, // Should be an array like ['uuid1']
      avatar_url:  studentData.avatarUrl,
      class_id:    studentData.classId
    }])
    .select().single();

  if (error) throw error;
  return data;
};

/** READ: Get all students */
export const getAllStudents = async () => {
  const { data, error } = await supabase
    .from("student")
    .select("*")
    .order("roll_number", { ascending: true }); //

  if (error) throw error;
  return data;
};

/** UPDATE: Edit existing student details */
export const updateStudent = async (id, updates) => {
  const { data, error } = await supabase
    .from("student")
    .update({
      roll_number: updates.rollNumber,
      subject_ids: updates.subjectIds,
      avatar_url:  updates.avatarUrl,
      class_id:    updates.classId
    })
    .eq("id", id)
    .select().single();

  if (error) throw error;
  return data;
};

/** DELETE: Remove a student */
export const deleteStudent = async (id) => {
  const { error } = await supabase
    .from("student")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};