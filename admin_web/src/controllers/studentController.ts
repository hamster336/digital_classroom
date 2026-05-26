import { Student } from "../models/student";
import {
  createStudentDB,
  getAllStudentsDB,
  getStudentByIdDB,
  updateStudentDB,
  deleteStudentDB,
  uploadStudentAvatarDB,
} from "../supabase/student";
import { signUpStudent } from "./userController";

export const createStudent = async (
  fullName: string,
  email: string,
  rollNumber: string,
  subjectIds: string[],
  classId: string,
  avatarFile: File | null = null
): Promise<Student> => {
  // Step 1: Create auth user
  const newUser = await signUpStudent(fullName, email, "student");
  const userId = newUser.id;

  // Step 2: Upload avatar (optional)
  let finalAvatarPath: string | null = null;

  if (avatarFile) {
    try {
      finalAvatarPath = await uploadStudentAvatarDB(avatarFile, userId);
    } catch (uploadErr) {
      console.error("Avatar upload failed:", uploadErr);
    }
  }

  // Step 3: Create student record
  const student = new Student(
    userId,
    fullName,
    rollNumber,
    subjectIds,
    finalAvatarPath,
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

export const uploadStudentAvatar = async (
  file: File,
  studentId: string
): Promise<string> => {
  return await uploadStudentAvatarDB(file, studentId);
};
