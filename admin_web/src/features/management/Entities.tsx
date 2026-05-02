import { Card, CardContent, Input } from '@/components/ui';
import { useData } from '@/context/DataContext';
import { Classroom } from '@/models/classroom';  
import { Notice } from '@/models/notice';         
import { Subject } from '@/models/subject';      
import { cn } from '@/lib/utils';
import { Activity, Award, Binary, Book, Compass, Info, Layout, Users } from 'lucide-react';
import { ManagementPage } from '../shared/ManagementPage';


// CLASSROOM MANAGEMENT

export const ClassroomManagement = () => {
    const { classrooms, addClassroom, updateClassroom, deleteClassroom } = useData();

    
    const activeRooms = classrooms.filter(c => c.isActive).length;
    const inactiveRooms = classrooms.filter(c => !c.isActive).length;
    const uniqueFaculties = new Set(classrooms.map(c => c.faculty)).size;

    return (
        <div className="space-y-8">
            {/* Classroom Summary Ribbon */}
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <Card className="border-none shadow-sm bg-blue-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-blue-100 rounded-lg">
                            <Layout className="w-5 h-5 text-blue-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-blue-600 uppercase tracking-wider">Total Rooms</p>
                            <p className="text-2xl font-black text-blue-900">{classrooms.length}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-emerald-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-emerald-100 rounded-lg">
                            <Activity className="w-5 h-5 text-emerald-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-emerald-600 uppercase tracking-wider">Active</p>
                            <p className="text-2xl font-black text-emerald-900">{activeRooms}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-orange-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-orange-100 rounded-lg">
                            <Users className="w-5 h-5 text-orange-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-orange-600 uppercase tracking-wider">Inactive</p>
                            <p className="text-2xl font-black text-orange-900">{inactiveRooms}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-red-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-red-100 rounded-lg">
                            <Info className="w-5 h-5 text-red-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-red-600 uppercase tracking-wider">Faculties</p>
                            <p className="text-2xl font-black text-red-900">{uniqueFaculties}</p>
                        </div>
                    </CardContent>
                </Card>
            </div>

            <ManagementPage<Classroom>
                title="Classrooms"
                data={classrooms}
                columns={[
                    { key: 'name', label: 'Name' },
                    { key: 'faculty', label: 'Faculty' },
                    { key: 'startYear', label: 'Start Year' },
                    { key: 'endYear', label: 'End Year' },
                    {
                        key: 'isActive',
                        label: 'Status',
                        render: (val) => (
                            <span className={cn(
                                "inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-black uppercase tracking-wider border",
                                val === true && "bg-emerald-50 text-emerald-700 border-emerald-200",
                                val === false && "bg-red-50 text-red-700 border-red-200",
                            )}>
                                <span className={cn(
                                    "w-1 h-1 rounded-full mr-1.5",
                                    val === true && "bg-emerald-500",
                                    val === false && "bg-red-500",
                                )} />
                                {val ? 'Active' : 'Inactive'}
                            </span>
                        )
                    },
                ]}
                filters={[
                    {
                        key: 'isActive',
                        label: 'Status',
                        options: [
                            { label: 'Active', value: 'true' },
                            { label: 'Inactive', value: 'false' },
                        ]
                    }
                ]}
                onSave={async (item) => {
                    if (item.id) {
                        await updateClassroom(
                            item.id,
                            item.name,
                            item.faculty,
                            item.startYear,
                            item.endYear,
                            item.isActive,
                            item.createdAt
                        );
                    } else {
                        await addClassroom(
                            item.name,
                            item.faculty,
                            item.startYear,
                            item.endYear,
                            item.isActive ?? true
                        );
                    }
                }}
                onDelete={async (id) => await deleteClassroom(id)}
                emptyEntity={{
                    id: null,
                    name: '',
                    faculty: '',
                    startYear: new Date().getFullYear(),
                    endYear: new Date().getFullYear() + 1,
                    isActive: true,
                    createdAt: new Date(),
                }}
                renderForm={(data, onChange) => (
                    <div className="space-y-6">
                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Class Name</label>
                                <Input
                                    value={data.name || ''}
                                    onChange={(e) => onChange('name', e.target.value)}
                                    placeholder="e.g. BCA 1st Year"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Faculty</label>
                                <Input
                                    value={data.faculty || ''}
                                    onChange={(e) => onChange('faculty', e.target.value)}
                                    placeholder="e.g. Science"
                                />
                            </div>
                        </div>

                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Start Year</label>
                                <Input
                                    type="number"
                                    value={data.startYear || ''}
                                    onChange={(e) => onChange('startYear', parseInt(e.target.value))}
                                    placeholder="e.g. 2024"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">End Year</label>
                                <Input
                                    type="number"
                                    value={data.endYear || ''}
                                    onChange={(e) => onChange('endYear', parseInt(e.target.value))}
                                    placeholder="e.g. 2025"
                                />
                            </div>
                        </div>

                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Status</label>
                                <select
                                    className="flex h-10 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                    value={data.isActive ? 'true' : 'false'}
                                    onChange={(e) => onChange('isActive', e.target.value === 'true')}
                                >
                                    <option value="true">Active</option>
                                    <option value="false">Inactive</option>
                                </select>
                            </div>
                        </div>
                    </div>
                )}
            />
        </div>
    );
};


