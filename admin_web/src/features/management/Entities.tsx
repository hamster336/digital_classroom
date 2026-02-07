import { Card, CardContent, Input } from '@/components/ui';
import { useData } from '@/context/DataContext';
import { Classroom, Notice, Subject } from '@/lib/dummy-data';
import { cn } from '@/lib/utils';
import { Activity, Award, Binary, Book, Compass, Info, Layout, Users } from 'lucide-react';
import { ManagementPage } from '../shared/ManagementPage';

export const ClassroomManagement = () => {
    const { classrooms, addClassroom, updateClassroom, deleteClassroom } = useData();

    // Summary Statistics
    const totalCapacity = classrooms.reduce((acc, c) => acc + (c.capacity || 0), 0);
    const availableRooms = classrooms.filter(c => c.status === 'Available').length;
    const maintenanceRooms = classrooms.filter(c => c.status === 'Maintenance').length;

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
                            <p className="text-xs font-bold text-emerald-600 uppercase tracking-wider">Available</p>
                            <p className="text-2xl font-black text-emerald-900">{availableRooms}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-orange-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-orange-100 rounded-lg">
                            <Users className="w-5 h-5 text-orange-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-orange-600 uppercase tracking-wider">Capacity</p>
                            <p className="text-2xl font-black text-orange-900">{totalCapacity}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-red-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-red-100 rounded-lg">
                            <Info className="w-5 h-5 text-red-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-red-600 uppercase tracking-wider">Maintenance</p>
                            <p className="text-2xl font-black text-red-900">{maintenanceRooms}</p>
                        </div>
                    </CardContent>
                </Card>
            </div>

            <ManagementPage<Classroom>
                title="Classrooms"
                data={classrooms}
                columns={[
                    { key: 'name', label: 'Name' },
                    { key: 'section', label: 'Section' },
                    { key: 'roomNumber', label: 'Room' },
                    {
                        key: 'type',
                        label: 'Type',
                        render: (val) => (
                            <span className="text-xs font-semibold px-2 py-1 rounded-md bg-slate-100 text-slate-600 border border-slate-200 uppercase tracking-tighter">
                                {val}
                            </span>
                        )
                    },
                    {
                        key: 'capacity',
                        label: 'Capacity',
                        render: (val) => (
                            <div className="flex items-center gap-2">
                                <span className="font-bold tabular-nums">{val}</span>
                                <div className="w-12 h-1.5 bg-slate-100 rounded-full overflow-hidden hidden sm:block">
                                    <div
                                        className={cn(
                                            "h-full rounded-full transition-all",
                                            val > 40 ? "bg-orange-500" : "bg-primary"
                                        )}
                                        style={{ width: `${Math.min((val / 50) * 100, 100)}%` }}
                                    />
                                </div>
                            </div>
                        )
                    },
                    {
                        key: 'status',
                        label: 'Status',
                        render: (val) => (
                            <span className={cn(
                                "inline-flex items-center px-2 py-0.5 rounded-full text-[10px] font-black uppercase tracking-wider border",
                                val === 'Available' && "bg-emerald-50 text-emerald-700 border-emerald-200",
                                val === 'Maintenance' && "bg-red-50 text-red-700 border-red-200",
                                val === 'Full' && "bg-orange-50 text-orange-700 border-orange-200"
                            )}>
                                <span className={cn(
                                    "w-1 h-1 rounded-full mr-1.5",
                                    val === 'Available' && "bg-emerald-500",
                                    val === 'Maintenance' && "bg-red-500",
                                    val === 'Full' && "bg-orange-500"
                                )} />
                                {val}
                            </span>
                        )
                    },
                ]}
                filters={[
                    {
                        key: 'type',
                        label: 'Type',
                        options: [
                            { label: 'Theory', value: 'Theory' },
                            { label: 'Lab', value: 'Lab' },
                            { label: 'Seminar', value: 'Seminar' },
                        ]
                    },
                    {
                        key: 'status',
                        label: 'Status',
                        options: [
                            { label: 'Available', value: 'Available' },
                            { label: 'Full', value: 'Full' },
                            { label: 'Maintenance', value: 'Maintenance' },
                        ]
                    }
                ]}
                onSave={(item) => {
                    const existing = classrooms.find(c => c.id === item.id);
                    if (existing) updateClassroom(item);
                    else addClassroom(item);
                }}
                onDelete={deleteClassroom}
                emptyEntity={{ name: '', section: '', roomNumber: '', capacity: 30, type: 'Theory', status: 'Available' }}
                renderForm={(data, onChange) => (
                    <div className="space-y-6">
                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Class Name</label>
                                <Input
                                    value={data.name || ''}
                                    onChange={(e) => onChange('name', e.target.value)}
                                    placeholder="e.g. Class 10"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Section</label>
                                <Input
                                    value={data.section || ''}
                                    onChange={(e) => onChange('section', e.target.value)}
                                    placeholder="e.g. A"
                                />
                            </div>
                        </div>

                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Room Number</label>
                                <Input
                                    value={data.roomNumber || ''}
                                    onChange={(e) => onChange('roomNumber', e.target.value)}
                                    placeholder="e.g. 101"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Capacity</label>
                                <Input
                                    type="number"
                                    value={data.capacity || ''}
                                    onChange={(e) => onChange('capacity', parseInt(e.target.value))}
                                    placeholder="Max students"
                                />
                            </div>
                        </div>

                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Type</label>
                                <select
                                    className="flex h-10 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                    value={data.type || 'Theory'}
                                    onChange={(e) => onChange('type', e.target.value)}
                                >
                                    <option value="Theory">Theory</option>
                                    <option value="Lab">Lab</option>
                                    <option value="Seminar">Seminar</option>
                                </select>
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Status</label>
                                <select
                                    className="flex h-10 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                    value={data.status || 'Available'}
                                    onChange={(e) => onChange('status', e.target.value)}
                                >
                                    <option value="Available">Available</option>
                                    <option value="Maintenance">Maintenance</option>
                                    <option value="Full">Full</option>
                                </select>
                            </div>
                        </div>
                    </div>
                )}
            />
        </div>
    );
};

