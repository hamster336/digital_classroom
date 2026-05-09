import React, { useEffect, useRef, useState } from "react";
import { Schedule } from "../models/schedules";
import { ScheduleFile } from "../supabase/schedule";
import { getSchedules, addSchedule, deleteSchedule } from "../controllers/scheduleController";
import { useData } from "../context/DataContext";

type ScheduleWithFile = Schedule & { file: ScheduleFile };

export default function SchedulePage() {
    const { classrooms } = useData();
    const [schedules, setSchedules] = useState<ScheduleWithFile[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);
    const [selected, setSelected] = useState<ScheduleWithFile | null>(null);
    const [filterClassId, setFilterClassId] = useState<string>('');

    // Add form state
    const [showAdd, setShowAdd] = useState(false);
    const [addName, setAddName] = useState('');
    const [addClassId, setAddClassId] = useState('');
    const [addFile, setAddFile] = useState<File | null>(null);
    const [adding, setAdding] = useState(false);
    const [addError, setAddError] = useState<string | null>(null);

    const [deletingId, setDeletingId] = useState<string | null>(null);
    const fileInputRef = useRef<HTMLInputElement>(null);

    useEffect(() => { loadSchedules(); }, []);

    const loadSchedules = async () => {
        try {
            setLoading(true);
            setError(null);
            const data = await getSchedules();
            setSchedules(data);
            if (data.length > 0) setSelected(data[0]);
        } catch (err: any) {
            setError(err?.message || "Failed to load schedules.");
        } finally {
            setLoading(false);
        }
    };

    //  Filter by class
    const filtered = filterClassId
        ? schedules.filter(s => s.classId === filterClassId)
        : schedules;

    const handleAdd = async () => {
        if (!addName.trim()) { setAddError("Name is required."); return; }
        if (!addClassId) { setAddError("Please select a class."); return; }
        if (!addFile) { setAddError("Please select a file."); return; }

        try {
            setAdding(true);
            setAddError(null);
            const newSchedule = await addSchedule(addName, addClassId, addFile);
            setSchedules(prev => [newSchedule, ...prev]);
            setSelected(newSchedule);
            setShowAdd(false);
            setAddName('');
            setAddClassId('');
            setAddFile(null);
        } catch (err: any) {
            setAddError(err?.message || "Failed to add schedule.");
        } finally {
            setAdding(false);
        }
    };

    const handleDelete = async (schedule: ScheduleWithFile) => {
        if (!confirm(`Delete "${schedule.name}"?`)) return;
        try {
            setDeletingId(schedule.id);
            await deleteSchedule(schedule.id, schedule.filePath);
            const updated = schedules.filter(s => s.id !== schedule.id);
            setSchedules(updated);
            if (selected?.id === schedule.id) {
                setSelected(updated.length > 0 ? updated[0] : null);
            }
        } catch (err: any) {
            setError(err?.message || "Failed to delete schedule.");
        } finally {
            setDeletingId(null);
        }
    };

    return (
        <div style={styles.page}>
            {/* Header */}
            <div style={styles.header}>
                <h1 style={styles.title}>Schedule</h1>
                <button style={styles.addBtn} onClick={() => { setShowAdd(true); setAddError(null); }}>
                    + Add Schedule
                </button>
            </div>

            {/* Filter by class */}
            <div style={styles.filterWrap}>
                <select
                    style={styles.filter}
                    value={filterClassId}
                    onChange={(e) => {
                        setFilterClassId(e.target.value);
                        setSelected(null);
                    }}
                >
                    <option value="">All Classes</option>
                    {classrooms.map(c => (
                        <option key={c.id} value={c.id ?? ''}>{c.name}</option>
                    ))}
                </select>
            </div>

            {error && <p style={styles.error}>{error}</p>}
            {loading && <p style={styles.center}>Loading schedules...</p>}

            {!loading && filtered.length === 0 && (
                <p style={styles.center}>No schedules found.</p>
            )}

            {!loading && filtered.length > 0 && (
                <div style={styles.layout}>

                    {/* Sidebar */}
                    <div style={styles.sidebar}>
                        <p style={styles.sidebarTitle}>Schedules</p>
                        {filtered.map((s) => (
                            <div key={s.id} style={styles.fileBtnWrap}>
                                <button
                                    style={{
                                        ...styles.fileBtn,
                                        background: selected?.id === s.id ? '#10b981' : '#f3f4f6',
                                        color: selected?.id === s.id ? '#fff' : '#333',
                                        flex: 1,
                                    }}
                                    onClick={() => setSelected(s)}
                                >
                                    <div style={{ fontWeight: 700, fontSize: 13 }}>
                                        {s.file.type === 'pdf' ? '📄' : '🖼️'} {s.name}
                                    </div>
                                    <div style={{ fontSize: 11, opacity: 0.8, marginTop: 2 }}>
                                        {classrooms.find(c => c.id === s.classId)?.name || 'Unknown class'}
                                    </div>
                                </button>
                                <button
                                    style={styles.deleteBtn}
                                    onClick={() => handleDelete(s)}
                                    disabled={deletingId === s.id}
                                    title="Delete"
                                >
                                    {deletingId === s.id ? '⏳' : '🗑'}
                                </button>
                            </div>
                        ))}
                    </div>

                    {/* Preview */}
                    <div style={styles.preview}>
                        {selected ? (
                            <>
                                <div style={styles.previewHeader}>
                                    <div>
                                        <p style={styles.fileName}>{selected.name}</p>
                                        <p style={styles.className}>
                                            {classrooms.find(c => c.id === selected.classId)?.name || ''}
                                        </p>
                                    </div>
                                    <a
                                        href={selected.file.url}
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        style={styles.downloadBtn}
                                    >
                                         Download
                                    </a>
                                </div>
                                {selected.file.type === 'image' ? (
                                    <img
                                        src={selected.file.url}
                                        alt={selected.name}
                                        style={styles.image}
                                    />
                                ) : (
                                    <iframe
                                        src={selected.file.url}
                                        style={styles.iframe}
                                        title={selected.name}
                                    />
                                )}
                            </>
                        ) : (
                            <p style={styles.center}>Select a schedule to preview.</p>
                        )}
                    </div>
                </div>
            )}

            {/* Add Modal */}
            {showAdd && (
                <div style={styles.overlay}>
                    <div style={styles.modal}>
                        <h2 style={styles.modalTitle}>Add Schedule</h2>
                        {addError && <div style={styles.errorBanner}>{addError}</div>}

                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Schedule Name *</label>
                            <input
                                style={styles.input}
                                value={addName}
                                onChange={(e) => setAddName(e.target.value)}
                                placeholder="e.g. BCT 6th Sem Timetable"
                            />
                        </div>

                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Class *</label>
                            <select
                                style={styles.input}
                                value={addClassId}
                                onChange={(e) => setAddClassId(e.target.value)}
                            >
                                <option value="">Select a class</option>
                                {classrooms.map(c => (
                                    <option key={c.id} value={c.id ?? ''}>{c.name}</option>
                                ))}
                            </select>
                        </div>

                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>File (Image or PDF) *</label>
                            <input
                                ref={fileInputRef}
                                type="file"
                                accept="image/*,.pdf"
                                style={styles.input}
                                onChange={(e) => setAddFile(e.target.files?.[0] || null)}
                            />
                            {addFile && (
                                <p style={{ fontSize: 12, color: '#10b981', marginTop: 4 }}>
                                    {addFile.name}
                                </p>
                            )}
                        </div>

                        <div style={styles.modalActions}>
                            <button
                                style={styles.cancelBtn}
                                onClick={() => { setShowAdd(false); setAddError(null); }}
                            >
                                Cancel
                            </button>
                            <button
                                style={styles.addBtn}
                                onClick={handleAdd}
                                disabled={adding}
                            >
                                {adding ? 'Adding...' : 'Add Schedule'}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
}

const styles: Record<string, React.CSSProperties> = {
    page: { padding: '32px', fontFamily: 'sans-serif', maxWidth: 1100, margin: '0 auto' },
    header: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: 16 },
    title: { fontSize: 28, fontWeight: 700, margin: 0 },
    addBtn: { background: '#10b981', color: '#fff', border: 'none', borderRadius: 8, padding: '10px 20px', fontWeight: 600, cursor: 'pointer', fontSize: 14 },
    filterWrap: { marginBottom: 20 },
    filter: { padding: '8px 12px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14, minWidth: 200 },
    center: { textAlign: 'center', color: '#888', padding: '48px 0' },
    error: { color: '#ef4444', padding: '12px', background: '#fee2e2', borderRadius: 8, marginBottom: 16 },
    layout: { display: 'flex', gap: 24 },
    sidebar: { width: 240, flexShrink: 0, display: 'flex', flexDirection: 'column', gap: 8 },
    sidebarTitle: { fontSize: 12, fontWeight: 700, color: '#888', textTransform: 'uppercase', marginBottom: 4 },
    fileBtnWrap: { display: 'flex', gap: 6, alignItems: 'center' },
    fileBtn: { padding: '10px 14px', borderRadius: 8, border: 'none', cursor: 'pointer', textAlign: 'left', fontSize: 13 },
    deleteBtn: { background: '#fee2e2', border: 'none', borderRadius: 6, padding: '6px 8px', cursor: 'pointer', fontSize: 14, flexShrink: 0 },
    preview: { flex: 1, border: '1px solid #eee', borderRadius: 12, overflow: 'hidden' },
    previewHeader: { display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '12px 16px', borderBottom: '1px solid #eee', background: '#f8f8f8' },
    fileName: { fontWeight: 700, fontSize: 15, margin: 0 },
    className: { fontSize: 12, color: '#888', margin: 0, marginTop: 2 },
    downloadBtn: { background: '#10b981', color: '#fff', padding: '6px 14px', borderRadius: 8, textDecoration: 'none', fontSize: 13, fontWeight: 600 },
    image: { width: '100%', display: 'block', objectFit: 'contain', maxHeight: '75vh' },
    iframe: { width: '100%', height: '75vh', border: 'none', display: 'block' },
    overlay: { position: 'fixed', inset: 0, background: 'rgba(0,0,0,0.4)', display: 'flex', alignItems: 'center', justifyContent: 'center', zIndex: 1000 },
    modal: { background: '#fff', borderRadius: 16, padding: 32, width: '100%', maxWidth: 480, boxShadow: '0 20px 60px rgba(0,0,0,0.15)' },
    modalTitle: { fontSize: 20, fontWeight: 700, marginBottom: 20, marginTop: 0 },
    errorBanner: { background: '#fee2e2', color: '#b91c1c', padding: '10px 14px', borderRadius: 8, marginBottom: 16, fontSize: 14 },
    fieldWrap: { marginBottom: 16 },
    label: { display: 'block', fontSize: 13, fontWeight: 600, color: '#555', marginBottom: 6 },
    input: { width: '100%', padding: '10px 12px', borderRadius: 8, border: '1px solid #ddd', fontSize: 14, boxSizing: 'border-box' },
    modalActions: { display: 'flex', justifyContent: 'flex-end', gap: 12, marginTop: 24 },
    cancelBtn: { background: '#f3f4f6', color: '#333', border: 'none', borderRadius: 8, padding: '10px 20px', fontWeight: 600, cursor: 'pointer', fontSize: 14 },
};