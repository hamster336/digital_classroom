import { supabase } from "./supabase-client";

/** CREATE */
export const createNotice = async (noticeData: Record<string, any>) => {
  const { data, error } = await supabase
    .from("notices")
    .insert([{
      title:        noticeData.title,
      description:  noticeData.description,
      published_at: noticeData.published_at ?? new Date().toISOString(), 
      scheduled_at: noticeData.scheduled_at ?? null,                     
      priority:     noticeData.priority
    }])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** READ ALL */
export const getAllNotices = async () => {
  const { data, error } = await supabase
    .from("notices")
    .select("*")
    .order("published_at", { ascending: false }); 

  if (error) throw error;
  return data;
};

/** READ BY ID */
export const getNoticeById = async (id: string) => { 
  const { data, error } = await supabase
    .from("notices")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/** UPDATE */
export const updateNotice = async (id: string, updates: Record<string, any>) => {  
  const { data, error } = await supabase
    .from("notices")
    .update({
      title:        updates.title,
      description:  updates.description,
      published_at: updates.published_at,   
      scheduled_at: updates.scheduled_at ?? null,  
      priority:     updates.priority
    })
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** DELETE */
export const deleteNotice = async (id: string) => {  
  const { error } = await supabase
    .from("notices")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};