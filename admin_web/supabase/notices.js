import { supabase } from "./client";

/**
 * CREATE: Add a new notice
 */
export const createNotice = async (noticeData) => {
  const { data, error } = await supabase
    .from("notices")
    .insert([{
      // Matches your screenshot columns exactly
      title:        noticeData.title,
      description:  noticeData.description,
      published_at: noticeData.publishedAt || new Date().toISOString(),
      scheduled_at: noticeData.scheduledAt, // Can be NULL as seen in your image
      priority:     noticeData.priority      // e.g., 'urgent', 'info', 'important'
    }])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/**
 * READ ALL: Get all notices
 */
export const getAllNotices = async () => {
  const { data, error } = await supabase
    .from("notices")
    .select("*")
    // Correct: Sorting by published_at as it exists in your screenshot
    .order("published_at", { ascending: false });

  if (error) throw error;
  return data;
};

/**
 * READ BY ID
 */
export const getNoticeById = async (id) => {
  const { data, error } = await supabase
    .from("notices")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/**
 * UPDATE: Explicitly map the update fields
 */
export const updateNotice = async (id, updates) => {
  const { data, error } = await supabase
    .from("notices")
    .update({
      title:        updates.title,
      description:  updates.description,
      published_at: updates.publishedAt,
      scheduled_at: updates.scheduledAt,
      priority:     updates.priority
    })
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/**
 * DELETE
 */
export const deleteNotice = async (id) => {
  const { error } = await supabase
    .from("notices")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};