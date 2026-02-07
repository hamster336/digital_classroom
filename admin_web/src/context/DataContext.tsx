import React, { createContext, useContext, useEffect, useState } from 'react';
import {
    Classroom,
    Notice,
    Student,
    Subject, Teacher,
    classrooms as initialClassrooms,
    notices as initialNotices,
    students as initialStudents,
    subjects as initialSubjects,
    teachers as initialTeachers
} from '../lib/dummy-data';

interface DataContextType {
    classrooms: Classroom[];
    subjects: Subject[];
    teachers: Teacher[];
    students: Student[];
    notices: Notice[];

    addClassroom: (classroom: Classroom) => void;
    updateClassroom: (classroom: Classroom) => void;
    deleteClassroom: (id: string) => void;

    addSubject: (subject: Subject) => void;
    updateSubject: (subject: Subject) => void;
    deleteSubject: (id: string) => void;

    addTeacher: (teacher: Teacher) => void;
    updateTeacher: (teacher: Teacher) => void;
    deleteTeacher: (id: string) => void;

    addStudent: (student: Student) => void;
    updateStudent: (student: Student) => void;
    deleteStudent: (id: string) => void;

    addNotice: (notice: Notice) => void;
    updateNotice: (notice: Notice) => void;
    deleteNotice: (id: string) => void;
    resetToDefaults: () => void;
}

const DATA_VERSION = 'v1.1'; // Increment this to force all clients to refresh their data

const DataContext = createContext<DataContextType | undefined>(undefined);

export function DataProvider({ children }: { children: React.ReactNode }) {
    const [classrooms, setClassrooms] = useState<Classroom[]>([]);
    const [subjects, setSubjects] = useState<Subject[]>([]);
    const [teachers, setTeachers] = useState<Teacher[]>([]);
    const [students, setStudents] = useState<Student[]>([]);
    const [notices, setNotices] = useState<Notice[]>([]);

    const [isLoading, setIsLoading] = useState(true);

    const STORAGE_KEYS = {
        VERSION: 'academia_data_version',
        CLASSROOMS: 'academia_classrooms',
        SUBJECTS: 'academia_subjects',
        TEACHERS: 'academia_teachers',
        STUDENTS: 'academia_students',
        NOTICES: 'academia_notices'
    };

    // Initial load and sync
    useEffect(() => {
        const storedVersion = localStorage.getItem(STORAGE_KEYS.VERSION);

        // If version mismatch or missing, clear everything to force fresh dummy data
        if (storedVersion !== DATA_VERSION) {
            Object.values(STORAGE_KEYS).forEach(key => localStorage.removeItem(key));
            localStorage.setItem(STORAGE_KEYS.VERSION, DATA_VERSION);
        }

        const load = (key: string, initial: any[]) => {
            const stored = localStorage.getItem(key);
            return stored ? JSON.parse(stored) : initial;
        };

        setClassrooms(load(STORAGE_KEYS.CLASSROOMS, initialClassrooms));
        setSubjects(load(STORAGE_KEYS.SUBJECTS, initialSubjects));
        setTeachers(load(STORAGE_KEYS.TEACHERS, initialTeachers));
        setStudents(load(STORAGE_KEYS.STUDENTS, initialStudents));
        setNotices(load(STORAGE_KEYS.NOTICES, initialNotices));

        setIsLoading(false);
    }, []);

    // Effect for persistence
    useEffect(() => {
        if (!isLoading) {
            localStorage.setItem(STORAGE_KEYS.CLASSROOMS, JSON.stringify(classrooms));
            localStorage.setItem(STORAGE_KEYS.SUBJECTS, JSON.stringify(subjects));
            localStorage.setItem(STORAGE_KEYS.TEACHERS, JSON.stringify(teachers));
            localStorage.setItem(STORAGE_KEYS.STUDENTS, JSON.stringify(students));
            localStorage.setItem(STORAGE_KEYS.NOTICES, JSON.stringify(notices));
        }
    }, [classrooms, subjects, teachers, students, notices, isLoading]);

    const resetToDefaults = () => {
        Object.values(STORAGE_KEYS).forEach(key => localStorage.removeItem(key));
        localStorage.setItem(STORAGE_KEYS.VERSION, DATA_VERSION);
        setClassrooms(initialClassrooms);
        setSubjects(initialSubjects);
        setTeachers(initialTeachers);
        setStudents(initialStudents);
        setNotices(initialNotices);
        window.location.reload(); // Force reload to ensure everything is fresh
    };

    // Handlers
    const addClassroom = (item: Classroom) => setClassrooms(prev => [...prev, item]);
    const updateClassroom = (item: Classroom) => setClassrooms(prev => prev.map(i => i.id === item.id ? item : i));
    const deleteClassroom = (id: string) => setClassrooms(prev => prev.filter(i => i.id !== id));

    const addSubject = (item: Subject) => setSubjects(prev => [...prev, item]);
    const updateSubject = (item: Subject) => setSubjects(prev => prev.map(i => i.id === item.id ? item : i));
    const deleteSubject = (id: string) => setSubjects(prev => prev.filter(i => i.id !== id));

    const addTeacher = (item: Teacher) => setTeachers(prev => [...prev, item]);
    const updateTeacher = (item: Teacher) => setTeachers(prev => prev.map(i => i.id === item.id ? item : i));
    const deleteTeacher = (id: string) => setTeachers(prev => prev.filter(i => i.id !== id));

    const addStudent = (item: Student) => setStudents(prev => [...prev, item]);
    const updateStudent = (item: Student) => setStudents(prev => prev.map(i => i.id === item.id ? item : i));
    const deleteStudent = (id: string) => setStudents(prev => prev.filter(i => i.id !== id));

    const addNotice = (item: Notice) => setNotices(prev => [...prev, item]);
    const updateNotice = (item: Notice) => setNotices(prev => prev.map(i => i.id === item.id ? item : i));
    const deleteNotice = (id: string) => setNotices(prev => prev.filter(i => i.id !== id));

    if (isLoading) return null;

    return (
        <DataContext.Provider value={{
            classrooms, subjects, teachers, students, notices,
            addClassroom, updateClassroom, deleteClassroom,
            addSubject, updateSubject, deleteSubject,
            addTeacher, updateTeacher, deleteTeacher,
            addStudent, updateStudent, deleteStudent,
            addNotice, updateNotice, deleteNotice,
            resetToDefaults
        }}>
            {children}
        </DataContext.Provider>
    );
}

export function useData() {
    const context = useContext(DataContext);
    if (context === undefined) {
        throw new Error('useData must be used within a DataProvider');
    }
    return context;
}
