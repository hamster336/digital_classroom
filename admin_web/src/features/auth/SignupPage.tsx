import { Button, Card, CardContent, CardDescription, CardHeader, CardTitle, Input } from '@/components/ui';
import { useAuth } from '@/context/AuthContext';
import { Lock, Mail, School, User } from 'lucide-react';  //  added Lock icon
import React from 'react';
import { Link, useNavigate } from 'react-router-dom';

export const SignupPage: React.FC = () => {
    const [name, setName] = React.useState('');
    const [email, setEmail] = React.useState('');
    const [password, setPassword] = React.useState('');
    const [error, setError] = React.useState<string | null>(null);    
    const [isLoading, setIsLoading] = React.useState(false);          // loading state
    const { signup } = useAuth();
    const navigate = useNavigate();

    const handleSubmit = async (e: React.FormEvent) => {   // async
        e.preventDefault();
        try {
            setIsLoading(true);
            setError(null);
            await signup(email, password, name);   // real Supabase signup with password + name
            navigate('/dashboard');
        } catch (err: any) {
            // show real error message from Supabase
            setError(err?.message || 'Signup failed. Please try again.');
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
                        Create Account
                    </h1>
                    <p className="mt-2 text-slate-600">
                        Join Academia and manage your institution
                    </p>
                </div>

                <Card className="border-none shadow-xl shadow-slate-200/50">
                    <CardHeader className="space-y-1 pt-8">
                        <CardTitle className="text-xl">Sign up</CardTitle>
                        <CardDescription>
                            Enter your details to create your admin account
                        </CardDescription>
                    </CardHeader>
                    <CardContent className="pb-8">
                        <form onSubmit={handleSubmit} className="space-y-4">

                            {/*  show error message if signup fails */}
                            {error && (
                                <div className="p-3 rounded-lg bg-destructive/10 text-destructive text-sm font-medium">
                                    {error}
                                </div>
                            )}

                            <div className="space-y-2">
                                <label className="text-sm font-medium leading-none" htmlFor="name">
                                    Full Name
                                </label>
                                <div className="relative">
                                    <User className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />
                                    <Input
                                        id="name"
                                        placeholder="John Doe"
                                        className="pl-10"
                                        value={name}
                                        onChange={(e) => setName(e.target.value)}
                                        required
                                    />
                                </div>
                            </div>
                            <div className="space-y-2">
                                <label className="text-sm font-medium leading-none" htmlFor="email">
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
                                <label className="text-sm font-medium leading-none" htmlFor="password">
                                    Password
                                </label>
                                <div className="relative">
                                    <Lock className="absolute left-3 top-2.5 h-4 w-4 text-slate-400" />  {/*  added Lock icon */}
                                    <Input
                                        id="password"
                                        type="password"
                                        placeholder="••••••••"
                                        className="pl-10"   
                                        value={password}
                                        onChange={(e) => setPassword(e.target.value)}
                                        required
                                    />
                                </div>
                            </div>

                            {/*  show loading state on button */}
                            <Button
                                type="submit"
                                className="w-full h-11 text-base font-semibold transition-all hover:scale-[1.01] active:scale-[0.99]"
                                disabled={isLoading}   // disable while loading
                            >
                                {isLoading ? 'Creating Account...' : 'Create Account'}  {/* loading text */}
                            </Button>
                        </form>

                        <div className="mt-6 text-center text-sm">
                            <span className="text-slate-600">Already have an account? </span>
                            <Link to="/login" className="font-semibold text-primary hover:underline">
                                Sign in
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
