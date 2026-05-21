import { Button, Card, CardContent, CardHeader, CardTitle, Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, Input } from '@/components/ui';
import { useData } from '@/context/DataContext';
import { Subject } from '@/models/subject';
import { Teacher } from '@/models/teacher';
import { cn } from '@/lib/utils';
import { BookOpen, Check, ChevronLeft, ChevronRight, GraduationCap, Plus, Search, SlidersHorizontal, UserCheck, X } from 'lucide-react';
import { useEffect, useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { ManagementPage } from '../shared/ManagementPage';

interface TeacherFormData {
    id: string | null;
    fullName: string;
    email: string;
    employeeId: string;
    subjectIds: string[];
    classIds: string[];
    avatarFile?: File | null;
    avatarPath?: string | null;
    [key: string]: any;
}

interface StudentFormData {
    id: string | null;
    fullName: string;
    email: string;
    rollNumber: string;
    subjectIds: string[];
    classId: string;
    [key: string]: any;
}

export const TeacherManagement = () => {
    const { teachers, addTeacher, updateTeacher, deleteTeacher, subjects, classrooms } = useData();

    const teacherFormData: TeacherFormData[] = teachers.map(t => ({
        id: t.id,
        fullName: t.fullName || '',
        email: t.email || '',
        employeeId: t.employeeId,
        subjectIds: t.subjectIds,
        classIds: t.classIds,
        avatarFile: null,
        avatarPath: t.avatarPath || null,
    }));

    return (
        <ManagementPage<TeacherFormData>
            title="Teachers"
            data={teacherFormData}
            columns={[
                {
                    key: 'avatarPath',
                    label: 'Photo',
                    render: (val: string | null, item: TeacherFormData) => (
                        val ? (
                            <img
                                src={val}
                                alt="avatar"
                                className="w-9 h-9 rounded-full object-cover border-2 border-primary/20"
                            />
                        ) : (
                            <div className="w-9 h-9 rounded-full bg-primary/10 flex items-center justify-center text-primary font-bold text-sm">
                                {item.fullName?.charAt(0).toUpperCase() || '?'}
                            </div>
                        )
                    )
                },
                { key: 'fullName', label: 'Full Name' },
                { key: 'employeeId', label: 'Employee ID' },
                {
                    key: 'subjectIds',
                    label: 'Subjects',
                    render: (val: string[]) => (
                        <span>
                            {val?.length > 0
                                ? val.map(id => subjects.find(s => s.id === id)?.name).filter(Boolean).join(', ')
                                : 'None'}
                        </span>
                    )
                },
                {
                    key: 'classIds',
                    label: 'Classes',
                    render: (val: string[]) => (
                        <span>
                            {val?.length > 0
                                ? val.map(id => classrooms.find(c => c.id === id)?.name).filter(Boolean).join(', ')
                                : 'None'}
                        </span>
                    )
                },
            ]}
            onSave={async (item) => {
                if (!item.employeeId?.trim()) throw new Error("Employee ID is required.");
                if (!item.id && !item.fullName?.trim()) throw new Error("Full Name is required.");
                if (!item.id && !item.email?.trim()) throw new Error("Email is required.");
                const existing = teachers.find(t => t.id === item.id);
                if (existing && item.id) {
                    await updateTeacher(item.id!, {
                        employeeId: item.employeeId,
                        subjectIds: item.subjectIds ?? [],
                        classIds: item.classIds ?? [],

                    });
                } else {
                    await addTeacher(
                        item.fullName,
                        item.email,
                        item.employeeId,
                        item.subjectIds ?? [],
                        item.classIds ?? [],
                        item.avatarFile ?? null
                    );
                }
            }}
            onDelete={async (id) => await deleteTeacher(id)}
            emptyEntity={{
                id: null,
                fullName: '',
                email: '',
                employeeId: '',
                subjectIds: [],
                classIds: [],
                avatarFile: null,
            }}
            renderForm={(data, onChange) => (
                <div className="grid gap-4 sm:grid-cols-2">
                    {!data.id && (
                        <>
                            <div className="space-y-2">
                                <label className="text-sm font-medium">Full Name</label>
                                <Input
                                    value={data.fullName || ''}
                                    onChange={(e) => onChange('fullName', e.target.value)}
                                    placeholder="e.g. John Doe"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-medium">Email</label>
                                <Input
                                    type="email"
                                    value={data.email || ''}
                                    onChange={(e) => onChange('email', e.target.value)}
                                    placeholder="e.g. john@school.com"
                                />
                            </div>
                        </>
                    )}
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Employee ID</label>
                        <Input
                            value={data.employeeId || ''}
                            onChange={(e) => onChange('employeeId', e.target.value)}
                            placeholder="e.g. EMP001"
                        />
                    </div>
                    {/*  Avatar upload */}
                    <div className="space-y-2 sm:col-span-2">
                        <label className="text-sm font-medium">Profile Photo</label>
                        <div className="flex items-center gap-4">
                            {data.avatarPath ? (
                                <img
                                    src={data.avatarPath}
                                    alt="avatar"
                                    className="w-16 h-16 rounded-full object-cover border-2 border-primary/20"
                                />
                            ) : (
                                <div className="w-16 h-16 rounded-full bg-primary/10 flex items-center justify-center text-primary font-bold text-xl">
                                    {data.fullName?.charAt(0).toUpperCase() || '?'}
                                </div>
                            )}
                            <div className="space-y-1">
                                <input
                                    type="file"
                                    accept="image/*"
                                    className="text-sm text-slate-600"
                                    onChange={async (e) => {
                                        const file = e.target.files?.[0];
                                        if (!file) return;
                                        if (data.id) {
                                            // existing teacher — upload immediately
                                            
                                            try {
                                                const { uploadTeacherAvatar
                                                } = await import('@/controllers/teacherController');
                                                const url = await uploadTeacherAvatar(data.id, file);
                                                onChange('avatarPath', url);
                                            } catch (err: any) {
                                                console.error("Upload failed:", err);
                                            }
                                        } else {
                                            // new teacher — store file for upload on save
                                            onChange('avatarFile', file);
                                            onChange('avatarPath', URL.createObjectURL(file)); // preview
                                        }
                                    }}
                                />
                                <p className="text-xs text-slate-400">
                                    {data.id ? 'Upload to change photo' : 'Will be uploaded on save'}
                                </p>
                            </div>
                        </div>
                    </div>

                    <div className="space-y-2 sm:col-span-2">
                        <label className="text-sm font-medium">Assign Classes</label>
                        <div className="flex flex-wrap gap-2 p-3 border rounded-lg min-h-[48px]">
                            {classrooms.length === 0 ? (
                                <p className="text-sm text-slate-400">No classes available. Add classrooms first.</p>
                            ) : (
                                classrooms.map(c => (
                                    <button
                                        key={c.id}
                                        type="button"
                                        onClick={() => {
                                            const current = data.classIds || [];
                                            const updated = current.includes(c.id!)
                                                ? current.filter((id: string) => id !== c.id)
                                                : [...current, c.id!];
                                            onChange('classIds', updated);
                                            onChange('subjectIds', []);
                                        }}
                                        className={`px-3 py-1 rounded-full text-xs font-bold border transition-all ${(data.classIds || []).includes(c.id!)
                                            ? 'bg-primary text-white border-primary'
                                            : 'bg-white text-slate-600 border-slate-200 hover:border-primary hover:text-primary'
                                            }`}
                                    >
                                        {c.name}
                                    </button>
                                ))
                            )}
                        </div>
                    </div>

                    <div className="space-y-2 sm:col-span-2">
                        <label className="text-sm font-medium">Assign Subjects</label>
                        {(data.classIds || []).length === 0 ? (
                            <p className="text-sm text-slate-400 p-3 border rounded-lg">
                                Select a class first to see available subjects.
                            </p>
                        ) : (
                            <div className="flex flex-wrap gap-2 p-3 border rounded-lg min-h-[48px]">
                                {subjects.filter(s => (data.classIds || []).includes(s.classId)).length === 0 ? (
                                    <p className="text-sm text-slate-400">No subjects found for selected classes.</p>
                                ) : (
                                    subjects
                                        .filter(s => (data.classIds || []).includes(s.classId))
                                        .map(s => (
                                            <button
                                                key={s.id}
                                                type="button"
                                                onClick={() => {
                                                    const current = data.subjectIds || [];
                                                    const updated = current.includes(s.id!)
                                                        ? current.filter((id: string) => id !== s.id)
                                                        : [...current, s.id!];
                                                    onChange('subjectIds', updated);
                                                }}
                                                className={`px-3 py-1 rounded-full text-xs font-bold border transition-all ${(data.subjectIds || []).includes(s.id!)
                                                    ? 'bg-primary text-white border-primary'
                                                    : 'bg-white text-slate-600 border-slate-200 hover:border-primary hover:text-primary'
                                                    }`}
                                            >
                                                {s.name}
                                            </button>
                                        ))
                                )}
                            </div>
                        )}
                    </div>
                </div>
            )}
        />
    );
};

export const StudentManagement = () => {
    const { students, addStudent, updateStudent, deleteStudent, classrooms, subjects } = useData();

    const studentFormData: StudentFormData[] = students.map(s => ({
        id: s.id,
        fullName: '',
        email: '',
        rollNumber: s.rollNumber,
        subjectIds: s.subjectIds,
        classId: s.classId,
    }));

    return (
        <ManagementPage<StudentFormData>
            title="Students"
            data={studentFormData}
            columns={[
                { key: 'rollNumber', label: 'Roll No' },
                {
                    key: 'classId',
                    label: 'Class',
                    render: (val) => (
                        <span>{classrooms.find(c => c.id === val)?.name ?? val}</span>
                    )
                },
                {
                    key: 'subjectIds',
                    label: 'Subjects',
                    render: (val: string[]) => (
                        <span>
                            {val?.length > 0
                                ? val.map(id => subjects.find(s => s.id === id)?.name).filter(Boolean).join(', ')
                                : 'None'}
                        </span>
                    )
                },
            ]}
            filters={[
                {
                    key: 'classId',
                    label: 'Class',
                    options: classrooms.map(c => ({
                        label: c.name,
                        value: c.id ?? ''
                    }))
                }
            ]}
            onSave={async (item) => {
                if (!item.rollNumber?.trim()) throw new Error("Roll number is required.");
                if (!item.id) {
                    const duplicate = students.find(s => s.rollNumber === item.rollNumber);
                    if (duplicate) throw new Error("Roll number already exists.");
                    if (!item.fullName?.trim()) throw new Error("Full Name is required.");
                    if (!item.email?.trim()) throw new Error("Email is required.");
                }
                const existing = students.find(s => s.id === item.id);
                if (existing) {
                    await updateStudent(item.id!, {
                        rollNumber: item.rollNumber,
                        subjectIds: item.subjectIds ?? [],
                        classId: item.classId,
                    });
                } else {
                    await addStudent(
                        item.fullName,
                        item.email,
                        item.rollNumber,
                        item.subjectIds ?? [],
                        item.classId
                    );
                }
            }}
            onDelete={async (id) => await deleteStudent(id)}
            emptyEntity={{
                id: null,
                fullName: '',
                email: '',
                rollNumber: '',
                classId: classrooms[0]?.id ?? '',
                subjectIds: [],
            }}
            renderForm={(data, onChange) => (
                <div className="grid gap-4 sm:grid-cols-2">
                    {!data.id && (
                        <>
                            <div className="space-y-2">
                                <label className="text-sm font-medium">Full Name</label>
                                <Input
                                    value={data.fullName || ''}
                                    onChange={(e) => onChange('fullName', e.target.value)}
                                    placeholder="e.g. Jane Doe"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-medium">Email</label>
                                <Input
                                    type="email"
                                    value={data.email || ''}
                                    onChange={(e) => onChange('email', e.target.value)}
                                    placeholder="e.g. jane@school.com"
                                />
                            </div>
                        </>
                    )}
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Roll No *</label>
                        <Input
                            value={data.rollNumber || ''}
                            onChange={(e) => onChange('rollNumber', e.target.value)}
                            placeholder="e.g. 001"
                        />
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Class</label>
                        <select
                            className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                            value={data.classId || ''}
                            onChange={(e) => {
                                onChange('classId', e.target.value);
                                onChange('subjectIds', []);
                            }}
                        >
                            {classrooms.map(c => (
                                <option key={c.id} value={c.id ?? ''}>{c.name}</option>
                            ))}
                        </select>
                    </div>

                    <div className="space-y-2 sm:col-span-2">
                        <label className="text-sm font-medium">Assign Subjects</label>
                        {!data.classId ? (
                            <p className="text-sm text-slate-400 p-3 border rounded-lg">
                                Select a class first to see available subjects.
                            </p>
                        ) : (
                            <div className="flex flex-wrap gap-2 p-3 border rounded-lg min-h-[48px]">
                                {subjects.filter(s => s.classId === data.classId).length === 0 ? (
                                    <p className="text-sm text-slate-400">No subjects found for this class.</p>
                                ) : (
                                    subjects
                                        .filter(s => s.classId === data.classId)
                                        .map(s => (
                                            <button
                                                key={s.id}
                                                type="button"
                                                onClick={() => {
                                                    const current = data.subjectIds || [];
                                                    const updated = current.includes(s.id!)
                                                        ? current.filter((id: string) => id !== s.id)
                                                        : [...current, s.id!];
                                                    onChange('subjectIds', updated);
                                                }}
                                                className={`px-3 py-1 rounded-full text-xs font-bold border transition-all ${(data.subjectIds || []).includes(s.id!)
                                                    ? 'bg-primary text-white border-primary'
                                                    : 'bg-white text-slate-600 border-slate-200 hover:border-primary hover:text-primary'
                                                    }`}
                                            >
                                                {s.name}
                                            </button>
                                        ))
                                )}
                            </div>
                        )}
                    </div>
                </div>
            )}
        />
    );
};

export const SubjectAssignment = () => {
    const { teachers, subjects, updateTeacher } = useData();
    const [searchParams, setSearchParams] = useSearchParams();

    const searchTerm = searchParams.get('q') || '';
    const loadFilter = searchParams.get('load') || 'all';

    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 6;

    const updateSearchParam = (key: string, value: string) => {
        setSearchParams(prev => {
            const newParams = new URLSearchParams(prev);
            if (value && value !== 'all') newParams.set(key, value);
            else newParams.delete(key);
            return newParams;
        }, { replace: true });
    };

    const clearAll = () => {
        setSearchParams(new URLSearchParams(), { replace: true });
    };

    const hasActiveFilters = searchTerm !== '' || loadFilter !== 'all';

    const filteredTeachers = useMemo(() => {
        return teachers.filter(t => {
            const matchesSearch = !searchTerm ||
                t.employeeId.toLowerCase().includes(searchTerm.toLowerCase());

            let matchesLoad = true;
            if (loadFilter === 'unassigned') matchesLoad = t.subjectIds.length === 0;
            else if (loadFilter === 'active') matchesLoad = t.subjectIds.length > 0;
            else if (loadFilter === 'overloaded') matchesLoad = t.subjectIds.length >= 3;

            return matchesSearch && matchesLoad;
        });
    }, [teachers, searchTerm, loadFilter]);

    const totalPages = Math.ceil(filteredTeachers.length / itemsPerPage);
    const paginatedTeachers = filteredTeachers.slice(
        (currentPage - 1) * itemsPerPage,
        currentPage * itemsPerPage
    );

    useEffect(() => {
        setCurrentPage(1);
    }, [searchTerm, loadFilter]);

    const toggleSubject = async (teacher: Teacher, subjectId: string) => {
        const hasSubject = teacher.subjectIds.includes(subjectId);
        await updateTeacher(teacher.id, {
            subjectIds: hasSubject
                ? teacher.subjectIds.filter(id => id !== subjectId)
                : [...teacher.subjectIds, subjectId],
        });
    };

    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-6">
                <div className="space-y-1">
                    <h2 className="text-3xl font-black tracking-tight text-slate-900">Subject Assignments</h2>
                    <p className="text-slate-500 font-medium">Manage faculty workloads and academic responsibilities.</p>
                </div>
                <div className="flex gap-4">
                    <div className="bg-white px-4 py-2 rounded-xl border border-slate-100 shadow-sm flex items-center gap-3">
                        <div className="p-1.5 bg-indigo-50 rounded-lg text-indigo-600">
                            <UserCheck className="w-4 h-4" />
                        </div>
                        <div>
                            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Faculty</p>
                            <p className="text-lg font-black text-slate-900 leading-none">{teachers.length}</p>
                        </div>
                    </div>
                    <div className="bg-white px-4 py-2 rounded-xl border border-slate-100 shadow-sm flex items-center gap-3">
                        <div className="p-1.5 bg-emerald-50 rounded-lg text-emerald-600">
                            <BookOpen className="w-4 h-4" />
                        </div>
                        <div>
                            <p className="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Subjects</p>
                            <p className="text-lg font-black text-slate-900 leading-none">{subjects.length}</p>
                        </div>
                    </div>
                </div>
            </div>

            <div className="bg-white p-4 rounded-2xl border border-slate-100 shadow-sm flex flex-col sm:flex-row gap-4 items-center">
                <div className="relative flex-1 w-full">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                    <Input
                        placeholder="Search faculty by employee ID..."
                        className="pl-10 bg-slate-50/50 border-none h-12 text-base rounded-xl focus:ring-primary/20"
                        value={searchTerm}
                        onChange={(e) => updateSearchParam('q', e.target.value)}
                    />
                </div>
                <div className="flex items-center gap-3 w-full sm:w-auto">
                    <div className="flex items-center gap-2 mr-2">
                        <span className="text-[10px] font-black text-slate-400 uppercase tracking-widest whitespace-nowrap">Filter By Load:</span>
                        <select
                            className="h-12 px-4 rounded-xl border border-slate-100 bg-slate-50/50 text-slate-600 font-bold focus:ring-2 focus:ring-primary/20 text-sm min-w-[160px] cursor-pointer hover:bg-slate-100 transition-colors"
                            value={loadFilter}
                            onChange={(e) => updateSearchParam('load', e.target.value)}
                        >
                            <option value="all">All Faculty</option>
                            <option value="unassigned">Unassigned (0)</option>
                            <option value="active">Active (1+)</option>
                            <option value="overloaded">High Load (3+)</option>
                        </select>
                    </div>
                    {hasActiveFilters && (
                        <div className="flex items-center gap-2">
                            <div className="h-8 w-px bg-slate-100 hidden sm:block mx-1" />
                            <Button
                                variant="ghost"
                                className="h-12 px-4 text-slate-400 hover:text-red-500 font-bold gap-2 whitespace-nowrap"
                                onClick={clearAll}
                            >
                                <X className="w-4 h-4" /> Clear All
                            </Button>
                        </div>
                    )}
                </div>
            </div>

            {hasActiveFilters && (
                <div className="flex items-center gap-2 animate-in fade-in duration-300">
                    <p className="text-sm font-medium text-slate-500">
                        Showing <span className="text-primary font-black">{filteredTeachers.length}</span> results for
                        {searchTerm && <span> search "<span className="text-slate-900 font-bold">{searchTerm}</span>"</span>}
                        {loadFilter !== 'all' && <span> and load status "<span className="text-slate-900 font-bold">{loadFilter}</span>"</span>}
                    </p>
                </div>
            )}

            <div className="grid gap-6 md:grid-cols-2 xl:grid-cols-3">
                {paginatedTeachers.map(teacher => (
                    <TeacherAssignmentCard
                        key={teacher.id}
                        teacher={teacher}
                        subjects={subjects}
                        onToggle={(id) => toggleSubject(teacher, id)}
                    />
                ))}
            </div>

            {totalPages > 1 && (
                <div className="flex items-center justify-between border-t border-slate-100 pt-6">
                    <p className="text-sm font-medium text-slate-500">
                        Showing <span className="text-slate-900 font-bold">{(currentPage - 1) * itemsPerPage + 1}</span> to <span className="text-slate-900 font-bold">{Math.min(currentPage * itemsPerPage, filteredTeachers.length)}</span> of <span className="text-slate-900 font-bold">{filteredTeachers.length}</span> faculty
                    </p>
                    <div className="flex items-center gap-1">
                        <Button variant="outline" size="icon" disabled={currentPage === 1} onClick={() => setCurrentPage(c => c - 1)} className="w-9 h-9 border-slate-200 rounded-lg hover:bg-slate-50">
                            <ChevronLeft className="w-4 h-4" />
                        </Button>
                        <div className="flex items-center">
                            {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
                                <Button key={p} variant={currentPage === p ? "default" : "ghost"} size="sm" onClick={() => setCurrentPage(p)}
                                    className={cn("w-9 h-9 rounded-lg font-bold text-xs", currentPage === p ? "shadow-md shadow-primary/20" : "text-slate-500")}>
                                    {p}
                                </Button>
                            ))}
                        </div>
                        <Button variant="outline" size="icon" disabled={currentPage === totalPages} onClick={() => setCurrentPage(c => c + 1)} className="w-9 h-9 border-slate-200 rounded-lg hover:bg-slate-50">
                            <ChevronRight className="w-4 h-4" />
                        </Button>
                    </div>
                </div>
            )}
        </div>
    );
};

