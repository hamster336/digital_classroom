import { Teacher } from "../models/teacher";
import {
  createTeacher,
  getAllTeachers,
  getTeacherById,
  updateTeacher,
  deleteTeacher,
} from "../supabase/teacher";

/** CREATE */
export const addTeacher = async (
  employeeId: string,
  subjectIds: string[],
  classIds: string[],
  avatarPath: string | null
): Promise<Teacher> => {
  try {
    const teacher = new Teacher(
      null,
      employeeId,
      subjectIds,
      classIds,
      avatarPath,
      null
    );

    const result = await createTeacher(teacher.toMap());
    return Teacher.fromMap(result);
  } catch (error) {
    console.error("Failed to create teacher:", error);
    throw error;
  }
};

/** READ ALL */
export const fetchTeachers = async (): Promise<Teacher[]> => {
  try {
    const data = await getAllTeachers();
    return data.map((item: any) => Teacher.fromMap(item));
  } catch (error) {
    console.error("Failed to fetch teachers:", error);
    throw error;
  }
};

/** READ BY ID */
export const fetchTeacherById = async (id: string): Promise<Teacher> => {
  try {
    const data = await getTeacherById(id);
    return Teacher.fromMap(data);
  } catch (error) {
    console.error("Failed to fetch teacher:", error);
    throw error;
  }
};

/** UPDATE */
export const editTeacher = async (
  id: string,
  employeeId: string,
  subjectIds: string[],
  classIds: string[],
  avatarPath: string | null,
  lastCheckedNotices: Date | null
): Promise<Teacher> => {
  try {
    const teacher = new Teacher(
      id,
      employeeId,
      subjectIds,
      classIds,
      avatarPath,
      lastCheckedNotices
    );

    const result = await updateTeacher(id, teacher.toMap());
    return Teacher.fromMap(result);
  } catch (error) {
    console.error("Failed to update teacher:", error);
    throw error;
  }
};

/** DELETE */
export const removeTeacher = async (id: string): Promise<boolean> => {
  try {
    await deleteTeacher(id);
    return true;
  } catch (error) {
    console.error("Failed to delete teacher:", error);
    return false;
  }
};