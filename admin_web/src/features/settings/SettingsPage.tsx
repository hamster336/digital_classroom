import { Button, Card, CardContent, CardDescription, CardHeader, CardTitle, Label, Switch } from '@/components/ui';
import { useData } from '@/context/DataContext';
import { AlertTriangle, Bell, Globe, Lock } from 'lucide-react';
import React from 'react';

export const SettingsPage: React.FC = () => {
    const { refreshAll } = useData();

    const [darkMode, setDarkMode] = React.useState(() => {
        return localStorage.getItem('darkMode') === 'true';
    });

    React.useEffect(() => {
        if (darkMode) {
            document.documentElement.classList.add('dark');
        } else {
            document.documentElement.classList.remove('dark');
        }
        localStorage.setItem('darkMode', String(darkMode));
    }, [darkMode]);

    return (
        <div className="max-w-4xl mx-auto space-y-8 animate-in fade-in duration-500">
            <div className="flex flex-col gap-2">
                <h1 className="text-3xl font-bold tracking-tight">Application Settings</h1>
                <p className="text-muted-foreground text-lg">
                    Manage your institution's configuration and your personal preferences.
                </p>
            </div>

            <div className="space-y-6">
                {/* General Settings */}
                <Card className="border-none shadow-lg shadow-slate-200/40 overflow-hidden">
                    <CardHeader className="bg-slate-50/50 border-b py-6">
                        <div className="flex items-center gap-2">
                            <Globe className="w-5 h-5 text-primary" />
                            <CardTitle className="text-lg">General Preferences</CardTitle>
                        </div>
                        <CardDescription>
                            Configure basic application settings and localization.
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="divide-y divide-slate-100">
                        <div className="flex items-center justify-between py-6">
                            <div className="space-y-1">
                                <Label className="text-base">Public Institution Profile</Label>
                                <p className="text-sm text-muted-foreground">Make your institution profile visible to the public.</p>
                            </div>
                            <Switch defaultChecked />
                        </div>
                        <div className="flex items-center justify-between py-6">
                            <div className="space-y-1">
                                <Label className="text-base">Dark Mode</Label>
                                <p className="text-sm text-muted-foreground">Toggle between light and dark theme.</p>
                            </div>
                            <Switch
                                checked={darkMode}
                                onChange={(e: React.ChangeEvent<HTMLInputElement>) => setDarkMode(e.target.checked)}
                            />
                        </div>
                        <div className="flex items-center justify-between py-6">
                            <div className="space-y-1">
                                <Label className="text-base">Automatic Backups</Label>
                                <p className="text-sm text-muted-foreground">Cloud backup of all institutional data every 24 hours.</p>
                            </div>
                            <Switch defaultChecked />
                        </div>
                    </CardContent>
                </Card>

                {/* Notifications */}
                <Card className="border-none shadow-lg shadow-slate-200/40 overflow-hidden">
                    <CardHeader className="bg-slate-50/50 border-b py-6">
                        <div className="flex items-center gap-2">
                            <Bell className="w-5 h-5 text-primary" />
                            <CardTitle className="text-lg">Notification Channels</CardTitle>
                        </div>
                        <CardDescription>
                            Choose how you want to be notified about important updates.
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="divide-y divide-slate-100">
                        <div className="flex items-center justify-between py-6">
                            <div className="space-y-1">
                                <Label className="text-base">Email Notifications</Label>
                                <p className="text-sm text-muted-foreground">Receive daily summaries and critical alerts via email.</p>
                            </div>
                            <Switch defaultChecked />
                        </div>
                        <div className="flex items-center justify-between py-6">
                            <div className="space-y-1">
                                <Label className="text-base">Push Notifications</Label>
                                <p className="text-sm text-muted-foreground">Real-time alerts in your browser.</p>
                            </div>
                            <Switch defaultChecked />
                        </div>
                    </CardContent>
                </Card>

                {/* Security */}
                <Card className="border-none shadow-lg shadow-slate-200/40 overflow-hidden">
                    <CardHeader className="bg-slate-50/50 border-b py-6">
                        <div className="flex items-center gap-2">
                            <Lock className="w-5 h-5 text-primary" />
                            <CardTitle className="text-lg">Security & Privacy</CardTitle>
                        </div>
                        <CardDescription>
                            Control your account security and authorization settings.
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="divide-y divide-slate-100">
                        <div className="flex items-center justify-between py-6">
                            <div className="space-y-1">
                                <Label className="text-base">Two-Factor Authentication</Label>
                                <p className="text-sm text-muted-foreground">Add an extra layer of security to your admin account.</p>
                            </div>
                            <Button variant="outline" size="sm">Configure</Button>
                        </div>
                    </CardContent>
                </Card>

                {/* Data Management - Danger Zone */}
                <Card className="border-none shadow-lg shadow-red-100/50 overflow-hidden border-t-4 border-t-red-500">
                    <CardHeader className="bg-red-50/30 border-b py-6">
                        <div className="flex items-center gap-2">
                            <AlertTriangle className="w-5 h-5 text-red-600" />
                            <CardTitle className="text-lg text-red-900">Danger Zone</CardTitle>
                        </div>
                        <CardDescription className="text-red-700/70">
                            Irreversible actions that affect all institutional data.
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="divide-y divide-red-100/50">
                        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between py-6 gap-4">
                            <div className="space-y-1">
                                <Label className="text-base text-red-900">Reset to Factory Defaults</Label>
                                <p className="text-sm text-red-700/70">
                                    Clears all local changes and reloads the default institutional dataset (including 125 students and 55 classrooms).
                                </p>
                            </div>
                            <Button
                                variant="destructive"
                                className="shadow-lg shadow-red-200"
                                onClick={() => {
                                    if (confirm("Are you sure? This will delete all your manual changes and reload the default massive test data.")) {
                                        refreshAll();
                                    }
                                }}
                            >
                                Reset All Data
                            </Button>
                        </div>
                    </CardContent>
                </Card>
            </div>

            <div className="flex justify-end gap-3 pb-8">
                <Button variant="outline">Discard Changes</Button>
                <Button className="px-8 shadow-md">Save All Settings</Button>
            </div>
        </div>
    );
};