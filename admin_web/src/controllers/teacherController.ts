import { Teacher } from "../models/teacher";
import {
  createTeacher,
  getAllTeachers,
  getTeacherById,
  updateTeacher,
  deleteTeacher,
} from "../supabase/teacher";

/** CREATE TEACHER */
export const addTeacher = async (
  employeeId: string,
  subjectIds: string[],
  classIds: string[],
  avatarUrl: string | null,
): Promise<Teacher> => {
  try {
    const teacher = new Teacher(
      null,
      employeeId,
      subjectIds,
      classIds,
      avatarUrl,
      null   // lastCheckedNotices null for new teacher
    );
    const result = await createTeacher(teacher.toMap());  // toMap() → UTC
    return Teacher.fromMap(result);                        // fromMap() → Local
  } catch (error) {
    console.error("Failed to create teacher:", error);
    throw error;
  }
};

/** GET ALL TEACHERS */
export const fetchTeachers = async (): Promise<Teacher[]> => {
  try {
    const data = await getAllTeachers();
    return data.map((item: Record<string, any>) => Teacher.fromMap(item));  // UTC → Local
  } catch (error) {
    console.error("Failed to fetch teachers:", error);
    throw error;
  }
};

/** GET TEACHER BY ID */
export const fetchTeacherById = async (id: string): Promise<Teacher> => {
  try {
    const data = await getTeacherById(id);
    return Teacher.fromMap(data);  // UTC → Local
  } catch (error) {
    console.error("Failed to fetch teacher:", error);
    throw error;
  }
};

/** UPDATE TEACHER */
export const editTeacher = async (
  id: string,
  employeeId: string,
  subjectIds: string[],
  classIds: string[],
  avatarUrl: string | null,
  lastCheckedNotices: Date | null  
): Promise<Teacher> => {
  try {
    const teacher = new Teacher(
      id,
      employeeId,
      subjectIds,
      classIds,
      avatarUrl,
      lastCheckedNotices  // toMap() converts to UTC
    );
    const result = await updateTeacher(id, teacher.toMap());  // toMap() → UTC
    return Teacher.fromMap(result);                            // fromMap() → Local
  } catch (error) {
    console.error("Failed to update teacher:", error);
    throw error;
  }
};

/** DELETE TEACHER */
export const removeTeacher = async (id: string): Promise<boolean> => {
  try {
    await deleteTeacher(id);
    return true;
  } catch (error) {
    console.error("Failed to delete teacher:", error);
    return false;
  }
};