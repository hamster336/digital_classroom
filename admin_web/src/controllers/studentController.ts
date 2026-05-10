import { Student } from "../models/student";
import {
  createStudentDB,
  getAllStudentsDB,
  getStudentByIdDB,
  updateStudentDB,
  deleteStudentDB,
} from "../supabase/student";

export const createStudent = async (
  id: string,        //  must come from auth
  rollNumber: string,
  subjectIds: string[],
  classId: string,
  avatarPath: string | null = null
): Promise<Student> => {
  if (!id) throw new Error("ID is required to create a student.");

const student = new Student(
    id,           //  use real auth UUID
    rollNumber,
    subjectIds,
    avatarPath,
    classId,
    null
);

  return await createStudentDB(student);
};

export const getAllStudents = async (): Promise<Student[]> => {
  return await getAllStudentsDB();
};

export const getStudentById = async (id: string): Promise<Student | null> => {
  return await getStudentByIdDB(id);
};

export const updateStudent = async (
  id: string,
  updates: Partial<Student>
): Promise<Student | null> => {
  return await updateStudentDB(id, updates);
};

export const deleteStudent = async (id: string): Promise<boolean> => {
  return await deleteStudentDB(id);
};