/**
 * CLASSROOM SERVICE
 * Handles all CRUD operations for the 'classroom' table.
 */

// 1. FETCH ALL CLASSROOMS
// Returns all columns: id, name, created_at, faculty, start_year, end_year, is_active
export const getAllClassrooms = async () => {
  const { data, error } = await supabase
    .from('classroom')
    .select('*')
    .order('created_at', { ascending: false });

  if (error) {
    console.error('Error fetching classrooms:', error.message);
    return null;
  }
  return data;
};

// 2. FETCH A SPECIFIC CLASSROOM BY ID
export const getClassroomById = async (classId) => {
  const { data, error } = await supabase
    .from('classroom')
    .select('*')
    .eq('id', classId)
    .single();

  if (error) {
    console.error('Error fetching classroom:', error.message);
    return null;
  }
  return data;
};

// 3. INSERT A NEW CLASSROOM
// Note: 'id' and 'created_at' are handled automatically by Supabase
export const createClassroom = async (name, faculty, startYear, endYear, isActive = true) => {
  const { data, error } = await supabase
    .from('classroom')
    .insert([
      { 
        name, 
        faculty, 
        start_year: startYear, 
        end_year: endYear, 
        is_active: isActive 
      }
    ])
    .select();

  if (error) {
    console.error('Error creating classroom:', error.message);
    return null;
  }
  return data[0];
};

// 4. UPDATE CLASSROOM DATA
// Use this to change the name, faculty, or toggle 'is_active'
export const updateClassroom = async (classId, updateData) => {
  const { data, error } = await supabase
    .from('classroom')
    .update(updateData)
    .eq('id', classId)
    .select();

  if (error) {
    console.error('Error updating classroom:', error.message);
    return null;
  }
  return data[0];
};

// 5. DELETE A CLASSROOM
export const deleteClassroom = async (classId) => {
  const { error } = await supabase
    .from('classroom')
    .delete()
    .eq('id', classId);

  if (error) {
    console.error('Error deleting classroom:', error.message);
    return false;
  }
  return true;
};