export const SubjectManagement = () => {
    const { subjects, addSubject, updateSubject, deleteSubject } = useData();

    // Summary Statistics
    const totalCredits = subjects.reduce((acc, s) => acc + (s.credits || 0), 0);
    const techSubjects = subjects.filter(s => s.department === 'Technology').length;
    const scienceSubjects = subjects.filter(s => s.department === 'Science').length;

    return (
        <div className="space-y-8">
            {/* Subject Summary Ribbon */}
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
                            <p className="text-xs font-bold text-indigo-600 uppercase tracking-wider">Total Credits</p>
                            <p className="text-2xl font-black text-indigo-900">{totalCredits}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-blue-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-blue-100 rounded-lg">
                            <Binary className="w-5 h-5 text-blue-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-blue-600 uppercase tracking-wider">Technology</p>
                            <p className="text-2xl font-black text-blue-900">{techSubjects}</p>
                        </div>
                    </CardContent>
                </Card>
                <Card className="border-none shadow-sm bg-emerald-50/50">
                    <CardContent className="p-4 flex items-center gap-4">
                        <div className="p-2 bg-emerald-100 rounded-lg">
                            <Compass className="w-5 h-5 text-emerald-600" />
                        </div>
                        <div>
                            <p className="text-xs font-bold text-emerald-600 uppercase tracking-wider">Science</p>
                            <p className="text-2xl font-black text-emerald-900">{scienceSubjects}</p>
                        </div>
                    </CardContent>
                </Card>
            </div>

            <ManagementPage<Subject>
                title="Subjects"
                data={subjects}
                columns={[
                    { key: 'name', label: 'Name' },
                    { key: 'code', label: 'Code' },
                    {
                        key: 'department',
                        label: 'Department',
                        render: (val) => (
                            <span className={cn(
                                "text-[10px] font-black px-2 py-0.5 rounded-full uppercase tracking-wider border",
                                val === 'Technology' && "bg-blue-50 text-blue-700 border-blue-200",
                                val === 'Science' && "bg-emerald-50 text-emerald-700 border-emerald-200",
                                val === 'Commerce' && "bg-orange-50 text-orange-700 border-orange-200",
                                val === 'Arts' && "bg-purple-50 text-purple-700 border-purple-200"
                            )}>
                                {val}
                            </span>
                        )
                    },
                    {
                        key: 'credits',
                        label: 'Credits',
                        render: (val) => (
                            <div className="flex items-center gap-1.5">
                                <span className="font-bold tabular-nums text-slate-700">{val}</span>
                                <div className="flex gap-0.5">
                                    {[...Array(4)].map((_, i) => (
                                        <div
                                            key={i}
                                            className={cn(
                                                "w-1.5 h-1.5 rounded-full",
                                                i < val ? "bg-indigo-500" : "bg-slate-200"
                                            )}
                                        />
                                    ))}
                                </div>
                            </div>
                        )
                    },
                ]}
                filters={[
                    {
                        key: 'department',
                        label: 'Department',
                        options: [
                            { label: 'Technology', value: 'Technology' },
                            { label: 'Science', value: 'Science' },
                            { label: 'Arts', value: 'Arts' },
                            { label: 'Commerce', value: 'Commerce' },
                        ]
                    }
                ]}
                onSave={(item) => {
                    const existing = subjects.find(s => s.id === item.id);
                    if (existing) updateSubject(item);
                    else addSubject(item);
                }}
                onDelete={deleteSubject}
                emptyEntity={{ name: '', code: '', department: 'Technology', credits: 3, description: '' }}
                renderForm={(data, onChange) => (
                    <div className="space-y-6">
                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Subject Name</label>
                                <Input
                                    value={data.name || ''}
                                    onChange={(e) => onChange('name', e.target.value)}
                                    placeholder="e.g. DBMS"
                                />
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Subject Code</label>
                                <Input
                                    value={data.code || ''}
                                    onChange={(e) => onChange('code', e.target.value)}
                                    placeholder="e.g. CS101"
                                />
                            </div>
                        </div>

                        <div className="grid gap-4 sm:grid-cols-2">
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Department</label>
                                <select
                                    className="flex h-10 w-full rounded-md border border-input bg-transparent px-3 py-1 text-sm shadow-sm transition-colors focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                    value={data.department || 'Technology'}
                                    onChange={(e) => onChange('department', e.target.value)}
                                >
                                    <option value="Technology">Technology</option>
                                    <option value="Science">Science</option>
                                    <option value="Commerce">Commerce</option>
                                    <option value="Arts">Arts</option>
                                </select>
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-bold text-slate-700">Credits</label>
                                <Input
                                    type="number"
                                    value={data.credits || ''}
                                    onChange={(e) => onChange('credits', parseInt(e.target.value))}
                                    placeholder="Credits (1-6)"
                                />
                            </div>
                        </div>

                        <div className="space-y-2">
                            <label className="text-sm font-bold text-slate-700">Description</label>
                            <textarea
                                className="flex min-h-[100px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                                value={data.description || ''}
                                onChange={(e) => onChange('description', e.target.value)}
                                placeholder="Short description of the subject..."
                            />
                        </div>
                    </div>
                )}
            />
        </div>
    );
};

export const NoticeManagement = () => {
    const { notices, addNotice, updateNotice, deleteNotice } = useData();
    return (
        <ManagementPage<Notice>
            title="Notices"
            data={notices}
            columns={[
                { key: 'title', label: 'Title' },
                { key: 'date', label: 'Date' },
            ]}
            onSave={(item) => {
                const existing = notices.find(n => n.id === item.id);
                if (existing) updateNotice(item);
                else addNotice(item);
            }}
            onDelete={deleteNotice}
            emptyEntity={{ title: '', content: '', date: new Date().toISOString().split('T')[0] }}
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
                            <label className="text-sm font-medium">Date</label>
                            <Input
                                type="date"
                                value={data.date || ''}
                                onChange={(e) => onChange('date', e.target.value)}
                            />
                        </div>
                    </div>
                    <div className="space-y-2">
                        <label className="text-sm font-medium">Content</label>
                        <textarea
                            className="flex min-h-[100px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring"
                            value={data.content || ''}
                            onChange={(e) => onChange('content', e.target.value)}
                            placeholder="Notice content..."
                        />
                    </div>
                </div>
            )}
        />
    );
};
