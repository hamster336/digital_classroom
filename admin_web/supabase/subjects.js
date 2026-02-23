
/**
 * FETCH ALL SUBJECTS.
 */
export const getSubjects = async () => {
  const { data, error } = await supabase
    .from('subjects')
    .select('*')
    .order('name', { ascending: true });

  if (error) {
    console.error('Error fetching subjects:', error.message);
    return null;
  }
  return data;
};

/**
 * FETCH SUBJECTS BY CLASS ID
 */
export const getSubjectsByClass = async (classId) => {
  const { data, error } = await supabase
    .from('subjects')
    .select('*')
    .eq('class_id', classId);

  if (error) {
    console.error('Error fetching subjects for class:', error.message);
    return null;
  }
  return data;
};

/**
 * INSERT A NEW SUBJECT
 */
export const insertSubject = async (name, classId, teacherId) => {
  const { data, error } = await supabase
    .from('subjects')
    .insert([{ 
      name: name, 
      class_id: class_id, 
      teacher_id: teacher_id 
    }])
    .select();

  if (error) {
    console.error('Error inserting subject:', error.message);
    return null;
  }
  return data[0];
};

/**
 * DELETE A SUBJECT
 * Removes a subject using its UUID.
 */
export const deleteSubject = async (id) => {
  const { error } = await supabase
    .from('subjects')
    .delete()
    .eq('id', id);

  if (error) {
    console.error('Error deleting subject:', error.message);
    return false;
  }
  return true;
};