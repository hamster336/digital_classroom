import React, { createContext, useContext, useEffect, useState } from 'react';

//  Import  models
import { Classroom } from '../models/classroom';
import { Notice } from '../models/notice';
import { Student } from '../models/student';
import { Subject } from '../models/subject';
import { Teacher } from '../models/teacher';

//  Import controllers
import {
  addClassroom as addClassroomDB,
  editClassroom,
  fetchClassrooms,
  removeClassroom,
} from '../controllers/classroomController';
import {
  addNotice as addNoticeDB,
  editNotice,
  fetchNotices,
  removeNotice,
} from '../controllers/noticeController';
import {
  addStudent as addStudentDB,
  editStudent,
  fetchStudents,
  removeStudent,
} from '../controllers/studentController';
import {
  addSubject as addSubjectDB,
  editSubject,
  fetchSubject,
  removeSubject,
} from '../controllers/subjectController';
import {
  addTeacher as addTeacherDB,
  editTeacher,
  fetchTeachers,
  removeTeacher,
} from '../controllers/teacherController';

interface DataContextType {
  // State
  classrooms: Classroom[];
  subjects: Subject[];
  teachers: Teacher[];
  students: Student[];
  notices: Notice[];
  isLoading: boolean;
  error: string | null;

  // Classroom
  addClassroom: (name: string, faculty: string, startYear: number, endYear: number, isActive: boolean) => Promise<void>;
  updateClassroom: (id: string, name: string, faculty: string, startYear: number, endYear: number, isActive: boolean, createdAt: Date) => Promise<void>;
  deleteClassroom: (id: string) => Promise<void>;

  // Subject
  addSubject: (name: string, classId: string, teacherId: string) => Promise<void>;
  updateSubject: (id: string, name: string, classId: string, teacherId: string) => Promise<void>;
  deleteSubject: (id: string) => Promise<void>;

  // Teacher
  addTeacher: (employeeId: string, subjectIds: string[], classIds: string[], avatarUrl: string | null) => Promise<void>;
  updateTeacher: (id: string, employeeId: string, subjectIds: string[], classIds: string[], avatarUrl: string | null, lastCheckedNotices: Date | null) => Promise<void>;
  deleteTeacher: (id: string) => Promise<void>;

  // Student
  addStudent: (rollNo: number, subjectIds: string[], avatarUrl: string | null, classId: string) => Promise<void>;
  updateStudent: (id: string, rollNo: number, subjectIds: string[], avatarUrl: string | null, classId: string, lastCheckedNotices: Date | null) => Promise<void>;
  deleteStudent: (id: string) => Promise<void>;

  // Notice
  addNotice: (title: string, description: string, scheduledAt: Date | null, priority: string) => Promise<void>;
  updateNotice: (id: string, title: string, description: string, scheduledAt: Date | null, priority: string, publishedAt: Date) => Promise<void>;
  deleteNotice: (id: string) => Promise<void>;

  // Refresh
  refreshAll: () => Promise<void>;
}

const DataContext = createContext<DataContextType | undefined>(undefined);

