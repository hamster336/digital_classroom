import React, { createContext, useContext, useEffect, useState } from 'react';

interface User {
    id: string;
    name: string;
    email: string;
    role: 'admin' | 'teacher' | 'student';
}

interface AuthContextType {
    user: User | null;
    login: (email: string, name: string) => void;
    signup: (email: string, name: string) => void;
    logout: () => void;
    isAuthenticated: boolean;
    isLoading: boolean;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
    const [user, setUser] = useState<User | null>(null);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        // Check for stored user on refresh
        const storedUser = localStorage.getItem('academia_user');
        if (storedUser) {
            setUser(JSON.parse(storedUser));
        } else {
            // Default "Public Admin" for instant access
            const guestUser: User = {
                id: 'guest',
                name: 'Guest Administrator',
                email: 'guest@academia.edu',
                role: 'admin'
            };
            setUser(guestUser);
            localStorage.setItem('academia_user', JSON.stringify(guestUser));
        }
        setIsLoading(false);
    }, []);

    const login = (email: string, name: string) => {
        const dummyUser: User = {
            id: Math.random().toString(36).substr(2, 9),
            name: name || 'Admin User',
            email,
            role: 'admin'
        };
        setUser(dummyUser);
        localStorage.setItem('academia_user', JSON.stringify(dummyUser));
    };

    const signup = (email: string, name: string) => {
        const dummyUser: User = {
            id: Math.random().toString(36).substr(2, 9),
            name: name,
            email,
            role: 'admin'
        };
        setUser(dummyUser);
        localStorage.setItem('academia_user', JSON.stringify(dummyUser));
    };

    const logout = () => {
        setUser(null);
        localStorage.removeItem('academia_user');
    };

    return (
        <AuthContext.Provider value={{ user, login, signup, logout, isAuthenticated: !!user, isLoading }}>
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
