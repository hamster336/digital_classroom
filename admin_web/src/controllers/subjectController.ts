import { Subject } from "../models/subject";
import {
  getAllSubjects,
  getSubjectById,
  getSubjectsByClass,
  createSubject,
  updateSubject,
  deleteSubject,
} from "../supabase/subject";

/** CREATE SUBJECT */
export const addSubject = async (
  name: string,
  classId: string,
  teacherId: string
): Promise<Subject> => {
  try {
    
    console.log("Adding subject:", { name, classId, teacherId });

    const subject = new Subject(null, name, classId, teacherId);

    const result = await createSubject(subject.toMap());

    return Subject.fromMap(result);
  } catch (error: any) {
    console.error("Failed to create subject:");
    console.error("Message:", error?.message);
    console.error("Details:", error);

    throw error;
  }
};

/** GET ALL SUBJECTS */
export const fetchSubject = async (): Promise<Subject[]> => {
  try {
    const data = await getAllSubjects();

    return data.map((item: Record<string, any>) =>
      Subject.fromMap(item)
    );
  } catch (error: any) {
    console.error("Failed to fetch subjects:");
    console.error("Message:", error?.message);
    throw error;
  }
};

/** GET SUBJECT BY ID */
export const fetchSubjectById = async (
  id: string
): Promise<Subject> => {
  try {
    const data = await getSubjectById(id);

    return Subject.fromMap(data);
  } catch (error: any) {
    console.error("Failed to fetch subject:");
    console.error("Message:", error?.message);
    throw error;
  }
};

/** GET SUBJECTS BY CLASS */
export const fetchSubjectsByClass = async (
  classId: string
): Promise<Subject[]> => {
  try {
    const data = await getSubjectsByClass(classId);

    return data.map((item: Record<string, any>) =>
      Subject.fromMap(item)
    );
  } catch (error: any) {
    console.error("Failed to fetch subjects by class:");
    console.error("Message:", error?.message);
    throw error;
  }
};

/** UPDATE SUBJECT */
export const editSubject = async (
  id: string,
  name: string,
  classId: string,
  teacherId: string
): Promise<Subject> => {
  try {
    console.log("Updating subject:", { id, name, classId, teacherId });

    const subject = new Subject(id, name, classId, teacherId);

    const result = await updateSubject(id, subject.toMap());

    return Subject.fromMap(result);
  } catch (error: any) {
    console.error("Failed to update subject:");
    console.error("Message:", error?.message);
    throw error;
  }
};

/** DELETE SUBJECT */
export const removeSubject = async (id: string): Promise<boolean> => {
  try {
    console.log("Deleting subject:", id);

    await deleteSubject(id);

    return true;
  } catch (error: any) {
    console.error("Failed to delete subject:");
    console.error("Message:", error?.message);
    return false;
  }
};