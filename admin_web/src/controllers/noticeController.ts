import { Notice } from "../models/notice";
import {
  createNotice,
  getAllNotices,
  getNoticeById,
  updateNotice,
  deleteNotice,
} from "../supabase/notics";

/** CREATE NOTICE */
export const addNotice = async (
  title: string,
  description: string,
  scheduledAt: Date | null,
  priority: string
): Promise<Notice> => {
  try {
    const notice = new Notice(null, title, new Date(), scheduledAt, description, priority);
    const result = await createNotice(notice.toMap());
    return Notice.fromMap(result);
  } catch (error) {
    console.error("Failed to create notice:", error);
    throw error;
  }
};

/** GET ALL NOTICES */
export const fetchNotices = async (): Promise<Notice[]> => {
  try {
    const data = await getAllNotices();
    return data.map((item: Record<string, any>) => Notice.fromMap(item));
  } catch (error) {
    console.error("Failed to fetch notices:", error);
    throw error;
  }
};

/** GET NOTICE BY ID */
export const fetchNoticeById = async (id: string): Promise<Notice> => {
  try {
    const data = await getNoticeById(id);
    return Notice.fromMap(data);
  } catch (error) {
    console.error("Failed to fetch notice by id:", error);
    throw error;
  }
};

/** UPDATE NOTICE */
export const editNotice = async (
  id: string,
  title: string,
  description: string,
  scheduledAt: Date | null,
  priority: string,
  publishedAt: Date        // original publishedAt preserved
): Promise<Notice> => {
  try {
    const notice = new Notice(id, title, publishedAt, scheduledAt, description, priority);
    const result = await updateNotice(id, notice.toMap());
    return Notice.fromMap(result);
  } catch (error) {
    console.error("Failed to update notice:", error);
    throw error;
  }
};

/** DELETE NOTICE */
export const removeNotice = async (id: string): Promise<boolean> => {
  try {
    await deleteNotice(id);
    return true;
  } catch (error) {
    console.error("Failed to delete notice:", error);
    return false;
  }
};