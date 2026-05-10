import React, { createContext, useContext, useEffect, useState } from 'react';
import { loginAdmin, logoutAdmin, getCurrentAdmin } from '@/supabase/auth'; 
import { signUp } from '@/supabase/signup'; 

interface User {
    id: string;
    name: string;
    email: string;
    role: 'admin' | 'teacher' | 'student';
}

interface AuthContextType {
    user: User | null;
    login: (email: string, password: string) => Promise<void>; 
    signup: (email: string, password: string, name: string) => Promise<void>; 
    logout: () => Promise<void>;  
    isAuthenticated: boolean;
    isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [user, setUser] = useState<User | null>(null);
    const [isLoading, setIsLoading] = useState(true);

    //  Supabase session on refresh
    useEffect(() => {
        const loadUser = async () => {
            try {
                const supabaseUser = await getCurrentAdmin();
                if (supabaseUser) {
                    setUser({
                        id: supabaseUser.id,
                        name: supabaseUser.user_metadata?.name || supabaseUser.email || 'Admin',
                        email: supabaseUser.email ?? '',
                        role: supabaseUser.user_metadata?.role || 'admin'
                    });
                }
            } catch {
                setUser(null); 
            } finally {
                setIsLoading(false);
            }
        };
        loadUser();
    }, []);

    // Supabase login
    const login = async (email: string, password: string) => {
        try {
            const { user: supabaseUser } = await loginAdmin(email, password);
            if (supabaseUser) {
                setUser({
                    id: supabaseUser.id,
                    name: supabaseUser.user_metadata?.name || email,
                    email: supabaseUser.email ?? '',
                    role: supabaseUser.user_metadata?.role || 'admin'
                });
            }
        } catch (error) {
            console.error("Login failed:", error);
            throw error;
        }
    };

    // signin
    const signup = async (email: string, password: string, name: string) => {
        try {
            const { user: supabaseUser } = await signUp(email, password);
            if (supabaseUser) {
                setUser({
                    id: supabaseUser.id,
                    name: name || email,
                    email: supabaseUser.email ?? '',
                    role: 'admin'
                });
            }
        } catch (error) {
            console.error("Signup failed:", error);
            throw error; 
        }
    };

    //  Supabase logout
    const logout = async () => {
        try {
            await logoutAdmin();
            setUser(null);
        } catch (error) {
            console.error("Logout failed:", error);
            throw error;
        }
    };

    return (
        <AuthContext.Provider value={{
            user,
            login,
            signup,
            logout,
            isAuthenticated: !!user,
            isLoading
        }}>
            {children}
        </AuthContext.Provider>
    );
};

export const useAuth = () => {
    const context = useContext(AuthContext);
    if (context === undefined) {
        throw new Error('useAuth must be used within an AuthProvider');
    }
    return context;
};