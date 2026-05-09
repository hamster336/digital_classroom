import { Button, Card, CardContent, CardDescription, CardHeader, CardTitle, Input } from '@/components/ui';
import { useAuth } from '@/context/AuthContext';
import { Lock, Mail, School } from 'lucide-react';
import React from 'react';
import { Link, useNavigate } from 'react-router-dom';

export const LoginPage: React.FC = () => {
    const [email, setEmail] = React.useState('');
    const [password, setPassword] = React.useState('');
    const [error, setError] = React.useState<string | null>(null);      
    const [isLoading, setIsLoading] = React.useState(false);            
    const { login } = useAuth();
    const navigate = useNavigate();

    const handleSubmit = async (e: React.FormEvent) => {   // async
        e.preventDefault();
        try {
            setIsLoading(true);
            setError(null);
            await login(email, password);   // real Supabase login with password
            navigate('/dashboard');
        } catch (err: any) {
            //  show real error message from Supabase
            setError(err?.message || 'Login failed. Please check your credentials.');
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4">
            <div className="w-full max-w-md space-y-8">
                <div className="text-center">
                    <div className="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-primary text-primary-foreground mb-4 shadow-lg shadow-primary/20">
                        <School className="w-8 h-8" />
                    </div>
                    <h1 className="text-3xl font-extrabold tracking-tight text-slate-900">
                        Welcome Back
                    </h1>
                    <p className="mt-2 text-slate-600">
                        Log in to your Academia admin account
                    </p>
                </div>

                <Card className="border-none shadow-xl shadow-slate-200/50">
                    <CardHeader className="space-y-1 pt-8">
                        <CardTitle className="text-xl">Sign in</CardTitle>
                        <CardDescription>
                            Enter your email and password to access your dashboard
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="pb-8">
                        <form onSubmit={handleSubmit} className="space-y-4">

                            {/* show error message if login fails */}
                            {error && (
                                <div className="p-3 rounded-lg bg-destructive/10 text-destructive text-sm font-medium">
                                    {error}
                                </div>
                            )}

                            <div className="space-y-2">
                                <label className="text-sm font-medium leading-none peer-disabled:cursor-not-allowed peer-disabled:opacity-70" htmlFor="email">
                                    Email
                                </label>
                                <div className="relative">
                                    <Mail className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
                                    <Input
                                        id="email"
                                        placeholder="admin@academia.edu"
                                        type="email"
                                        className="pl-10"
                                        value={email}
                                        onChange={(e) => setEmail(e.target.value)}
                                        required
                                    />
                                </div>
                            </div>
                            <div className="space-y-2">
                                <div className="flex items-center justify-between">
                                    <label className="text-sm font-medium leading-none" htmlFor="password">
                                        Password
                                    </label>
                                    <a href="#" className="text-xs text-primary hover:underline">
                                        Forgot password?
                                    </a>
                                </div>
                                <div className="relative">
                                    <Lock className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
                                    <Input
                                        id="password"
                                        type="password"
                                        className="pl-10"
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        required
                                    />
                                </div>
                            </div>

                            {/* show loading state on button */}
                            <Button
                                type="submit"
                                className="w-full h-11 text-base font-semibold transition-all hover:scale-[1.01] active:scale-[0.99]"
                                disabled={isLoading}   // disable while loading
                            >
                                {isLoading ? 'Signing in...' : 'Sign In'}   {/* loading text */}
                            </Button>
                        </form>

                        <div className="mt-6 text-center text-sm">
                            <span className="text-slate-600">Don't have an account? </span>
                            <Link to="/signup" className="font-semibold text-primary hover:underline">
                                Create an account
                            </Link>
                        </div>
                    </CardContent>
                </Card>

                <div className="text-center text-xs text-slate-400">
                    &copy; {new Date().getFullYear()} Academia Management System. All rights reserved.
                </div>
            </div>
        </div>
    );
};
