import { Button, Card, CardContent, CardHeader, CardTitle } from '@/components/ui';
import { useData } from '@/context/DataContext';
import { ArrowRight, Bell, BookOpen, Plus, School, UserSquare2, Users } from 'lucide-react';
import { Link } from 'react-router-dom';

export const Dashboard = () => {
    const { classrooms, subjects, teachers, students, notices } = useData();
    const stats = [
        { label: 'Total Classrooms', value: classrooms.length, icon: School, color: 'text-blue-600', bg: 'bg-blue-100', link: '/classrooms', description: 'Active teaching spaces' },
        { label: 'Total Subjects', value: subjects.length, icon: BookOpen, color: 'text-green-600', bg: 'bg-green-100', link: '/subjects', description: 'Educational modules' },
        { label: 'Total Teachers', value: teachers.length, icon: UserSquare2, color: 'text-purple-600', bg: 'bg-purple-100', link: '/teachers', description: 'Academic staff' },
        { label: 'Total Students', value: students.length, icon: Users, color: 'text-orange-600', bg: 'bg-orange-100', link: '/students', description: 'Enrolled learners' },
        { label: 'Recent Notices', value: notices.length, icon: Bell, color: 'text-red-600', bg: 'bg-red-100', link: '/notices', description: 'Latest announcements' },
    ];

    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-4 duration-700">
            <div className="flex flex-col gap-2">
                <h1 className="text-3xl font-bold tracking-tight">Institutional Overview</h1>
                <p className="text-muted-foreground text-lg">
                    Real-time monitoring of your school's activities and performance.
                </p>
            </div>

            <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5">
                {stats.map((stat) => (
                    <Link key={stat.label} to={stat.link} className="block group">
                        <Card className="h-full border-none shadow-md shadow-slate-200/50 transition-all duration-300 hover:shadow-xl hover:shadow-slate-300/60 hover:-translate-y-1 active:scale-[0.98] overflow-hidden relative">
                            <div className={`absolute top-0 left-0 w-1 h-full ${stat.color.replace('text', 'bg')} opacity-0 group-hover:opacity-100 transition-opacity`} />
                            <CardHeader className="flex flex-row items-center justify-between space-y-0 pb-2">
                                <CardTitle className="text-xs font-bold uppercase tracking-wider text-slate-500">
                                    {stat.label}
                                </CardTitle>
                                <div className={`${stat.bg} p-2 rounded-xl transition-colors group-hover:bg-white group-hover:shadow-sm`}>
                                    <stat.icon className={`h-4 w-4 ${stat.color}`} />
                                </div>
                            </CardHeader>
                            <CardContent className="pt-2">
                                <div className="text-3xl font-black tracking-tight">{stat.value}</div>
                                <p className="text-[11px] text-muted-foreground mt-1 font-medium">{stat.description}</p>
                                <div className="mt-4 flex items-center text-[10px] font-bold text-primary opacity-0 group-hover:opacity-100 transition-all translate-x-[-10px] group-hover:translate-x-0">
                                    VIEW DETAILS <ArrowRight className="ml-1 w-3 h-3" />
                                </div>
                            </CardContent>
                        </Card>
                    </Link>
                ))}
            </div>

            <div className="grid gap-6 md:grid-cols-2">
                <Card className="border-none shadow-xl shadow-slate-200/40 relative overflow-hidden bg-gradient-to-br from-primary/5 to-transparent">
                    <CardHeader className="pb-4">
                        <CardTitle className="text-xl">Quick Actions</CardTitle>
                    </CardHeader>
                    <CardContent className="grid grid-cols-2 gap-3 pb-8">
                        <Button asChild variant="outline" className="justify-start h-12 border-primary/20 hover:bg-primary/5 hover:text-primary transition-all">
                            <Link to="/students">
                                <Plus className="mr-2 h-4 w-4" /> Add Student
                            </Link>
                        </Button>
                        <Button asChild variant="outline" className="justify-start h-12 border-primary/20 hover:bg-primary/5 hover:text-primary transition-all">
                            <Link to="/notices">
                                <Plus className="mr-2 h-4 w-4" /> Create Notice
                            </Link>
                        </Button>
                        <Button asChild variant="outline" className="justify-start h-12 border-primary/20 hover:bg-primary/5 hover:text-primary transition-all">
                            <Link to="/teachers">
                                <Plus className="mr-2 h-4 w-4" /> Invite Teacher
                            </Link>
                        </Button>
                        <Button asChild variant="outline" className="justify-start h-12 border-primary/20 hover:bg-primary/5 hover:text-primary transition-all">
                            <Link to="/assignments">
                                <Plus className="mr-2 h-4 w-4" /> Assign Subject
                            </Link>
                        </Button>
                    </CardContent>
                </Card>

                <Card className="border-none shadow-md shadow-slate-200/30">
                    <CardHeader>
                        <CardTitle className="text-xl">Welcome to Academia</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <p className="text-muted-foreground leading-relaxed">
                            Manage your school efficiently with our all-in-one management system.
                            Use the sidebar to navigate through classrooms, subjects, teachers, and students.
                            Click on any statistic card above to jump directly to its management page.
                        </p>
                        <div className="mt-6 flex gap-4">
                            <div className="flex -space-x-2">
                                {[1, 2, 3, 4].map((i) => (
                                    <div key={i} className="w-8 h-8 rounded-full border-2 border-white bg-slate-100 flex items-center justify-center text-[10px] font-bold">
                                        JD
                                    </div>
                                ))}
                                <div className="w-8 h-8 rounded-full border-2 border-white bg-primary text-white flex items-center justify-center text-[10px] font-bold">
                                    +12
                                </div>
                            </div>
                            <p className="text-xs text-muted-foreground self-center">
                                <span className="font-bold text-slate-900">12 new students</span> joined this week.
                            </p>
                        </div>
                    </CardContent>
                </Card>
            </div>
        </div>
    );
};