// SUBJECT MANAGEMENT

export const SubjectManagement = () => {
    const { subjects, addSubject, updateSubject, deleteSubject, classrooms, teachers } = useData();

   
    const uniqueClasses = new Set(subjects.map(s => s.classId)).size;
    const uniqueTeachers = new Set(subjects.map(s => s.teacherId)).size;

    return (
        <div className="space-y-8">
            {/* Subject Summary Ribbon  */}
            <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
                <Card className="border-none shadow-sm bg-purple-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-purple-100 rounded-lg">
                            <Book className="w-5 h-5 text-purple-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-purple-600 uppercase tracking-wider">Total Subjects</p>
                            <p className="text-2xl font-black text-purple-900">{subjects.length}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-indigo-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-indigo-100 rounded-lg">
                            <Award className="w-5 h-5 text-indigo-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-indigo-600 uppercase tracking-wider">Classes</p>
                            <p className="text-2xl font-black text-indigo-900">{uniqueClasses}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-blue-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-blue-100 rounded-lg">
                            <Binary className="w-5 h-5 text-blue-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-blue-600 uppercase tracking-wider">Teachers</p>
                            <p className="text-2xl font-black text-blue-900">{uniqueTeachers}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-emerald-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-emerald-100 rounded-lg">
                            <Compass className="w-5 h-5 text-emerald-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-emerald-600 uppercase tracking-wider">Total Classrooms</p>
                            <p className="text-2xl font-black text-emerald-900">{classrooms.length}</p>
                        </div>
                    </CardContent>
                </Card>
            </div>

            <ManagementPage<Subject>
                title="Subjects"
                data={subjects}
                columns={[
                    { key: 'name', label: 'Name' },
                    {
                        key: 'classId',
                        label: 'Class',
                        render: (val) => (
                            <span className="text-xs font-semibold px-2 py-1 rounded-md bg-slate-100 text-slate-600 border border-slate-200 uppercase tracking-tighter">
                                {classrooms.find(c => c.id === val)?.name ?? val}
                            </span>
                        )
                    },
                    {
                        key: 'teacherId',
                        label: 'Teacher',
                        render: (val) => (
                            <span className={cn(
                                "text-[10px] font-black px-2 py-0.5 rounded-full uppercase tracking-wider border",
                                "bg-blue-50 text-blue-700 border-blue-200"
                            )}>
                                {teachers.find(t => t.id === val)?.employeeId ?? val}
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
                    if (item.id) {
                        await updateSubject(
                            item.id,
                            item.name,
                            item.classId,
                            item.teacherId
                        );
                    } else {
                        await addSubject(
                            item.name,
                            item.classId,
                            item.teacherId
                        );
                    }
                }}
                onDelete={async (id) => await deleteSubject(id)}
                emptyEntity={{
                    id: null,
                    name: '',
                    classId: classrooms[0]?.id ?? '',
                    teacherId: teachers[0]?.id ?? '',
                }}
                renderForm={(data, onChange) => (
                    <div className="space-y-6">
                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Subject Name</label>
                                <Input
                                    value={data.name || ''}
                                    onChange={(e) => onChange('name', e.target.value)}
                                    placeholder="e.g. Mathematics"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Class</label>
                                <select
                                    className="flex h-10 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                    value={data.classId || ''}
                                    onChange={(e) => onChange('classId', e.target.value)}
                                >
                                    {classrooms.map(c => (
                                        <option key={c.id} value={c.id ?? ''}>{c.name}</option>
                                    ))}
                                </select>
                            </div>
                        </div>

                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Teacher</label>
                                <select
                                    className="flex h-10 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                    value={data.teacherId || ''}
                                    onChange={(e) => onChange('teacherId', e.target.value)}
                                >
                                    {teachers.map(t => (
                                        <option key={t.id} value={t.id ?? ''}>{t.employeeId}</option>
                                    ))}
                                </select>
                            </div>
                        </div>
                    </div>
                )}
            />
        </div>
    );
};

// NOTICE MANAGEMENT

export const NoticeManagement = () => {
    const { notices, addNotice, updateNotice, deleteNotice } = useData();

    return (
        <ManagementPage<Notice>
            title="Notices"
            data={notices}
            columns={[
                { key: 'title', label: 'Title' },
                { key: 'description', label: 'Description' },
                {
                    key: 'priority',
                    label: 'Priority',
                    render: (val) => (
                        <span className={cn(
                            "text-[10px] font-black px-2 py-0.5 rounded-full uppercase tracking-wider border",
                            val === 'urgent' && "bg-blue-50 text-blue-700 border-blue-200",
                            val === 'important' && "bg-orange-50 text-orange-700 border-orange-200",
                            val === 'info' && "bg-emerald-50 text-emerald-700 border-emerald-200",
                        )}>
                            {val}
                        </span>
                    )
                },
                {
                    key: 'publishedAt',
                    label: 'Published At',
                    render: (val) => (
                        <span>{val instanceof Date ? val.toLocaleString() : val}</span>
                    )
                },
                {
                    key: 'scheduledAt',
                    label: 'Scheduled At',
                    render: (val) => (
                        <span>{val instanceof Date ? val.toLocaleString() : 'Not Scheduled'}</span>
                    )
                },
            ]}
            onSave={async (item) => {
                if (item.id) {
                    await updateNotice(
                        item.id,
                        item.title,
                        item.description,
                        item.scheduledAt ?? null,
                        item.priority,
                        item.publishedAt
                    );
                } else {
                    await addNotice(
                        item.title,
                        item.description,
                        item.scheduledAt ?? null,
                        item.priority
                    );
                }
            }}
            onDelete={async (id) => await deleteNotice(id)}
            emptyEntity={{
                id: null,
                title: '',
                description: '',
                priority: 'info',
                publishedAt: new Date(),
                scheduledAt: null,
            }}
            renderForm={(data, onChange) => (
                <div className="space-y-4">
                    <div className="grid gap-4 sm:grid-cols-2">
                        <div className="space-y-2">
                            <label className="text-sm font-medium">Title</label>
                            <Input
                                value={data.title || ''}
                                onChange={(e) => onChange('title', e.target.value)}
                                placeholder="Notice title"
                            />
                        </div>
                        <div className="space-y-2">
                            <label className="text-sm font-medium">Priority</label>
                            <select
                                className="flex h-10 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                value={data.priority || 'info'}
                                onChange={(e) => onChange('priority', e.target.value)}
                            >
                                <option value="info">Info</option>
                                <option value="important">Important</option>
                                <option value="urgent">Urgent</option>
                            </select>
                        </div>
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Description</label>
                        <textarea
                            className="flex min-h-[100px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                            value={data.description || ''}
                            onChange={(e) => onChange('description', e.target.value)}
                            placeholder="Notice description..."
                        />
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Schedule At (optional)</label>
                        <Input
                            type="datetime-local"
                            value={data.scheduledAt instanceof Date
                                ? data.scheduledAt.toISOString().slice(0, 16)
                                : ''}
                            onChange={(e) => onChange('scheduledAt',
                                e.target.value ? new Date(e.target.value) : null
                            )}
                        />
                    </div>
                </div>
            )}
        />
    );
};