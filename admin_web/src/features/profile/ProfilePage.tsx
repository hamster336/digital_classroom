import {
    Button,
    Card,
    CardContent,
    CardDescription,
    CardHeader,
    CardTitle,
    Dialog,
    DialogContent,
    DialogDescription,
    DialogHeader,
    DialogTitle,
    Input,
    Label
} from '@/components/ui';
import { useAuth } from '@/context/AuthContext';
import { Camera, Mail, Shield, User } from 'lucide-react';
import React from 'react';

export const ProfilePage: React.FC = () => {
    const { user } = useAuth();
    const [name, setName] = React.useState(user?.name || '');
    const [email, setEmail] = React.useState(user?.email || '');
    const [isSaving, setIsSaving] = React.useState(false);
    const [showSuccess, setShowSuccess] = React.useState(false);
    const [profileImage, setProfileImage] = React.useState<string | null>(null);
    const fileInputRef = React.useRef<HTMLInputElement>(null);

    const handleFileChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        const file = e.target.files?.[0];
        if (file) {
            const reader = new FileReader();
            reader.onloadend = () => {
                setProfileImage(reader.result as string);
            };
            reader.readAsDataURL(file);
        }
    };

    const triggerFileInput = () => {
        fileInputRef.current?.click();
    };

    const handleSave = (e: React.FormEvent) => {
        e.preventDefault();
        setIsSaving(true);

        // Simulate API call with latency
        setTimeout(() => {
            setIsSaving(false);
            setShowSuccess(true);
        }, 1500);
    };

    return (
        <div className="max-w-4xl mx-auto space-y-8 animate-in fade-in duration-500">
            <div className="flex flex-col gap-2">
                <h1 className="text-3xl font-bold tracking-tight">Profile Settings</h1>
                <p className="text-muted-foreground text-lg">
                    Manage your account settings and personal information.
                </p>
            </div>

            <div className="grid gap-8 lg:grid-cols-3">
                {/* Left Column: Avatar & Summary */}
                <div className="space-y-6">
                    <Card className="overflow-hidden border-none shadow-md shadow-slate-200/50">
                        <CardContent className="pt-8 pb-8 flex flex-col items-center text-center">
                            <div className="relative group">
                                <input
                                    type="file"
                                    ref={fileInputRef}
                                    className="hidden"
                                    accept="image/*"
                                    onChange={handleFileChange}
                                />
                                <div className="w-32 h-32 rounded-full bg-academia-100 flex items-center justify-center text-academia-700 text-4xl font-bold border-4 border-white shadow-xl overflow-hidden">
                                    {profileImage ? (
                                        <img src={profileImage} alt="Profile" className="w-full h-full object-cover" />
                                    ) : (
                                        user?.name?.split(' ').map(n => n[0]).join('')
                                    )}
                                </div>
                                <button
                                    onClick={triggerFileInput}
                                    className="absolute bottom-0 right-0 p-2 rounded-full bg-primary text-white shadow-lg border-2 border-white transition-transform hover:scale-110 active:scale-95 group-hover:bg-primary/90"
                                >
                                    <Camera className="w-4 h-4" />
                                </button>
                            </div>
                            <div className="mt-6 space-y-1">
                                <h3 className="text-xl font-bold">{user?.name}</h3>
                                <p className="text-sm font-medium text-primary uppercase tracking-wider">{user?.role}</p>
                            </div>
                        </CardContent>
                    </Card>

                    <Card className="border-none shadow-sm h-[130px]">
                        <CardHeader className="pb-2">
                            <CardTitle className="text-sm font-medium flex items-center gap-2">
                                <Shield className="w-4 h-4 text-slate-400" /> Account Status
                            </CardTitle>
                        </CardHeader>
                        <CardContent>
                            <div className="flex items-center gap-2">
                                <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                                <span className="text-sm font-semibold text-slate-600">Active institutional member</span>
                            </div>
                            <p className="text-[11px] text-muted-foreground mt-2 italic px-4">
                                Member since Jan 2024
                            </p>
                        </CardContent>
                    </Card>
                </div>

                {/* Right Column: Detailed Info Form */}
                <div className="lg:col-span-2">
                    <Card className="border-none shadow-xl shadow-slate-200/40">
                        <CardHeader className="border-b bg-slate-50/50 py-6">
                            <CardTitle className="text-lg">Personal Information</CardTitle>
                            <CardDescription>
                                Update your institutional profile details below.
                            </CardDescription>
                        </CardHeader>
                        <CardContent className="pt-8">
                            <form onSubmit={handleSave} className="space-y-6">
                                <div className="grid gap-6 sm:grid-cols-2">
                                    <div className="space-y-2">
                                        <Label htmlFor="name">Full Name</Label>
                                        <div className="relative">
                                            <User className="absolute left-3 top-3 h-4 w-4 text-slate-400" />
                                            <Input
                                                id="name"
                                                className="pl-10"
                                                value={name}
                                                onChange={(e) => setName(e.target.value)}
                                            />
                                        </div>
                                    </div>
                                    <div className="space-y-2">
                                        <Label htmlFor="email">Institutional Email</Label>
                                        <div className="relative">
                                            <Mail className="absolute left-3 top-3 h-4 w-4 text-slate-400" />
                                            <Input
                                                id="email"
                                                type="email"
                                                className="pl-10"
                                                value={email}
                                                onChange={(e) => setEmail(e.target.value)}
                                            />
                                        </div>
                                    </div>
                                </div>

                                <div className="space-y-2">
                                    <Label htmlFor="bio">Institution Role Bio</Label>
                                    <textarea
                                        id="bio"
                                        className="flex min-h-[100px] w-full rounded-md border border-input bg-transparent px-3 py-2 text-sm shadow-sm transition-colors placeholder:text-muted-foreground focus-visible:outline-none focus-visible:ring-1 focus-visible:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
                                        placeholder="Tell us about your role in the institution..."
                                    />
                                </div>

                                <div className="flex justify-end pt-4">
                                    <Button
                                        type="submit"
                                        disabled={isSaving}
                                        className="px-10 h-11 text-base font-semibold transition-all hover:shadow-lg hover:shadow-primary/20"
                                    >
                                        {isSaving ? (
                                            <>
                                                <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                                                Saving...
                                            </>
                                        ) : 'Save Changes'}
                                    </Button>
                                </div>
                            </form>
                        </CardContent>
                    </Card>
                </div>
            </div>

            {/* Success Feedback Modal */}
            <Dialog open={showSuccess} onOpenChange={setShowSuccess}>
                <DialogContent className="sm:max-w-md">
                    <DialogHeader>
                        <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-emerald-100 mb-4">
                            <div className="h-10 w-10 text-emerald-600">
                                <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={3} d="M5 13l4 4L19 7" />
                                </svg>
                            </div>
                        </div>
                        <DialogTitle className="text-center text-2xl">Profile Updated!</DialogTitle>
                        <DialogDescription className="text-center font-medium">
                            Your institutional profile settings have been successfully saved and synchronized.
                        </DialogDescription>
                    </DialogHeader>
                    <div className="flex justify-center pt-4">
                        <Button onClick={() => setShowSuccess(false)} className="w-full sm:w-32">
                            Done
                        </Button>
                    </div>
                </DialogContent>
            </Dialog>
        </div>
    );
};
