import { supabase } from "./supabase-client"; 

/** READ ALL */
export const getAllSchedules = async () => {
  const { data, error } = await supabase
    .from("schedules")
    .select("*")
    .order("day_of_week", { ascending: true });  

  if (error) throw error;
  return data;
};

/** READ BY ID */
export const getScheduleById = async (id: string) => {  
  const { data, error } = await supabase
    .from("schedules")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return data;
};

/** READ BY CLASS ID */
export const getSchedulesByClass = async (classId: string) => {
  const { data, error } = await supabase
    .from("schedules")
    .select("*")
    .eq("class_id", classId)
    .order("day_of_week", { ascending: true });

  if (error) throw error;
  return data;
};

/** CREATE */
export const createSchedule = async (scheduleData: Record<string, any>) => {
  const { data, error } = await supabase
    .from("schedules")
    .insert([{
      class_id:    scheduleData.class_id,    
      subject_id:  scheduleData.subject_id,  
      day_of_week: scheduleData.day_of_week, 
      start_time:  scheduleData.start_time,  
      end_time:    scheduleData.end_time,    
    }])
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** UPDATE */
export const updateSchedule = async (id: string, updates: Record<string, any>) => {
  const { data, error } = await supabase
    .from("schedules")
    .update({
      class_id:    updates.class_id,    //  explicit mapping
      subject_id:  updates.subject_id,
      day_of_week: updates.day_of_week,
      start_time:  updates.start_time,
      end_time:    updates.end_time,
    })
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

/** DELETE */
export const deleteSchedule = async (id: string) => {
  const { error } = await supabase
    .from("schedules")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;  // added return value
};