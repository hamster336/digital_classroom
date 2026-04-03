import { Schedule, DayOfWeek } from "../models/schedules";
import {
  getAllSchedules,
  getScheduleById,
  getSchedulesByClass,
  createSchedule,
  updateSchedule,
  deleteSchedule,
} from "../supabase/schedule";

// Validation moved here from constructor
const validateTimes = (startTime: string, endTime: string) => {
  if (startTime >= endTime) {
    throw new Error("End time must be after start time");
  }
};

/** CREATE SCHEDULE */
export const addSchedules = async (
  classId: string,
  subjectId: string,
  dayOfWeek: DayOfWeek,
  startTime: string,
  endTime: string
): Promise<Schedule> => {
  try {
    validateTimes(startTime, endTime);  
    const schedule = new Schedule(
      null,
      classId,
      subjectId,
      dayOfWeek,
      startTime,
      endTime
    );
    const result = await createSchedule(schedule.toMap());
    return Schedule.fromMap(result);
  } catch (error) {
    console.error("Failed to create schedule:", error);
    throw error;
  }
};

/** GET ALL SCHEDULES */
export const fetchSchedules = async (): Promise<Schedule[]> => {
  try {
    const data = await getAllSchedules();
    return data.map((item: Record<string, any>) => Schedule.fromMap(item));
  } catch (error) {
    console.error("Failed to fetch schedules:", error);
    throw error;
  }
};

/** GET SCHEDULE BY ID */
export const fetchScheduleById = async (id: string): Promise<Schedule> => {
  try {
    const data = await getScheduleById(id);
    return Schedule.fromMap(data);
  } catch (error) {
    console.error("Failed to fetch schedule:", error);
    throw error;
  }
};

/** GET SCHEDULES BY CLASS */
export const fetchSchedulesByClass = async (classId: string): Promise<Schedule[]> => {
  try {
    const data = await getSchedulesByClass(classId);
    return data.map((item: Record<string, any>) => Schedule.fromMap(item));
  } catch (error) {
    console.error("Failed to fetch schedules by class:", error);
    throw error;
  }
};

/** UPDATE SCHEDULE */
export const editSchedule = async (
  id: string,
  classId: string,
  subjectId: string,
  dayOfWeek: DayOfWeek,
  startTime: string,
  endTime: string
): Promise<Schedule> => {
  try {
    validateTimes(startTime, endTime); 
    const schedule = new Schedule(
      id,
      classId,
      subjectId,
      dayOfWeek,
      startTime,
      endTime
    );
    const result = await updateSchedule(id, schedule.toMap());
    return Schedule.fromMap(result);
  } catch (error) {
    console.error("Failed to update schedule:", error);
    throw error;
  }
};

/** DELETE SCHEDULE */
export const removeSchedule = async (id: string): Promise<boolean> => {
  try {
    await deleteSchedule(id);
    return true;
  } catch (error) {
    console.error("Failed to delete schedule:", error);
    return false;
  }
};