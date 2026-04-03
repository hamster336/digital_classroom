import { Classroom } from "../models/classroom";
import {
  createClassroom,
  getAllClassrooms,
  getClassroomById,
  updateClassroom,
  deleteClassroom,
} from "../supabase/classroom";

/** CREATE CLASSROOM */
export const addClassroom = async (
  name: string,
  faculty: string,
  startYear: number,
  endYear: number,
  isActive: boolean = true
): Promise<Classroom> => {
  try {
    const classroom = new Classroom(null, name, new Date(), faculty, startYear, endYear, isActive);
    const result = await createClassroom(classroom.toMap());
    return Classroom.fromMap(result);
  } catch (error) {
    console.error("Failed to create classroom:", error);
    throw error;
  }
};

/** GET ALL CLASSROOMS */
export const fetchClassrooms = async (): Promise<Classroom[]> => {
  try {
    const data = await getAllClassrooms();
    return data.map((item: Record<string, any>) => Classroom.fromMap(item));
  } catch (error) {
    console.error("Failed to fetch classrooms:", error);
    throw error;
  }
};

/** GET CLASSROOM BY ID */
export const fetchClassroomById = async (id: string): Promise<Classroom> => {
  try {
    const data = await getClassroomById(id);
    return Classroom.fromMap(data);
  } catch (error) {
    console.error("Failed to fetch classroom:", error);
    throw error;
  }
};

/** UPDATE CLASSROOM */
export const editClassroom = async (
  id: string,
  name: string,
  faculty: string,
  startYear: number,
  endYear: number,
  isActive: boolean,
  createdAt: Date      
): Promise<Classroom> => {
  try {
    const classroom = new Classroom(id, name, createdAt, faculty, startYear, endYear, isActive);
    const result = await updateClassroom(id, classroom.toMap());
    return Classroom.fromMap(result);
  } catch (error) {
    console.error("Failed to update classroom:", error);
    throw error;
  }
};

/** DELETE CLASSROOM */
export const removeClassroom = async (id: string): Promise<boolean> => {
  try {
    await deleteClassroom(id);
    return true;
  } catch (error) {
    console.error("Failed to delete classroom:", error);
    return false;
  }
};