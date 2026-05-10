import { User } from "../models/user";
import {
    createUserDB,
    getAllUsersDB,
    getUserByIdDB,
    updateUserDB,
    deleteUserDB,
} from "../supabase/user";
import { supabaseAdmin } from "../supabase/supabase-admin-client"; 

export const signUpUser = async (
    fullName: string,
    email: string,
    role: 'student' | 'teacher' | 'admin' = 'student'
): Promise<User> => {
    const password = '@user123';

    const { data: authData, error: authError } = await supabaseAdmin.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
    });

    if (authError) throw authError;
    if (!authData.user) throw new Error("Auth signup failed.");

    const user = new User(
        authData.user.id,
        fullName,
        email,
        role,
        new Date().toISOString()
    );

    const { data, error: userInsertError } = await supabaseAdmin
        .from("users")
        .insert([user.toInsertMap()])
        .select()
        .single();

    if (userInsertError) throw userInsertError;

    return User.fromMap(data);
};

export const createUser = async (
    id: string,
    fullName: string,
    email: string,
    role: 'student' | 'teacher' | 'admin'
): Promise<User> => {
    const user = new User(id, fullName, email, role, new Date().toISOString());
    return await createUserDB(user);
};

export const getAllUsers = async (): Promise<User[]> => {
    return await getAllUsersDB();
};

export const getUserById = async (id: string): Promise<User> => {
    return await getUserByIdDB(id);
};

export const updateUser = async (
    id: string,
    updates: Partial<User>
): Promise<User> => {
    return await updateUserDB(id, updates);
};

export const deleteUser = async (id: string): Promise<boolean> => {
    return await deleteUserDB(id);
};
export const signUpStudent = signUpUser;