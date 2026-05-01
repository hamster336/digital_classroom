import { Button, Card, CardContent, CardHeader, CardTitle, Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, Input } from '@/components/ui';
import { useData } from '@/context/DataContext';
import { Student } from '@/models/student';   
import { Subject } from '@/models/subject';   
import { Teacher } from '@/models/teacher';    
import { cn } from '@/lib/utils';
import { BookOpen, Check, ChevronLeft, ChevronRight, GraduationCap, Plus, Search, SlidersHorizontal, UserCheck, X } from 'lucide-react';
import { useEffect, useMemo, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { ManagementPage } from '../shared/ManagementPage';

export const TeacherManagement = () => {
    const { teachers, addTeacher, updateTeacher, deleteTeacher } = useData();
    return (
        <ManagementPage<Teacher>
            title="Teachers"
            data={teachers}
            columns={[
                { key: 'employeeId', label: 'Employee ID' },  
                {
                    key: 'subjectIds',
                    label: 'Subjects',
                    render: (val: string[]) => (
                        <span>{val?.length > 0 ? `${val.length} subjects` : 'None'}</span>
                    )
                },
                {
                    key: 'classIds',
                    label: 'Classes',
                    render: (val: string[]) => (
                        <span>{val?.length > 0 ? `${val.length} classes` : 'None'}</span>
                    )
                },
                {
                    key: 'lastCheckedNotices',
                    label: 'Last Active',
                    render: (val) => (
                        <span>{val instanceof Date ? val.toLocaleString() : 'Never'}</span>
                    )
                },
            ]}
            onSave={async (item) => {
                const existing = teachers.find(t => t.id === item.id);
                if (existing) await updateTeacher(
                    item.id!,
                    item.employeeId,
                    item.subjectIds ?? [],
                    item.classIds ?? [],
                    item.avatarPath ?? null,
                    item.lastCheckedNotices ?? null
                );
                else await addTeacher(
                    item.employeeId,
                    item.subjectIds ?? [],
                    item.classIds ?? [],
                    item.avatarPath ?? null
                );
            }}
            onDelete={async (id) => await deleteTeacher(id)}
            emptyEntity={{
                id: null,
                employeeId: '',
                subjectIds: [],
                classIds: [],
                avatarPath: null,
                lastCheckedNotices: null,
            }}
            renderForm={(data, onChange) => (
                <div className="grid gap-4 sm:grid-cols-2">
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Employee ID</label>
                        <Input
                            value={data.employeeId || ''}
                            onChange={(e) => onChange('employeeId', e.target.value)}
                            placeholder="e.g. EMP001"
                        />
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Avatar URL</label>
                        <Input
                            value={data.avatarPath || ''}
                            onChange={(e) => onChange('avatarPath', e.target.value || null)}
                            placeholder="https://..."
                        />
                    </div>
                </div>
            )}
        />
    );
};

export const StudentManagement = () => {
    const { students, addStudent, updateStudent, deleteStudent, classrooms } = useData();
    return (
        <ManagementPage<Student>
            title="Students"
            data={students}
            columns={[
                { key: 'rollNo', label: 'Roll No' },  
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
                        <span>{val?.length > 0 ? `${val.length} subjects` : 'None'}</span>
                    )
                },
                {
                    key: 'lastCheckedNotices',
                    label: 'Last Active',
                    render: (val) => (
                        <span>{val instanceof Date ? val.toLocaleString() : 'Never'}</span>
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
                const existing = students.find(s => s.id === item.id);
                if (existing) await updateStudent(
                    item.id!,
                    item.rollNo,
                    item.subjectIds ?? [],
                    item.avatarUrl ?? null,
                    item.classId,
                    item.lastCheckedNotices ?? null
                );
                else await addStudent(
                    item.rollNo,
                    item.subjectIds ?? [],
                    item.avatarUrl ?? null,
                    item.classId
                );
            }}
            onDelete={async (id) => await deleteStudent(id)}
            emptyEntity={{
                id: null,
                rollNo: 0,
                classId: classrooms[0]?.id ?? '',
                subjectIds: [],
                avatarUrl: null,
                lastCheckedNotices: null,
            }}
            renderForm={(data, onChange) => (
                <div className="grid gap-4 sm:grid-cols-3">
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Roll No</label>
                        <Input
                            type="number"
                            value={data.rollNo || ''}
                            onChange={(e) => onChange('rollNo', parseInt(e.target.value))}
                            placeholder="e.g. 1"
                        />
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Avatar URL</label>
                        <Input
                            value={data.avatarUrl || ''}
                            onChange={(e) => onChange('avatarUrl', e.target.value || null)}
                            placeholder="https://..."
                        />
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Class</label>
                        <select
                            className="flex h-9 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                            value={data.classId || ''}
                            onChange={(e) => onChange('classId', e.target.value)}
                        >
                            {classrooms.map(c => (
                                <option key={c.id} value={c.id ?? ''}>{c.name}</option>
                            ))}
                        </select>
                    </div>
                </div>
            )}
        />
    );
};

export const SubjectAssignment = () => {
    const { teachers, subjects, updateTeacher } = useData();
    const [searchParams, setSearchParams] = useSearchParams();

    // URL Params Mapping
    const searchTerm = searchParams.get('q') || '';
    const loadFilter = searchParams.get('load') || 'all';

    const [currentPage, setCurrentPage] = useState(1);
    const itemsPerPage = 6;

    // Helpers to update URL
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

    // Filter teachers
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

    // Reset pagination
    useEffect(() => {
        setCurrentPage(1);
    }, [searchTerm, loadFilter]);

    const toggleSubject = async (teacher: Teacher, subjectId: string) => {
        const hasSubject = teacher.subjectIds.includes(subjectId);  
        await updateTeacher(
            teacher.id!,
            teacher.employeeId,
            hasSubject
                ? teacher.subjectIds.filter(id => id !== subjectId)
                : [...teacher.subjectIds, subjectId],
            teacher.classIds,
            teacher.avatarPath,
            teacher.lastCheckedNotices
        );
    };

    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-500">
            {/* Header with Stats */}
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

            {/* Filter Bar */}
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

            {/* Teacher Grid */}
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

            {/* Pagination */}
            {totalPages > 1 && (
                <div className="flex items-center justify-between border-t border-slate-100 pt-6">
                    <p className="text-sm font-medium text-slate-500">
                        Showing <span className="text-slate-900 font-bold">{(currentPage - 1) * itemsPerPage + 1}</span> to <span className="text-slate-900 font-bold">{Math.min(currentPage * itemsPerPage, filteredTeachers.length)}</span> of <span className="text-slate-900 font-bold">{filteredTeachers.length}</span> faculty
                    </p>
                    <div className="flex items-center gap-1">
                        <Button
                            variant="outline"
                            size="icon"
                            disabled={currentPage === 1}
                            onClick={() => setCurrentPage(c => c - 1)}
                            className="w-9 h-9 border-slate-200 rounded-lg hover:bg-slate-50"
                        >
                            <ChevronLeft className="w-4 h-4" />
                        </Button>
                        <div className="flex items-center">
                            {Array.from({ length: totalPages }, (_, i) => i + 1).map(p => (
                                <Button
                                    key={p}
                                    variant={currentPage === p ? "default" : "ghost"}
                                    size="sm"
                                    onClick={() => setCurrentPage(p)}
                                    className={cn(
                                        "w-9 h-9 rounded-lg font-bold text-xs",
                                        currentPage === p ? "shadow-md shadow-primary/20" : "text-slate-500"
                                    )}
                                >
                                    {p}
                                </Button>
                            ))}
                        </div>
                        <Button
                            variant="outline"
                            size="icon"
                            disabled={currentPage === totalPages}
                            onClick={() => setCurrentPage(c => c + 1)}
                            className="w-9 h-9 border-slate-200 rounded-lg hover:bg-slate-50"
                        >
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
            //  removed s.code and s.department — not in real Subject model
        );
    }, [subjects, manageSearch]);

    // Group by department — removed
    // Using flat list instead

    return (
        <Card className="group border-none shadow-sm hover:shadow-xl hover:shadow-slate-200/50 transition-all duration-300 rounded-2xl overflow-hidden bg-white ring-1 ring-slate-100">
            <CardHeader className="p-6 pb-4 bg-slate-50/50 border-b border-slate-100">
                <div className="flex justify-between items-start">
                    <div className="space-y-1">
                        <CardTitle className="text-xl font-black text-slate-800 group-hover:text-primary transition-colors">{teacher.employeeId}</CardTitle> {/* ✅ real field */}
                        <p className="text-xs font-bold text-slate-400 uppercase tracking-wider">
                            {teacher.classIds.length} Classes • {teacher.subjectIds.length} Subjects
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
                                        onClick={() => onToggle(subject.id ?? '')} //  null-safe
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
                                    <p className="text-slate-500 font-medium">Assigning subjects to <span className="text-primary font-bold">{teacher.employeeId}</span></p>
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

                            <div className="space-y-8">
                                <div className="grid sm:grid-cols-2 gap-3">
                                    {filteredManageSubjects.map(s => (
                                        <div
                                            key={s.id}
                                            onClick={() => onToggle(s.id ?? '')} //  null-safe
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
                                            <div className="space-y-0.5">
                                                <p className={cn("text-sm font-bold", teacher.subjectIds.includes(s.id ?? '') ? "text-primary" : "text-slate-700")}>{s.name}</p>
                                                {    }
                                            </div>
                                        </div>
                                    ))}
                                </div>
                                {filteredManageSubjects.length === 0 && (
                                    <div className="py-20 text-center">
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