export function DataProvider({ children }: { children: React.ReactNode }) {
  const [classrooms, setClassrooms] = useState<Classroom[]>([]);
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [teachers, setTeachers] = useState<Teacher[]>([]);
  const [students, setStudents] = useState<Student[]>([]);
  const [notices, setNotices] = useState<Notice[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  //  Load all data from Supabase on mount
  const loadAll = async () => {
    try {
      setIsLoading(true);
      setError(null);
      const [c, s, t, st, n] = await Promise.all([
        fetchClassrooms(),
        fetchSubject(),
        fetchTeachers(),
        fetchStudents(),
        fetchNotices(),
      ]);
      setClassrooms(c);
      setSubjects(s);
      setTeachers(t);
      setStudents(st);
      setNotices(n);
    } catch (err) {
      setError("Failed to load data. Please refresh.");
      console.error("DataContext load error:", err);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    loadAll();
  }, []);

  // Refresh all data
  const refreshAll = async () => {
    await loadAll();
  };

  // CLASSROOM handlers
  const addClassroom = async (
    name: string,
    faculty: string,
    startYear: number,
    endYear: number,
    isActive: boolean
  ) => {
    try {
      const newItem = await addClassroomDB(name, faculty, startYear, endYear, isActive);
      setClassrooms(prev => [...prev, newItem]); // update state instantly
    } catch (err) {
      console.error("Failed to add classroom:", err);
      throw err;
    }
  };

  const updateClassroom = async (
    id: string,
    name: string,
    faculty: string,
    startYear: number,
    endYear: number,
    isActive: boolean,
    createdAt: Date
  ) => {
    try {
      const updated = await editClassroom(id, name, faculty, startYear, endYear, isActive, createdAt);
      setClassrooms(prev => prev.map(i => i.id === id ? updated : i)); 
    } catch (err) {
      console.error("Failed to update classroom:", err);
      throw err;
    }
  };

  const deleteClassroom = async (id: string) => {
    try {
      await removeClassroom(id);
      setClassrooms(prev => prev.filter(i => i.id !== id)); 
    } catch (err) {
      console.error("Failed to delete classroom:", err);
      throw err;
    }
  };

  //  SUBJECT handlers
  const addSubject = async (name: string, classId: string, teacherId: string) => {
    try {
      const newItem = await addSubjectDB(name, classId, teacherId);
      setSubjects(prev => [...prev, newItem]);
    } catch (err) {
      console.error("Failed to add subject:", err);
      throw err;
    }
  };

  const updateSubject = async (id: string, name: string, classId: string, teacherId: string) => {
    try {
      const updated = await editSubject(id, name, classId, teacherId);
      setSubjects(prev => prev.map(i => i.id === id ? updated : i));
    } catch (err) {
      console.error("Failed to update subject:", err);
      throw err;
    }
  };

  const deleteSubject = async (id: string) => {
    try {
      await removeSubject(id);
      setSubjects(prev => prev.filter(i => i.id !== id));
    } catch (err) {
      console.error("Failed to delete subject:", err);
      throw err;
    }
  };

  //  TEACHER handlers
  const addTeacher = async (
    employeeId: string,
    subjectIds: string[],
    classIds: string[],
    avatarUrl: string | null
  ) => {
    try {
      const newItem = await addTeacherDB(employeeId, subjectIds, classIds, avatarUrl);
      setTeachers(prev => [...prev, newItem]);
    } catch (err) {
      console.error("Failed to add teacher:", err);
      throw err;
    }
  };

  const updateTeacher = async (
    id: string,
    employeeId: string,
    subjectIds: string[],
    classIds: string[],
    avatarUrl: string | null,
    lastCheckedNotices: Date | null
  ) => {
    try {
      const updated = await editTeacher(id, employeeId, subjectIds, classIds, avatarUrl, lastCheckedNotices);
      setTeachers(prev => prev.map(i => i.id === id ? updated : i));
    } catch (err) {
      console.error("Failed to update teacher:", err);
      throw err;
    }
  };

  const deleteTeacher = async (id: string) => {
    try {
      await removeTeacher(id);
      setTeachers(prev => prev.filter(i => i.id !== id));
    } catch (err) {
      console.error("Failed to delete teacher:", err);
      throw err;
    }
  };

  //  STUDENT handlers
  const addStudent = async (
    rollNo: number,
    subjectIds: string[],
    avatarUrl: string | null,
    classId: string
  ) => {
    try {
      const newItem = await addStudentDB(rollNo, subjectIds, avatarUrl, classId);
      setStudents(prev => [...prev, newItem]);
    } catch (err) {
      console.error("Failed to add student:", err);
      throw err;
    }
  };

  const updateStudent = async (
    id: string,
    rollNo: number,
    subjectIds: string[],
    avatarUrl: string | null,
    classId: string,
    lastCheckedNotices: Date | null
  ) => {
    try {
      const updated = await editStudent(id, rollNo, subjectIds, avatarUrl, classId, lastCheckedNotices);
      setStudents(prev => prev.map(i => i.id === id ? updated : i));
    } catch (err) {
      console.error("Failed to update student:", err);
      throw err;
    }
  };

  const deleteStudent = async (id: string) => {
    try {
      await removeStudent(id);
      setStudents(prev => prev.filter(i => i.id !== id));
    } catch (err) {
      console.error("Failed to delete student:", err);
      throw err;
    }
  };

  //  NOTICE handlers
  const addNotice = async (
    title: string,
    description: string,
    scheduledAt: Date | null,
    priority: string
  ) => {
    try {
      const newItem = await addNoticeDB(title, description, scheduledAt, priority);
      setNotices(prev => [...prev, newItem]);
    } catch (err) {
      console.error("Failed to add notice:", err);
      throw err;
    }
  };

  const updateNotice = async (
    id: string,
    title: string,
    description: string,
    scheduledAt: Date | null,
    priority: string,
    publishedAt: Date
  ) => {
    try {
      const updated = await editNotice(id, title, description, scheduledAt, priority, publishedAt);
      setNotices(prev => prev.map(i => i.id === id ? updated : i));
    } catch (err) {
      console.error("Failed to update notice:", err);
      throw err;
    }
  };

  const deleteNotice = async (id: string) => {
    try {
      await removeNotice(id);
      setNotices(prev => prev.filter(i => i.id !== id));
    } catch (err) {
      console.error("Failed to delete notice:", err);
      throw err;
    }
  };

  if (isLoading) return (
    <div className="flex items-center justify-center h-screen">
      <p className="text-slate-500 font-medium">Loading data...</p>
    </div>
  );

  if (error) return (
    <div className="flex items-center justify-center h-screen">
      <p className="text-red-500 font-medium">{error}</p>
    </div>
  );

  return (
    <DataContext.Provider value={{
      classrooms, subjects, teachers, students, notices,
      isLoading, error,
      addClassroom, updateClassroom, deleteClassroom,
      addSubject, updateSubject, deleteSubject,
      addTeacher, updateTeacher, deleteTeacher,
      addStudent, updateStudent, deleteStudent,
      addNotice, updateNotice, deleteNotice,
      refreshAll,
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