import { Schedule } from "../models/schedules";
import {
    getAllSchedulesDB,
    createScheduleDB,
    deleteScheduleDB,
    uploadScheduleFileDB,
    deleteScheduleFileDB_storage,
    getScheduleFileUrl,
    ScheduleFile,
} from "../supabase/schedule";

const SCHEDULE_FOLDER = "0011e270-2b78-4d7b-b597-37f75780c705";

// Get all schedules with file info
export const getSchedules = async (): Promise<(Schedule & { file: ScheduleFile })[]> => {
    const schedules = await getAllSchedulesDB();

    return schedules.map((schedule) => ({
        ...schedule,
        file: getScheduleFileUrl(schedule.filePath),
    }));
};

// Add schedule
export const addSchedule = async (
    name: string,
    classId: string,
    file: File
): Promise<Schedule & { file: ScheduleFile }> => {

    const allowedTypes = [
        "image/png",
        "image/jpeg",
        "image/jpg",
        "application/pdf",
    ];

    if (!allowedTypes.includes(file.type)) {
        throw new Error("Only image and PDF files are allowed.");
    }

    // Upload file to bucket
    const uploadedFile = await uploadScheduleFileDB(
        file,
        SCHEDULE_FOLDER
    );

    // Create DB record
    const schedule = new Schedule(
        "",
        name,
        classId,
        uploadedFile.path,
        new Date().toISOString()
    );

    const createdSchedule = await createScheduleDB(schedule);

    return {
        ...createdSchedule,
        file: uploadedFile,
    };
};

// Delete schedule
export const deleteSchedule = async (
    id: string,
    filePath: string
): Promise<void> => {

    // Delete file from storage
    await deleteScheduleFileDB_storage(filePath);

    // Delete DB record
    await deleteScheduleDB(id);
};