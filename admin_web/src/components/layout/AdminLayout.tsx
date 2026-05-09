import {
    DropdownMenu,
    DropdownMenuContent,
    DropdownMenuItem,
    DropdownMenuLabel,
    DropdownMenuSeparator,
    DropdownMenuTrigger,
} from '@/components/ui';
import { useAuth } from '@/context/AuthContext';
import { cn } from '@/lib/utils';
import {
    Bell,
    BookOpen,
    Calendar,       
    LayoutDashboard,
    LogOut,
    Menu,
    School,
    Settings,
    User as UserIcon,
    Users,
    UserSquare2,
    X
} from 'lucide-react';
import React from 'react';
import { Link, Outlet, useLocation, useNavigate } from 'react-router-dom';

interface NavItemProps {
    icon: React.ElementType;
    label: string;
    to: string;
    active?: boolean;
}

const NavItem = ({ icon: Icon, label, to, active }: NavItemProps) => (
    <Link
        to={to}
        className={cn(
            "flex items-center w-full px-4 py-3 text-sm font-medium transition-colors rounded-lg mb-1",
            active
                ? "bg-primary text-primary-foreground shadow-sm"
                : "text-muted-foreground hover:bg-accent hover:text-accent-foreground"
        )}
    >
        <Icon className="w-5 h-5 mr-3" />
        {label}
    </Link>
);

