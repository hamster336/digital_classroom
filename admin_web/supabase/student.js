import { supabase } from "./client";

/* ================= CREATE ================= */
export const createStudent = async (student) => {
  const { data, error } = await supabase
    .from("student")
    .insert([student])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/* ================= READ ALL ================= */
export const getAllStudents = async () => {
  const { data, error } = await supabase
    .from("student")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) throw error;
  return data;
};

/* ================= READ BY ID ================= */
export const getStudentById = async (id) => {
  const { data, error } = await supabase
    .from("student")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/* ================= UPDATE ================= */
export const updateStudent = async (id, updates) => {
  const { data, error } = await supabase
    .from("student")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/* ================= DELETE ================= */
export const deleteStudent = async (id) => {
  const { error } = await supabase
    .from("student")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};
