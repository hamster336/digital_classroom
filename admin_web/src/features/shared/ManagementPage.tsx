import {
    Button,
    Card,
    CardContent,
    Dialog,
    DialogContent,
    DialogDescription,
    DialogFooter,
    DialogHeader,
    DialogTitle,
    Input
} from '@/components/ui';
import { AlertTriangle, ChevronLeft, ChevronRight, Edit, Plus, Save, Search, Trash, X } from 'lucide-react';
import React from 'react';
import { useSearchParams } from 'react-router-dom';

interface Entity {
    id: string | null;
    [key: string]: any;
}

export interface FilterConfig<T> {
    key: keyof T;
    label: string;
    options: { label: string; value: string }[];
}

interface ManagementPageProps<T extends Entity> {
    title: string;
    initialData?: T[];
    data?: T[];
    columns: {
        key: keyof T;
        label: string;
        render?: (value: any, item: T) => React.ReactNode;
    }[];
    filters?: FilterConfig<T>[];
    onSave: (data: T) => Promise<void>;   
    onDelete: (id: string) => Promise<void>; 
    renderForm: (data: Partial<T>, onChange: (field: keyof T, value: any) => void) => React.ReactNode;
    emptyEntity: Partial<T>;
}

export function ManagementPage<T extends Entity>({
    title,
    initialData = [],
    data: externalData,
    columns,
    filters = [],
    onSave,
    onDelete,
    renderForm,
    emptyEntity
}: ManagementPageProps<T>) {
    const [internalData, setInternalData] = React.useState<T[]>(initialData);
    const data = externalData !== undefined ? externalData : internalData;
    const [editingId, setEditingId] = React.useState<string | null>(null);
    const [formData, setFormData] = React.useState<Partial<T>>(emptyEntity);
    const [isAdding, setIsAdding] = React.useState(false);
    const [deleteId, setDeleteId] = React.useState<string | null>(null);

    //  added loading and error states
    const [submitLoading, setSubmitLoading] = React.useState(false);
    const [submitError, setSubmitError] = React.useState<string | null>(null);
    const [deleteLoading, setDeleteLoading] = React.useState(false);

    const [searchParams, setSearchParams] = useSearchParams();
    const searchTerm = searchParams.get('q') || '';

    const activeFilters = React.useMemo(() => {
        const filtersObj: Record<string, string> = {};
        filters.forEach(f => {
            const val = searchParams.get(f.key as string);
            if (val) filtersObj[f.key as string] = val;
        });
        return filtersObj;
    }, [searchParams, filters]);

    const [currentPage, setCurrentPage] = React.useState(1);
    const itemsPerPage = 8;

    const updateSearchParam = (key: string, value: string) => {
        setSearchParams(prev => {
            const newParams = new URLSearchParams(prev);
            if (value) newParams.set(key, value);
            else newParams.delete(key);
            return newParams;
        }, { replace: true });
    };

    const clearAllFilters = () => {
        setSearchParams(new URLSearchParams(), { replace: true });
    };

    const hasActiveFilters = searchTerm !== '' || Object.keys(activeFilters).length > 0;

    React.useEffect(() => {
        setCurrentPage(1);
    }, [searchTerm, activeFilters]);

    const filteredData = React.useMemo(() => {
        return data.filter(item => {
            const matchesSearch = !searchTerm || Object.values(item).some(val =>
                String(val).toLowerCase().includes(searchTerm.toLowerCase())
            );
            const matchesFilters = Object.entries(activeFilters).every(([key, value]) => {
                if (!value) return true;
                return String(item[key]) === value;
            });
            return matchesSearch && matchesFilters;
        });
    }, [data, searchTerm, activeFilters]);

    const totalPages = Math.ceil(filteredData.length / itemsPerPage);
    const startIndex = (currentPage - 1) * itemsPerPage;
    const paginatedData = filteredData.slice(startIndex, startIndex + itemsPerPage);

    const handleEdit = (item: T) => {
        setEditingId(item.id);
        setFormData(item);
        setIsAdding(false);
        setSubmitError(null); // clear error on open
    };

    const handleAdd = () => {
        setIsAdding(true);
        setEditingId(null);
        setFormData(emptyEntity);
        setSubmitError(null); // clear error on open
    };

    const handleCancel = () => {
        setEditingId(null);
        setIsAdding(false);
        setFormData(emptyEntity);
        setSubmitError(null); // clear error on close
    };

    // now async and properly awaits onSave
    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault();
        const newEntity = {
            ...formData,
            id: editingId || null
        } as T;

        try {
            setSubmitLoading(true);
            setSubmitError(null);
            await onSave(newEntity); //properly awaited
            handleCancel();
        } catch (err: any) {
            console.error("Save error:", err);
            setSubmitError(err?.message || "Failed to save. Please try again.");
        } finally {
            setSubmitLoading(false);
        }
    };

    const handleDeleteClick = (id: string | null) => {
        if (id) setDeleteId(id);
    };

    //  now async and properly awaits onDelete
    const confirmDelete = async () => {
        if (deleteId) {
            try {
                setDeleteLoading(true);
                await onDelete(deleteId); //  properly awaited
                if (externalData === undefined) {
                    setInternalData(prev => prev.filter(item => item.id !== deleteId));
                }
                setDeleteId(null);
            } catch (err: any) {
                console.error("Delete error:", err);
                setDeleteId(null);
            } finally {
                setDeleteLoading(false);
            }
        }
    };

    const handleChange = (field: keyof T, value: any) => {
        setFormData(prev => ({ ...prev, [field]: value }));
    };

    return (
        <div className="space-y-6">
            <div className="flex flex-col lg:flex-row justify-between items-start lg:items-center gap-4">
                <h2 className="text-2xl font-bold">{title}</h2>
                <div className="flex flex-col sm:flex-row w-full lg:w-auto items-center gap-2">
                    <div className="relative flex-1 sm:w-64 w-full">
                        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
                        <Input
                            placeholder={`Search ${title.toLowerCase()}...`}
                            className="pl-10 h-10 border-slate-200 focus:ring-primary/20"
                            value={searchTerm}
                            onChange={(e) => updateSearchParam('q', e.target.value)}
                        />
                    </div>

                    <div className="flex flex-wrap items-center gap-2 w-full sm:w-auto">
                        {filters.map((filter) => (
                            <select
                                key={filter.key as string}
                                className="h-10 rounded-md border border-slate-200 bg-white px-3 py-1 text-sm shadow-sm transition-colors focus:outline-none focus:ring-2 focus:ring-primary/20"
                                value={activeFilters[filter.key as string] || ''}
                                onChange={(e) => updateSearchParam(filter.key as string, e.target.value)}
                            >
                                <option value="">All {filter.label}s</option>
                                {filter.options.map(opt => (
                                    <option key={opt.value} value={opt.value}>{opt.label}</option>
                                ))}
                            </select>
                        ))}

                        {hasActiveFilters && (
                            <Button
                                variant="ghost"
                                size="sm"
                                className="h-10 px-2 text-slate-500 hover:text-slate-900"
                                onClick={clearAllFilters}
                            >
                                <X className="w-4 h-4 mr-1" /> Clear
                            </Button>
                        )}

                        <Button onClick={handleAdd} className="flex items-center gap-2 h-10 shadow-sm ml-auto sm:ml-0">
                            <Plus className="w-4 h-4" /> Add New
                        </Button>
                    </div>
                </div>
            </div>

            {/* Add / Edit Dialog */}
            <Dialog open={isAdding || editingId !== null} onOpenChange={(open) => !open && handleCancel()}>
                <DialogContent className="sm:max-w-[500px]">
                    <DialogHeader>
                        <DialogTitle>{isAdding ? 'Add New' : 'Edit'} {title.slice(0, -1)}</DialogTitle>
                        <DialogDescription>
                            {isAdding
                                ? `Fill in the details to create a new ${title.slice(0, -1).toLowerCase()}.`
                                : `Update the information for this ${title.slice(0, -1).toLowerCase()}.`}
                        </DialogDescription>
                    </DialogHeader>

                    {/*  error banner inside modal */}
                    {submitError && (
                        <div className="bg-red-50 text-red-600 text-sm px-4 py-3 rounded-lg border border-red-200">
                            {submitError}
                        </div>
                    )}

                    <form onSubmit={handleSubmit} className="space-y-4 pt-4">
                        {renderForm(formData, handleChange)}
                        <div className="flex justify-end gap-2 pt-6">
                            <Button type="button" variant="outline" onClick={handleCancel} disabled={submitLoading}>
                                Cancel
                            </Button>
                            {/*  FIX: disabled and shows spinner while saving */}
                            <Button type="submit" className="px-8" disabled={submitLoading}>
                                {submitLoading ? (
                                    <>
                                        <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                                        Saving...
                                    </>
                                ) : (
                                    <><Save className="w-4 h-4 mr-2" />{editingId ? 'Update' : 'Save'}</>
                                )}
                            </Button>
                        </div>
                    </form>
                </DialogContent>
            </Dialog>

            {/* Delete Confirmation Dialog */}
            <Dialog open={deleteId !== null} onOpenChange={(open) => !open && setDeleteId(null)}>
                <DialogContent className="sm:max-w-[400px]">
                    <DialogHeader>
                        <div className="mx-auto w-12 h-12 rounded-full bg-destructive/10 flex items-center justify-center mb-2">
                            <AlertTriangle className="w-6 h-6 text-destructive" />
                        </div>
                        <DialogTitle className="text-center">Confirm Deletion</DialogTitle>
                        <DialogDescription className="text-center">
                            Are you sure you want to delete this {title.slice(0, -1).toLowerCase()}? This action cannot be undone.
                        </DialogDescription>
                    </DialogHeader>
                    <DialogFooter className="sm:justify-center gap-2 mt-2">
                        <Button variant="outline" onClick={() => setDeleteId(null)} className="flex-1" disabled={deleteLoading}>
                            Cancel
                        </Button>
                        {/* disabled and shows spinner while deleting */}
                        <Button variant="destructive" onClick={confirmDelete} className="flex-1" disabled={deleteLoading}>
                            {deleteLoading ? (
                                <>
                                    <div className="mr-2 h-4 w-4 animate-spin rounded-full border-2 border-white border-t-transparent" />
                                    Deleting...
                                </>
                            ) : 'Delete'}
                        </Button>
                    </DialogFooter>
                </DialogContent>
            </Dialog>

            <Card className="overflow-hidden border-none shadow-sm sm:border sm:shadow">
                <CardContent className="p-0">
                    {/* Desktop Table View */}
                    <div className="hidden md:block overflow-x-auto">
                        <table className="w-full text-sm text-left">
                            <thead className="text-xs uppercase bg-slate-50 text-slate-500 border-b">
                                <tr>
                                    {columns.map(col => (
                                        <th key={col.key as string} className="px-6 py-4 font-semibold">{col.label}</th>
                                    ))}
                                    <th className="px-6 py-4 font-semibold text-right">Actions</th>
                                </tr>
                            </thead>
                            <tbody className="divide-y divide-slate-100">
                                {paginatedData.map((item) => (
                                    <tr key={item.id} className="hover:bg-slate-50/50 transition-colors">
                                        {columns.map(col => (
                                            <td key={col.key as string} className="px-6 py-4 text-slate-700">
                                                {col.render ? col.render(item[col.key], item) : (item[col.key as string] as React.ReactNode)}
                                            </td>
                                        ))}
                                        <td className="px-6 py-4 text-right space-x-1">
                                            <Button variant="ghost" size="icon" className="h-8 w-8 text-primary hover:text-primary hover:bg-primary/10" onClick={() => handleEdit(item)}>
                                                <Edit className="w-4 h-4" />
                                            </Button>
                                            <Button variant="ghost" size="icon" className="h-8 w-8 text-destructive hover:text-destructive hover:bg-destructive/10" onClick={() => handleDeleteClick(item.id)}>
                                                <Trash className="w-4 h-4" />
                                            </Button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>

                    {/* Mobile Card View */}
                    <div className="md:hidden divide-y divide-slate-100">
                        {paginatedData.map((item) => (
                            <div key={item.id} className="p-4 space-y-3 bg-card">
                                <div className="flex justify-between items-start">
                                    <div className="space-y-1">
                                        {columns.map((col, idx) => (
                                            <div key={col.key as string} className={idx === 0 ? "font-bold text-slate-900" : "text-sm text-slate-500"}>
                                                <span className="font-medium text-slate-400 mr-2 md:hidden">{col.label}:</span>
                                                {col.render ? col.render(item[col.key], item) : (item[col.key as string] as React.ReactNode)}
                                            </div>
                                        ))}
                                    </div>
                                    <div className="flex gap-1">
                                        <Button variant="ghost" size="icon" className="h-9 w-9 text-primary bg-primary/5" onClick={() => handleEdit(item)}>
                                            <Edit className="w-4 h-4" />
                                        </Button>
                                        <Button variant="ghost" size="icon" className="h-9 w-9 text-destructive bg-destructive/5" onClick={() => handleDeleteClick(item.id)}>
                                            <Trash className="w-4 h-4" />
                                        </Button>
                                    </div>
                                </div>
                            </div>
                        ))}
                    </div>

                    {filteredData.length === 0 && (
                        <div className="p-12 text-center text-muted-foreground bg-card">
                            <p className="text-lg font-medium text-slate-400">No data available.</p>
                            <p className="text-sm">Click "Add New" to get started.</p>
                        </div>
                    )}
                </CardContent>

                {/* Pagination Controls */}
                {totalPages > 1 && (
                    <div className="px-6 py-4 bg-slate-50 border-t flex flex-col sm:flex-row items-center justify-between gap-4">
                        <p className="text-xs font-semibold text-slate-500 uppercase tracking-wider">
                            Showing <span className="text-slate-900">{startIndex + 1}</span> to <span className="text-slate-900">{Math.min(startIndex + itemsPerPage, filteredData.length)}</span> of <span className="text-slate-900">{filteredData.length}</span> entries
                        </p>
                        <div className="flex items-center gap-1">
                            <Button
                                variant="outline"
                                size="sm"
                                className="h-8 w-8 p-0"
                                onClick={() => setCurrentPage(prev => Math.max(prev - 1, 1))}
                                disabled={currentPage === 1}
                            >
                                <ChevronLeft className="w-4 h-4" />
                            </Button>
                            <div className="flex items-center gap-1">
                                {[...Array(totalPages)].map((_, i) => (
                                    <Button
                                        key={i + 1}
                                        variant={currentPage === i + 1 ? "default" : "ghost"}
                                        size="sm"
                                        className="h-8 w-8 p-0 text-xs font-bold"
                                        onClick={() => setCurrentPage(i + 1)}
                                    >
                                        {i + 1}
                                    </Button>
                                ))}
                            </div>
                            <Button
                                variant="outline"
                                size="sm"
                                className="h-8 w-8 p-0"
                                onClick={() => setCurrentPage(prev => Math.min(prev + 1, totalPages))}
                                disabled={currentPage === totalPages}
                            >
                                <ChevronRight className="w-4 h-4" />
                            </Button>
                        </div>
                    </div>
                )}
            </Card>
        </div>
    );
}