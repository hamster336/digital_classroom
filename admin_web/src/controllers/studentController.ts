import { Student } from "../models/student";
import {
  createStudent,
  getAllStudents,
  getStudentById,
  updateStudent,
  deleteStudent,
} from "../supabase/student";

/** CREATE STUDENT */
export const addStudent = async (
  rollNo: number,
  subjectIds: string[],
  avatarUrl: string | null,
  classId: string,
): Promise<Student> => {
  try {
    const student = new Student(
      null,
      rollNo,
      subjectIds,
      avatarUrl,
      classId,
      null   // lastCheckedNotices is null for new student
    );
    //tomap()
    const result = await createStudent(student.toMap());
    //frommap()
    return Student.fromMap(result);
  } catch (error) {
    console.error("Failed to create student:", error);
    throw error;
  }
};

/** GET ALL STUDENTS */
export const fetchStudents = async (): Promise<Student[]> => {
  try {
    const data = await getAllStudents();
    return data.map((item: Record<string, any>) => Student.fromMap(item));
  } catch (error) {
    console.error("Failed to fetch students:", error);
    throw error;
  }
};

/** GET STUDENT BY ID */
export const fetchStudentById = async (id: string): Promise<Student> => {
  try {
    const data = await getStudentById(id);
    return Student.fromMap(data);
  } catch (error) {
    console.error("Failed to fetch student:", error);
    throw error;
  }
};

/** UPDATE STUDENT */
export const editStudent = async (
  id: string,
  rollNo: number,
  subjectIds: string[],
  avatarUrl: string | null,
  classId: string,
  lastCheckedNotices: Date | null  
): Promise<Student> => {
  try {
    const student = new Student(
      id,
      rollNo,
      subjectIds,
      avatarUrl,
      classId,
      lastCheckedNotices
    );
    const result = await updateStudent(id, student.toMap());
    return Student.fromMap(result);
  } catch (error) {
    console.error("Failed to update student:", error);
    throw error;
  }
};

/** DELETE STUDENT */
export const removeStudent = async (id: string): Promise<boolean> => {
  try {
    await deleteStudent(id);
    return true;
  } catch (error) {
    console.error("Failed to delete student:", error);
    return false;
  }
};