export const AdminLayout: React.FC = () => {
    const [isSidebarOpen, setIsSidebarOpen] = React.useState(false);
    const location = useLocation();
    const { user, logout } = useAuth();
    const navigate = useNavigate();

    const handleLogout = async () => {
        try {
            await logout();
            navigate('/login');
        } catch (error) {
            console.error("Logout failed:", error);
        }
    };

    const navItems = [
        { id: 'dashboard', label: 'Dashboard', icon: LayoutDashboard, to: '/dashboard' },
        { id: 'classrooms', label: 'Classrooms', icon: School, to: '/classrooms' },
        { id: 'subjects', label: 'Subjects', icon: BookOpen, to: '/subjects' },
        { id: 'teachers', label: 'Teachers', icon: UserSquare2, to: '/teachers' },
        { id: 'students', label: 'Students', icon: Users, to: '/students' },
        { id: 'notices', label: 'Notices', icon: Bell, to: '/notices' },
        { id: 'schedules', label: 'Schedules', icon: Calendar, to: '/schedules' }, // ✅ added
    ];

    const currentTab = navItems.find(item => item.to === location.pathname)?.label || 'Dashboard';

    return (
        <div className="flex h-screen bg-background">
            {isSidebarOpen && (
                <div
                    className="fixed inset-0 z-40 bg-slate-900/40 backdrop-blur-[2px] lg:hidden"
                    onClick={() => setIsSidebarOpen(false)}
                />
            )}

            <aside
                className={cn(
                    "fixed inset-y-0 left-0 z-50 w-64 bg-card border-r transition-all duration-300 ease-in-out lg:relative lg:translate-x-0 shadow-xl lg:shadow-none",
                    isSidebarOpen ? "translate-x-0" : "-translate-x-full"
                )}
            >
                <div className="flex items-center justify-between h-16 px-6 border-b">
                    <div className="flex items-center gap-2">
                        <div className="w-8 h-8 rounded-lg bg-primary flex items-center justify-center shadow-md shadow-primary/20">
                            <School className="w-5 h-5 text-primary-foreground" />
                        </div>
                        <span className="text-xl font-bold tracking-tight text-slate-900">Academia</span>
                    </div>
                    <button
                        className="p-1 rounded-md hover:bg-accent lg:hidden"
                        onClick={() => setIsSidebarOpen(false)}
                    >
                        <X className="w-6 h-6" />
                    </button>
                </div>

                <nav className="p-4 mt-2">
                    {navItems.map((item) => (
                        <NavItem
                            key={item.id}
                            icon={item.icon}
                            label={item.label}
                            to={item.to}
                            active={location.pathname === item.to}
                        />
                    ))}
                </nav>

                <div className="absolute bottom-0 w-full p-4 border-t bg-card space-y-1">
                    <NavItem
                        icon={Settings}
                        label="Settings"
                        to="/settings"
                        active={location.pathname === '/settings'}
                    />
                    <button
                        onClick={handleLogout}
                        className="flex items-center w-full px-4 py-3 text-sm font-medium transition-colors rounded-lg text-destructive hover:bg-destructive/10"
                    >
                        <LogOut className="w-5 h-5 mr-3" />
                        Logout
                    </button>
                </div>
            </aside>

            <main className="flex-1 flex flex-col min-w-0 overflow-hidden">
                <header className="flex items-center justify-between h-16 px-4 sm:px-6 bg-card border-b sticky top-0 z-30 shadow-sm shadow-slate-200/20">
                    <button
                        className="p-2 -ml-2 rounded-md hover:bg-accent lg:hidden"
                        onClick={() => setIsSidebarOpen(true)}
                    >
                        <Menu className="w-6 h-6" />
                    </button>

                    <div className="flex-1 px-2 sm:px-4">
                        <h1 className="text-base sm:text-lg font-bold truncate">
                            {currentTab}
                        </h1>
                    </div>

                    <div className="flex items-center gap-2 sm:gap-4">
                        <button className="p-2 rounded-full hover:bg-accent relative hidden xs:block">
                            <Bell className="w-5 h-5 text-muted-foreground" />
                            <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-destructive rounded-full border-2 border-card" />
                        </button>
                        <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                                <button className="flex items-center gap-2 sm:gap-3 pl-2 sm:pl-4 border-l hover:bg-slate-50 transition-colors py-1 rounded-lg">
                                    <div className="flex flex-col items-end hidden md:flex text-right">
                                        <span className="text-sm font-semibold whitespace-nowrap">{user?.name}</span>
                                        <span className="text-[10px] uppercase tracking-wider font-bold text-muted-foreground">{user?.role}</span>
                                    </div>
                                    <div className="w-8 h-8 sm:w-9 sm:h-9 rounded-full bg-academia-100 flex items-center justify-center text-academia-700 text-sm sm:text-base font-bold border-2 border-primary/20 shadow-sm transition-transform active:scale-95">
                                        {user?.name?.split(' ').map(n => n[0]).join('')}
                                    </div>
                                </button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent className="w-56" align="end" forceMount>
                                <DropdownMenuLabel className="font-normal font-bold">
                                    <div className="flex flex-col space-y-1">
                                        <p className="text-sm font-bold leading-none">{user?.name}</p>
                                        <p className="text-xs leading-none text-muted-foreground">
                                            {user?.email}
                                        </p>
                                    </div>
                                </DropdownMenuLabel>
                                <DropdownMenuSeparator />
                                <DropdownMenuItem asChild>
                                    <Link to="/profile" className="flex items-center w-full">
                                        <UserIcon className="mr-2 h-4 w-4" />
                                        Profile
                                    </Link>
                                </DropdownMenuItem>
                                <DropdownMenuItem asChild>
                                    <Link to="/settings" className="flex items-center w-full">
                                        <Settings className="mr-2 h-4 w-4" />
                                        Settings
                                    </Link>
                                </DropdownMenuItem>
                                <DropdownMenuSeparator />
                                <DropdownMenuItem onClick={handleLogout} className="text-destructive">
                                    <LogOut className="mr-2 h-4 w-4" />
                                    Log out
                                </DropdownMenuItem>
                            </DropdownMenuContent>
                        </DropdownMenu>
                    </div>
                </header>

                <div className="flex-1 overflow-y-auto bg-slate-50/50">
                    <div className="max-w-7xl mx-auto p-4 sm:p-6 lg:p-8">
                        <Outlet />
                    </div>
                </div>
            </main>
        </div>
    );
};