interface TeacherAssignmentCardProps {
    teacher: Teacher;
    subjects: Subject[];
    onToggle: (subjectId: string) => void;
}

const TeacherAssignmentCard = ({ teacher, subjects, onToggle }: TeacherAssignmentCardProps) => {
    const assignedSubjects = subjects.filter(s => teacher.subjectIds.includes(s.id ?? ''));
    const [manageSearch, setManageSearch] = useState('');

    const filteredManageSubjects = useMemo(() => {
        return subjects.filter(s =>
            s.name.toLowerCase().includes(manageSearch.toLowerCase())
        );
    }, [subjects, manageSearch]);

    return (
        <Card className="group border-none shadow-sm hover:shadow-xl hover:shadow-slate-200/50 transition-all duration-300 rounded-2xl overflow-hidden bg-white ring-1 ring-slate-100">
            <CardHeader className="p-6 pb-4 bg-slate-50/50 border-b border-slate-100">
                <div className="flex justify-between items-start">
                    <div className="space-y-1">
                        <CardTitle className="text-xl font-black text-slate-800 group-hover:text-primary transition-colors">
                            {teacher.fullName || teacher.employeeId}
                        </CardTitle>
                        <p className="text-xs font-bold text-slate-400 uppercase tracking-wider">
                            {teacher.employeeId} • {teacher.classIds.length} Classes • {teacher.subjectIds.length} Subjects
                        </p>
                    </div>
                    <div className="p-2 bg-white rounded-xl shadow-sm border border-slate-100">
                        <GraduationCap className="w-5 h-5 text-primary" />
                    </div>
                </div>
            </CardHeader>
            <CardContent className="p-6 space-y-6">
                <div className="space-y-4">
                    <div className="flex justify-between items-center">
                        <p className="text-xs font-black text-slate-500 uppercase tracking-widest">Active Assignments</p>
                        <span className="px-2 py-1 bg-indigo-50 text-indigo-700 text-[10px] font-black rounded-lg border border-indigo-100">
                            {assignedSubjects.length} SUBJECTS
                        </span>
                    </div>

                    {assignedSubjects.length > 0 ? (
                        <div className="flex flex-wrap gap-2">
                            {assignedSubjects.map(subject => (
                                <div
                                    key={subject.id}
                                    className="inline-flex items-center gap-1.5 pl-2.5 pr-1 py-1 bg-white border border-slate-200 rounded-lg shadow-sm group/tag hover:border-red-200 hover:bg-red-50 transition-all cursor-default"
                                >
                                    <span className="text-xs font-bold text-slate-700 group-hover/tag:text-red-700 transition-colors">{subject.name}</span>
                                    <button
                                        onClick={() => onToggle(subject.id ?? '')}
                                        className="p-1 rounded-md text-slate-300 hover:bg-red-100 hover:text-red-600 transition-all opacity-0 group-hover/tag:opacity-100"
                                    >
                                        <X className="w-3 h-3" />
                                    </button>
                                </div>
                            ))}
                        </div>
                    ) : (
                        <div className="py-8 text-center bg-slate-50/50 rounded-xl border border-dashed border-slate-200">
                            <BookOpen className="w-8 h-8 text-slate-300 mx-auto mb-2" />
                            <p className="text-xs font-bold text-slate-400 uppercase tracking-wider">No assignments yet</p>
                        </div>
                    )}
                </div>

                <Dialog>
                    <DialogTrigger asChild>
                        <Button className="w-full h-11 rounded-xl font-bold gap-2 shadow-lg shadow-primary/10 hover:shadow-primary/20">
                            <Plus className="w-4 h-4" /> Manage Assignments
                        </Button>
                    </DialogTrigger>
                    <DialogContent className="sm:max-w-2xl max-h-[85vh] flex flex-col p-0 overflow-hidden border-none rounded-3xl shadow-2xl">
                        <DialogHeader className="p-8 pb-6 bg-slate-50 border-b border-slate-100">
                            <div className="flex items-center gap-4">
                                <div className="p-3 bg-white rounded-2xl shadow-sm border border-slate-100">
                                    <SlidersHorizontal className="w-6 h-6 text-primary" />
                                </div>
                                <div className="space-y-1">
                                    <DialogTitle className="text-2xl font-black">Manage Assignments</DialogTitle>
                                    <p className="text-slate-500 font-medium">
                                        Assigning subjects to <span className="text-primary font-bold">{teacher.fullName || teacher.employeeId}</span>
                                    </p>
                                </div>
                            </div>
                        </DialogHeader>

                        <div className="p-8 pt-6 flex-1 overflow-y-auto space-y-8">
                            <div className="relative">
                                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
                                <Input
                                    placeholder="Search curriculum..."
                                    className="pl-12 h-14 bg-slate-50 border-none rounded-2xl text-base focus:ring-primary/20"
                                    value={manageSearch}
                                    onChange={(e) => setManageSearch(e.target.value)}
                                />
                            </div>

                            <div className="grid sm:grid-cols-2 gap-3">
                                {filteredManageSubjects.map(s => (
                                    <div
                                        key={s.id}
                                        onClick={() => onToggle(s.id ?? '')}
                                        className={cn(
                                            "flex items-center gap-3 p-4 rounded-2xl border transition-all cursor-pointer group/item",
                                            teacher.subjectIds.includes(s.id ?? '')
                                                ? "bg-primary/5 border-primary shadow-sm shadow-primary/5"
                                                : "bg-white border-slate-100 hover:border-primary/30 hover:bg-slate-50"
                                        )}
                                    >
                                        <div className={cn(
                                            "w-5 h-5 rounded-md border flex items-center justify-center transition-all",
                                            teacher.subjectIds.includes(s.id ?? '')
                                                ? "bg-primary border-primary"
                                                : "bg-white border-slate-300 group-hover/item:border-primary/50"
                                        )}>
                                            {teacher.subjectIds.includes(s.id ?? '') && <Check className="w-3.5 h-3.5 text-white stroke-[4]" />}
                                        </div>
                                        <p className={cn("text-sm font-bold", teacher.subjectIds.includes(s.id ?? '') ? "text-primary" : "text-slate-700")}>
                                            {s.name}
                                        </p>
                                    </div>
                                ))}
                                {filteredManageSubjects.length === 0 && (
                                    <div className="py-20 text-center col-span-2">
                                        <p className="text-slate-400 font-bold">No subjects match your search.</p>
                                    </div>
                                )}
                            </div>
                        </div>
                    </DialogContent>
                </Dialog>
            </CardContent>
        </Card>
    );
};