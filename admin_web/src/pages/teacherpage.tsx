import React, { useEffect, useState, useRef } from "react";
import { Teacher } from "../models/teacher";
import {
    createTeacher,
    getAllTeachers,
    updateTeacher,
    deleteTeacher,
    uploadTeacherAvatar,
} from "../controllers/teacherController";

interface AddForm {
    fullName: string;
    email: string;
    employeeId: string;
    avatarFile: File | null;
    avatarPreview: string | null;
}

interface EditForm {
    employeeId: string;
    avatarFile: File | null;
    avatarPreview: string | null;
}

const EMPTY_ADD: AddForm = {
    fullName: "",
    email: "",
    employeeId: "",
    avatarFile: null,
    avatarPreview: null,
};

const EMPTY_EDIT: EditForm = {
    employeeId: "",
    avatarFile: null,
    avatarPreview: null,
};

const TeacherPage: React.FC = () => {
    const [teachers, setTeachers] = useState<Teacher[]>([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState<string | null>(null);

    const [showAdd, setShowAdd] = useState(false);
    const [addForm, setAddForm] = useState<AddForm>(EMPTY_ADD);
    const [addLoading, setAddLoading] = useState(false);
    const [addError, setAddError] = useState<string | null>(null);

    const [editingTeacher, setEditingTeacher] = useState<Teacher | null>(null);
    const [editForm, setEditForm] = useState<EditForm>(EMPTY_EDIT);
    const [editLoading, setEditLoading] = useState(false);
    const [editError, setEditError] = useState<string | null>(null);

    const [deletingId, setDeletingId] = useState<string | null>(null);
    const [deleteLoading, setDeleteLoading] = useState(false);

    const addFileRef = useRef<HTMLInputElement>(null);
    const editFileRef = useRef<HTMLInputElement>(null);

    useEffect(() => { loadTeachers(); }, []);

    const loadTeachers = async () => {
        try {
            setLoading(true);
            setError(null);
            const data = await getAllTeachers();
            setTeachers(data);
        } catch (err: any) {
            setError(err?.message || "Failed to load teachers.");
        } finally {
            setLoading(false);
        }
    };

    const handleAdd = async () => {
        const { fullName, email, employeeId, avatarFile } = addForm;
        if (!fullName || !email || !employeeId) {
            setAddError("All fields are required.");
            return;
        }
        try {
            setAddLoading(true);
            setAddError(null);
            // ✅ createTeacher handles: auth + user insert + avatar upload + teacher insert
            await createTeacher(
                fullName,
                email,
                employeeId,
                [],         // subjectIds — empty on create
                [],         // classIds — empty on create
                avatarFile  // ✅ avatar file passed directly
            );
            await loadTeachers();
            setShowAdd(false);
            setAddForm(EMPTY_ADD);
        } catch (err: any) {
            setAddError(err?.message || "Failed to add teacher.");
        } finally {
            setAddLoading(false);
        }
    };

    const openEdit = (teacher: Teacher) => {
        setEditingTeacher(teacher);
        setEditForm({
            employeeId: teacher.employeeId,
            avatarFile: null,
            avatarPreview: teacher.avatarPath,
        });
        setEditError(null);
    };

    const handleEdit = async () => {
        if (!editingTeacher) return;
        if (!editForm.employeeId) {
            setEditError("Employee ID is required.");
            return;
        }
        try {
            setEditLoading(true);
            setEditError(null);

            let avatarPath = editingTeacher.avatarPath;

            // ✅ Upload new avatar if selected
            if (editForm.avatarFile) {
                avatarPath = await uploadTeacherAvatar(editingTeacher.id, editForm.avatarFile);
            }

            await updateTeacher(editingTeacher.id, {
                employeeId: editForm.employeeId,
                avatarPath,
            });

            await loadTeachers();
            setEditingTeacher(null);
        } catch (err: any) {
            setEditError(err?.message || "Failed to update teacher.");
        } finally {
            setEditLoading(false);
        }
    };

    const handleDelete = async () => {
        if (!deletingId) return;
        try {
            setDeleteLoading(true);
            await deleteTeacher(deletingId);
            await loadTeachers();
            setDeletingId(null);
        } catch (err: any) {
            setError(err?.message || "Failed to delete teacher.");
            setDeletingId(null);
        } finally {
            setDeleteLoading(false);
        }
    };

    const AvatarPlaceholder = ({ name }: { name: string }) => (
        <div style={styles.avatarPlaceholder}>
            {name?.charAt(0).toUpperCase() || '?'}
        </div>
    );

    return (
        <div style={styles.page}>
            <div style={styles.header}>
                <h1 style={styles.title}>Teachers</h1>
                <button style={styles.addBtn} onClick={() => { setShowAdd(true); setAddError(null); }}>
                    + Add New
                </button>
            </div>

            {error && <div style={styles.errorBanner}>{error}</div>}

            {loading ? (
                <div style={styles.center}>Loading...</div>
            ) : teachers.length === 0 ? (
                <div style={styles.center}>No teachers found.</div>
            ) : (
                <div style={styles.tableWrap}>
                    <table style={styles.table}>
                        <thead>
                            <tr>
                                {["Teacher", "Employee ID", "Subjects", "Classes", "Actions"].map((h) => (
                                    <th key={h} style={styles.th}>{h}</th>
                                ))}
                            </tr>
                        </thead>
                        <tbody>
                            {teachers.map((teacher) => (
                                <tr key={teacher.id} style={styles.tr}>
                                    <td style={styles.td}>
                                        <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                                            {teacher.avatarPath ? (
                                                <img
                                                    src={teacher.avatarPath}
                                                    alt={teacher.fullName}
                                                    style={styles.avatar}
                                                />
                                            ) : (
                                                <AvatarPlaceholder name={teacher.fullName} />
                                            )}
                                            <div>
                                                <div style={styles.teacherName}>
                                                    {teacher.fullName || "Unnamed Teacher"}
                                                </div>
                                                <div style={styles.teacherEmail}>{teacher.email}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td style={styles.td}>{teacher.employeeId}</td>
                                    <td style={styles.td}>
                                        {teacher.subjectIds?.length > 0
                                            ? `${teacher.subjectIds.length} subjects`
                                            : <span style={styles.muted}>None</span>}
                                    </td>
                                    <td style={styles.td}>
                                        {teacher.classIds?.length > 0
                                            ? `${teacher.classIds.length} classes`
                                            : <span style={styles.muted}>None</span>}
                                    </td>
                                    <td style={styles.td}>
                                        <button style={styles.editBtn} onClick={() => openEdit(teacher)}>✏</button>
                                        <button style={styles.deleteBtn} onClick={() => setDeletingId(teacher.id)}>🗑</button>
                                    </td>
                                </tr>
                            ))}
                        </tbody>
                    </table>
                </div>
            )}

            {/* ADD MODAL */}
            {showAdd && (
                <div style={styles.overlay}>
                    <div style={styles.modal}>
                        <h2 style={styles.modalTitle}>Add New Teacher</h2>
                        {addError && <div style={styles.errorBanner}>{addError}</div>}

                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Profile Photo</label>
                            <div style={styles.avatarUploadWrap}>
                                {addForm.avatarPreview ? (
                                    <img src={addForm.avatarPreview} alt="preview" style={styles.avatarPreview} />
                                ) : (
                                    <div style={styles.avatarPlaceholderLg}>
                                        {addForm.fullName?.charAt(0).toUpperCase() || '?'}
                                    </div>
                                )}
                                <div>
                                    <button
                                        style={styles.uploadBtn}
                                        type="button"
                                        onClick={() => addFileRef.current?.click()}
                                    >
                                        {addForm.avatarFile ? '✅ ' + addForm.avatarFile.name : 'Choose Photo'}
                                    </button>
                                    <input
                                        type="file"
                                        ref={addFileRef}
                                        hidden
                                        accept="image/*"
                                        onChange={(e) => {
                                            const file = e.target.files?.[0] || null;
                                            setAddForm({
                                                ...addForm,
                                                avatarFile: file,
                                                avatarPreview: file ? URL.createObjectURL(file) : null,
                                            });
                                        }}
                                    />
                                    <p style={{ fontSize: 11, color: '#888', marginTop: 4 }}>
                                        Optional — JPG, PNG
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Full Name *</label>
                            <input
                                style={styles.input}
                                value={addForm.fullName}
                                onChange={(e) => setAddForm({ ...addForm, fullName: e.target.value })}
                                placeholder="e.g. John Doe"
                            />
                        </div>
                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Email *</label>
                            <input
                                style={styles.input}
                                type="email"
                                value={addForm.email}
                                onChange={(e) => setAddForm({ ...addForm, email: e.target.value })}
                                placeholder="e.g. john@school.com"
                            />
                        </div>
                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Employee ID *</label>
                            <input
                                style={styles.input}
                                value={addForm.employeeId}
                                onChange={(e) => setAddForm({ ...addForm, employeeId: e.target.value })}
                                placeholder="e.g. EMP001"
                            />
                        </div>

                        <div style={styles.modalActions}>
                            <button style={styles.cancelBtn} onClick={() => { setShowAdd(false); setAddForm(EMPTY_ADD); }}>
                                Cancel
                            </button>
                            <button style={styles.addBtn} onClick={handleAdd} disabled={addLoading}>
                                {addLoading ? "Saving..." : "Save"}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* EDIT MODAL */}
            {editingTeacher && (
                <div style={styles.overlay}>
                    <div style={styles.modal}>
                        <h2 style={styles.modalTitle}>Edit Teacher</h2>
                        {editError && <div style={styles.errorBanner}>{editError}</div>}

                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Profile Photo</label>
                            <div style={styles.avatarUploadWrap}>
                                {editForm.avatarPreview ? (
                                    <img src={editForm.avatarPreview} alt="preview" style={styles.avatarPreview} />
                                ) : (
                                    <div style={styles.avatarPlaceholderLg}>
                                        {editingTeacher.fullName?.charAt(0).toUpperCase() || '?'}
                                    </div>
                                )}
                                <div>
                                    <button
                                        style={styles.uploadBtn}
                                        type="button"
                                        onClick={() => editFileRef.current?.click()}
                                    >
                                        {editForm.avatarFile ? '✅ ' + editForm.avatarFile.name : 'Change Photo'}
                                    </button>
                                    <input
                                        type="file"
                                        ref={editFileRef}
                                        hidden
                                        accept="image/*"
                                        onChange={(e) => {
                                            const file = e.target.files?.[0] || null;
                                            setEditForm({
                                                ...editForm,
                                                avatarFile: file,
                                                avatarPreview: file ? URL.createObjectURL(file) : editForm.avatarPreview,
                                            });
                                        }}
                                    />
                                    <p style={{ fontSize: 11, color: '#888', marginTop: 4 }}>
                                        Choose to change photo
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div style={styles.fieldWrap}>
                            <label style={styles.label}>Employee ID *</label>
                            <input
                                style={styles.input}
                                value={editForm.employeeId}
                                onChange={(e) => setEditForm({ ...editForm, employeeId: e.target.value })}
                                placeholder="e.g. EMP001"
                            />
                        </div>

                        <div style={styles.modalActions}>
                            <button style={styles.cancelBtn} onClick={() => setEditingTeacher(null)}>Cancel</button>
                            <button style={styles.addBtn} onClick={handleEdit} disabled={editLoading}>
                                {editLoading ? "Saving..." : "Save Changes"}
                            </button>
                        </div>
                    </div>
                </div>
            )}

            {/* DELETE MODAL */}
            {deletingId && (
                <div style={styles.overlay}>
                    <div style={{ ...styles.modal, maxWidth: 380 }}>
                        <h2 style={styles.modalTitle}>Delete Teacher?</h2>
                        <p style={{ color: "#555", marginBottom: 24 }}>
                            This will remove the teacher, their account and auth login.
                        </p>
                        <div style={styles.modalActions}>
                            <button style={styles.cancelBtn} onClick={() => setDeletingId(null)}>Cancel</button>
                            <button style={styles.deleteConfirmBtn} onClick={handleDelete} disabled={deleteLoading}>
                                {deleteLoading ? "Deleting..." : "Delete"}
                            </button>
                        </div>
                    </div>
                </div>
            )}
        </div>
    );
};

export default TeacherPage;

const styles: Record<string, React.CSSProperties> = {
    page: { padding: "32px", fontFamily: "sans-serif", maxWidth: 1000, margin: "0 auto" },
    header: { display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 },
    title: { fontSize: 28, fontWeight: 700, margin: 0 },
    errorBanner: { background: "#fee2e2", color: "#b91c1c", padding: "10px 14px", borderRadius: 8, marginBottom: 16, fontSize: 14 },
    center: { textAlign: "center", padding: "48px 0", color: "#888", fontSize: 15 },
    tableWrap: { overflowX: "auto", borderRadius: 12, border: "1px solid #eee" },
    table: { width: "100%", borderCollapse: "collapse", fontSize: 14 },
    th: { background: "#f8f8f8", padding: "12px 16px", textAlign: "left", fontWeight: 600, color: "#444", borderBottom: "1px solid #eee" },
    tr: { borderBottom: "1px solid #f0f0f0" },
    td: { padding: "12px 16px", color: "#333", verticalAlign: "middle" },
    muted: { color: "#aaa", fontStyle: "italic" },
    avatar: { width: 40, height: 40, borderRadius: "50%", objectFit: "cover", border: "2px solid #e5e7eb" },
    avatarPlaceholder: { width: 40, height: 40, borderRadius: "50%", background: "#f59e0b", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, fontSize: 16 },
    avatarPlaceholderLg: { width: 64, height: 64, borderRadius: "50%", background: "#f59e0b", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, fontSize: 24 },
    avatarPreview: { width: 64, height: 64, borderRadius: "50%", objectFit: "cover", border: "2px solid #e5e7eb" },
    avatarUploadWrap: { display: "flex", alignItems: "center", gap: 16, marginBottom: 8 },
    uploadBtn: { background: "#f3f4f6", border: "1px solid #ddd", borderRadius: 8, padding: "8px 16px", cursor: "pointer", fontSize: 13, fontWeight: 600 },
    teacherName: { fontWeight: 600, fontSize: 14 },
    teacherEmail: { fontSize: 12, color: "#888" },
    editBtn: { background: "none", border: "1px solid #ddd", borderRadius: 6, padding: "6px 10px", cursor: "pointer", marginRight: 8, fontSize: 14 },
    deleteBtn: { background: "none", border: "1px solid #fca5a5", borderRadius: 6, padding: "6px 10px", cursor: "pointer", fontSize: 14 },
    addBtn: { background: "#f59e0b", color: "#fff", border: "none", borderRadius: 8, padding: "10px 20px", fontWeight: 600, cursor: "pointer", fontSize: 14 },
    cancelBtn: { background: "#f3f4f6", color: "#333", border: "none", borderRadius: 8, padding: "10px 20px", fontWeight: 600, cursor: "pointer", fontSize: 14 },
    deleteConfirmBtn: { background: "#ef4444", color: "#fff", border: "none", borderRadius: 8, padding: "10px 20px", fontWeight: 600, cursor: "pointer", fontSize: 14 },
    overlay: { position: "fixed", inset: 0, background: "rgba(0,0,0,0.4)", display: "flex", alignItems: "center", justifyContent: "center", zIndex: 1000 },
    modal: { background: "#fff", borderRadius: 16, padding: 32, width: "100%", maxWidth: 480, boxShadow: "0 20px 60px rgba(0,0,0,0.15)", maxHeight: "90vh", overflowY: "auto" },
    modalTitle: { fontSize: 20, fontWeight: 700, marginBottom: 20, marginTop: 0 },
    fieldWrap: { marginBottom: 16 },
    label: { display: "block", fontSize: 13, fontWeight: 600, color: "#555", marginBottom: 6 },
    input: { width: "100%", padding: "10px 12px", borderRadius: 8, border: "1px solid #ddd", fontSize: 14, boxSizing: "border-box", outline: "none" },
    modalActions: { display: "flex", justifyContent: "flex-end", gap: 12, marginTop: 24 },
};