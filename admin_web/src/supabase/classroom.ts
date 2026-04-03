import { supabase } from "./supabase-client";  // added missing import

export const getAllClassrooms = async () => {
  const { data, error } = await supabase
    .from('classroom')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) throw error;  // throw instead of return null
  return data;
};

export const getClassroomById = async (id: string) => {
  const { data, error } = await supabase
    .from('classroom')
    .select('*')
    .eq('id', id)
    .single();

  if (error) throw error;
  return data;
};

export const createClassroom = async (classroomData: Record<string, any>) => {  // accepts object
  const { data, error } = await supabase
    .from('classroom')
    .insert([{
      name:       classroomData.name,
      faculty:    classroomData.faculty,
      start_year: classroomData.start_year,
      end_year:   classroomData.end_year,
      is_active:  classroomData.is_active,
    }])
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const updateClassroom = async (id: string, updates: Record<string, any>) => {
  const { data, error } = await supabase
    .from('classroom')
    .update({
      name:       updates.name,
      faculty:    updates.faculty,
      start_year: updates.start_year,
      end_year:   updates.end_year,
      is_active:  updates.is_active,
    })
    .eq('id', id)
    .select()
    .single();

  if (error) throw error;
  return data;
};

export const deleteClassroom = async (id: string) => {
  const { error } = await supabase
    .from('classroom')
    .delete()
    .eq('id', id);

  if (error) throw error;
  return true;
};