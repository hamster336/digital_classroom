import { supabase } from "./supabase-client";
import { User } from "../models/user";

export const createUserDB = async (user: User): Promise<User> => {
  const { data, error } = await supabase
    .from("users")
    .insert([user.toInsertMap()]) 
    .select()
    .single();

  if (error) throw error;
  return User.fromMap(data);
};

export const getAllUsersDB = async (): Promise<User[]> => {
  const { data, error } = await supabase
    .from("users")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) throw error;
  return data.map((item: any) => User.fromMap(item));
};

export const getUserByIdDB = async (id: string): Promise<User> => {
  const { data, error } = await supabase
    .from("users")
    .select("*")
    .eq("id", id)
    .single();

  if (error) throw error;
  return User.fromMap(data);
};

export const updateUserDB = async (
  id: string,
  updates: Partial<User>
): Promise<User> => {
  
  const dbUpdates: any = {};
  if (updates.fullName !== undefined) dbUpdates.full_name = updates.fullName;
  if (updates.email !== undefined) dbUpdates.email = updates.email;
  if (updates.role !== undefined) dbUpdates.role = updates.role;

  const { data, error } = await supabase
    .from("users")
    .update(dbUpdates)
    .eq("id", id)
    .select()
    .single();

  if (error) throw error;
  return User.fromMap(data);
};

export const deleteUserDB = async (id: string): Promise<boolean> => {
  const { error } = await supabase
    .from("users")
    .delete()
    .eq("id", id);

  if (error) throw error;
  return true;
};