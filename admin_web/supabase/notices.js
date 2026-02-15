import { supabase } from "./client";

/* CREATE */
export const createNotice = async (notice) => {
  const { data, error } = await supabase
    .from("notices")
    .insert([notice])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/* READ ALL */
export const getAllNotices = async () => {
  const { data, error } = await supabase
    .from("notices")
    .select("*")
    .order("published_at", { ascending: false });

  if (error) throw error;
  return data;
};

/* READ BY ID */
export const getNoticeById = async (id) => {
  const { data, error } = await supabase
    .from("notices")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/* UPDATE */
export const updateNotice = async (id, updates) => {
  const { data, error } = await supabase
    .from("notices")
    .update(updates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/* DELETE */
export const deleteNotice = async (id) => {
  const { error } = await supabase
    .from("notices")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};
