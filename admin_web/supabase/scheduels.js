import { supabase } from './supabaseClient'
/**
 * 1. FETCH ALL (Read)
 * Gets all schedules from your table
 */
export const getSchedules = async () => {
  const { data, error } = await supabase
    .from('schedules')
    .select('*')
    .order('date', { ascending: true })
  
  if (error) throw error
  return data
}

/**
 * 2. CREATE (Write)
 * Matches your columns: name, description, date, time
 */
export const createSchedule = async (newData) => {
  const { data, error } = await supabase
    .from('schedules')
    .insert([
      {
        name: newData.name,
        description: newData.description,
        date: newData.date, // Format: YYYY-MM-DD
        time: newData.time, // Format: HH:mm:ss
        user_id: (await supabase.auth.getUser()).data.user?.id 
      }
    ])
    .select()

  if (error) throw error
  return data[0]
}

/**
 * 3. UPDATE (Edit)
 * Use this when a user edits a task in the UI
 */
export const updateSchedule = async (id, updatedFields) => {
  // updatedFields can be { name: "New Name" } or { time: "12:00:00" }, etc.
  const { data, error } = await supabase
    .from('schedules')
    .update(updatedFields)
    .eq('id', id)
    .select()

  if (error) throw error
  return data[0]
}

/**
 * 4. DELETE (Remove)
 */
export const deleteSchedule = async (id) => {
  const { error } = await supabase
    .from('schedules')
    .delete()
    .eq('id', id)

  if (error) throw error
}