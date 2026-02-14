// supabase/teachers.js
import { supabase } from "./client";

/* CREATE */
export const createTeacher = async (teacher) => {
  const { data, error } = await supabase
    .from("teacher")
    .insert([teacher])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/* READ ALL */
export const getAllTeachers = async () => {
  const { data, error } = await supabase
    .from("teacher")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) throw error;
  return data;
};

/* ================= READ BY ID ================= */
export const getTeacherById = async (id) => {
  const { data, error } = await supabase
    .from("teacher")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};


/* UPDATE */
export const updateTeacher = async (id, updates) => {
  const { data, error } = await supabase
    .from("teacher")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/* DELETE */
export const deleteTeacher = async (id) => {
  const { error } = await supabase
    .from("teacher")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};
