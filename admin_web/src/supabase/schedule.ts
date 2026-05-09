import { supabase } from "./supabase-client";
import { supabaseAdmin } from "./supabase-admin-client";
import { Schedule } from "../models/schedules";

export interface ScheduleFile {
    name: string;
    url: string;
    type: 'image' | 'pdf';
    path: string;
}

// Get all schedules from DB table
export const getAllSchedulesDB = async (): Promise<Schedule[]> => {
    const { data, error } = await supabase
        .from("schedules")
        .select("*")
        .order("created_at", { ascending: false });

    if (error) throw error;
    return (data || []).map((item: any) => Schedule.fromMap(item));
};

// Create schedule record in DB table
export const createScheduleDB = async (schedule: Schedule): Promise<Schedule> => {
    const { data, error } = await supabaseAdmin
        .from("schedules")
        .insert([schedule.toInsertMap()])
        .select()
        .single();

    if (error) throw error;
    return Schedule.fromMap(data);
};

//  Delete schedule record from DB table
export const deleteScheduleDB = async (id: string): Promise<void> => {
    const { error } = await supabaseAdmin
        .from("schedules")
        .delete()
        .eq("id", id);

    if (error) throw error;
};

// Upload file to bucket
export const uploadScheduleFileDB = async (
    file: File,
    folderName: string
): Promise<ScheduleFile> => {
    const filePath = `${folderName}/${file.name}`;

    const { error } = await supabaseAdmin.storage
        .from("schedules")
        .upload(filePath, file, { upsert: true });

    if (error) throw error;

    const { data: urlData } = supabase.storage
        .from("schedules")
        .getPublicUrl(filePath);

    const ext = file.name.split('.').pop()?.toLowerCase();
    const type = ext === 'pdf' ? 'pdf' : 'image';

    return {
        name: file.name,
        url: urlData.publicUrl,
        type,
        path: filePath,
    };
};

//  Delete file from bucket
export const deleteScheduleFileDB_storage = async (path: string): Promise<void> => {
    const { error } = await supabaseAdmin.storage
        .from("schedules")
        .remove([path]);

    if (error) throw error;
};

//  Get public URL from file_path
export const getScheduleFileUrl = (filePath: string): ScheduleFile => {
    const { data: urlData } = supabase.storage
        .from("schedules")
        .getPublicUrl(filePath);

    const ext = filePath.split('.').pop()?.toLowerCase();
    const type = ext === 'pdf' ? 'pdf' : 'image';
    const name = filePath.split('/').pop() || filePath;

    return {
        name,
        url: urlData.publicUrl,
        type,
        path: filePath,
    };
};