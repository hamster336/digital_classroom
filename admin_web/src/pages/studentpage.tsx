import { useEffect, useState } from "react";
import { Student } from "../models/student";
import {
  createStudent,
  getAllStudents,
  updateStudent,
  deleteStudent,
} from "../controllers/studentController";
import { signUpUser } from "../controllers/userController";

interface AddForm {
  fullName: string;
  email: string;
  rollNumber: string;
  classId: string;
}

interface EditForm {
  rollNumber: string;
  classId: string;
  avatarPath: string;
}

const EMPTY_ADD: AddForm = { fullName: "", email: "", rollNumber: "", classId: "" };
const EMPTY_EDIT: EditForm = { rollNumber: "", classId: "", avatarPath: "" };

export default function StudentPage() {
  const [students, setStudents] = useState<Student[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [search, setSearch] = useState("");

  const [showAdd, setShowAdd] = useState(false);
  const [addForm, setAddForm] = useState<AddForm>(EMPTY_ADD);
  const [addLoading, setAddLoading] = useState(false);
  const [addError, setAddError] = useState<string | null>(null);

  const [editingStudent, setEditingStudent] = useState<Student | null>(null);
  const [editForm, setEditForm] = useState<EditForm>(EMPTY_EDIT);
  const [editLoading, setEditLoading] = useState(false);
  const [editError, setEditError] = useState<string | null>(null);

  const [deletingId, setDeletingId] = useState<string | null>(null);
  const [deleteLoading, setDeleteLoading] = useState(false);

  const loadStudents = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await getAllStudents();
      setStudents(data);
    } catch (err: any) {
      setError(err?.message || "Failed to fetch students.");
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => { loadStudents(); }, []);

  const filtered = students.filter((s) =>
    s.rollNumber.toLowerCase().includes(search.toLowerCase())
  );

  const handleAdd = async () => {
    const { fullName, email, rollNumber, classId } = addForm;
    if (!fullName || !email || !rollNumber || !classId) {
      setAddError("All fields are required.");
      return;
    }
    try {
      setAddLoading(true);
      setAddError(null);

      const newUser = await signUpUser(fullName, email, 'student');
      await createStudent(newUser.id, rollNumber, [], classId, null);

      await loadStudents();
      setShowAdd(false);
      setAddForm(EMPTY_ADD);
    } catch (err: any) {
      setAddError(err?.message || "Failed to add student.");
    } finally {
      setAddLoading(false);
    }
  };

  const openEdit = (student: Student) => {
    setEditingStudent(student);
    setEditForm({
      rollNumber: student.rollNumber,
      classId: student.classId,
      avatarPath: student.avatarPath || "",
    });
    setEditError(null);
  };

  const handleEdit = async () => {
    if (!editingStudent) return;
    if (!editForm.rollNumber || !editForm.classId) {
      setEditError("Roll number and class are required.");
      return;
    }
    try {
      setEditLoading(true);
      setEditError(null);

      await updateStudent(editingStudent.id, {
        rollNumber: editForm.rollNumber,
        classId: editForm.classId,
        avatarPath: editForm.avatarPath || null,
      });
      await loadStudents();
      setEditingStudent(null);
    } catch (err: any) {
      setEditError(err?.message || "Failed to update student.");
    } finally {
      setEditLoading(false);
    }
  };

  const handleDelete = async () => {
    if (!deletingId) return;
    try {
      setDeleteLoading(true);
      await deleteStudent(deletingId);
      await loadStudents();
      setDeletingId(null);
    } catch (err: any) {
      setError(err?.message || "Failed to delete student.");
      setDeletingId(null);
    } finally {
      setDeleteLoading(false);
    }
  };

  return (
    <div style={styles.page}>
      <div style={styles.header}>
        <h1 style={styles.title}>Students</h1>
        <button style={styles.addBtn} onClick={() => { setShowAdd(true); setAddError(null); }}>
          + Add New
        </button>
      </div>

      <div style={styles.searchWrap}>
        <input
          style={styles.search}
          placeholder="Search by roll number..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
        />
      </div>

      {error && <div style={styles.errorBanner}>{error}</div>}

      {loading ? (
        <div style={styles.center}>Loading...</div>
      ) : filtered.length === 0 ? (
        <div style={styles.center}>No students found.</div>
      ) : (
        <div style={styles.tableWrap}>
          <table style={styles.table}>
            <thead>
              <tr>
                {["Roll No", "Class", "Subjects", "Avatar", "Actions"].map((h) => (
                  <th key={h} style={styles.th}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody>
              {filtered.map((student) => (
                <tr key={student.id} style={styles.tr}>
                  <td style={styles.td}>{student.rollNumber}</td>
                  <td style={styles.td}>{student.classId}</td>
                  <td style={styles.td}>
                    {student.subjectIds.length > 0
                      ? student.subjectIds.length + " subject(s)"
                      : <span style={styles.muted}>None</span>}
                  </td>
                  <td style={styles.td}>
                    {student.avatarPath ? (
                      <img src={student.avatarPath} alt="avatar" style={styles.avatar} />
                    ) : (
                      <div style={styles.avatarPlaceholder}>
                        {student.rollNumber.charAt(0).toUpperCase()}
                      </div>
                    )}
                  </td>
                  <td style={styles.td}>
                    <button style={styles.editBtn} onClick={() => openEdit(student)}>✏</button>
                    <button style={styles.deleteBtn} onClick={() => setDeletingId(student.id)}>🗑</button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {showAdd && (
        <div style={styles.overlay}>
          <div style={styles.modal}>
            <h2 style={styles.modalTitle}>Add Student</h2>
            {addError && <div style={styles.errorBanner}>{addError}</div>}
            {(["fullName", "email", "rollNumber", "classId"] as (keyof AddForm)[]).map((field) => (
              <div key={field} style={styles.fieldWrap}>
                <label style={styles.label}>
                  {field.replace(/([A-Z])/g, " $1").replace(/\b\w/g, c => c.toUpperCase())}
                </label>
                <input
                  style={styles.input}
                  type={field === "email" ? "email" : "text"}
                  value={addForm[field]}
                  onChange={(e) => setAddForm({ ...addForm, [field]: e.target.value })}
                  placeholder={`Enter ${field.replace(/([A-Z])/g, " $1").toLowerCase()}`}
                />
              </div>
            ))}
            <div style={styles.modalActions}>
              <button style={styles.cancelBtn} onClick={() => { setShowAdd(false); setAddForm(EMPTY_ADD); }}>Cancel</button>
              <button style={styles.addBtn} onClick={handleAdd} disabled={addLoading}>
                {addLoading ? "Adding..." : "Add Student"}
              </button>
            </div>
          </div>
        </div>
      )}

      {editingStudent && (
        <div style={styles.overlay}>
          <div style={styles.modal}>
            <h2 style={styles.modalTitle}>Edit Student</h2>
            {editError && <div style={styles.errorBanner}>{editError}</div>}
            {(["rollNumber", "classId", "avatarPath"] as (keyof EditForm)[]).map((field) => (
              <div key={field} style={styles.fieldWrap}>
                <label style={styles.label}>
                  {field === "avatarPath" ? "Avatar URL" : field.replace(/([A-Z])/g, " $1").replace(/\b\w/g, c => c.toUpperCase())}
                </label>
                <input
                  style={styles.input}
                  type="text"
                  value={editForm[field]}
                  onChange={(e) => setEditForm({ ...editForm, [field]: e.target.value })}
                  placeholder={`Enter ${field.replace(/([A-Z])/g, " $1").toLowerCase()}`}
                />
              </div>
            ))}
            <div style={styles.modalActions}>
              <button style={styles.cancelBtn} onClick={() => setEditingStudent(null)}>Cancel</button>
              <button style={styles.addBtn} onClick={handleEdit} disabled={editLoading}>
                {editLoading ? "Saving..." : "Save Changes"}
              </button>
            </div>
          </div>
        </div>
      )}

      {deletingId && (
        <div style={styles.overlay}>
          <div style={{ ...styles.modal, maxWidth: 380 }}>
            <h2 style={styles.modalTitle}>Delete Student?</h2>
            <p style={{ color: "#555", marginBottom: 24 }}>This action cannot be undone.</p>
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
}

const styles: Record<string, React.CSSProperties> = {
  page: { padding: "32px", fontFamily: "sans-serif", maxWidth: 960, margin: "0 auto" },
  header: { display: "flex", justifyContent: "space-between", alignItems: "center", marginBottom: 24 },
  title: { fontSize: 28, fontWeight: 700, margin: 0 },
  searchWrap: { marginBottom: 20 },
  search: { width: "100%", padding: "10px 14px", borderRadius: 8, border: "1px solid #ddd", fontSize: 14, boxSizing: "border-box", outline: "none" },
  errorBanner: { background: "#fee2e2", color: "#b91c1c", padding: "10px 14px", borderRadius: 8, marginBottom: 16, fontSize: 14 },
  center: { textAlign: "center", padding: "48px 0", color: "#888", fontSize: 15 },
  tableWrap: { overflowX: "auto", borderRadius: 12, border: "1px solid #eee" },
  table: { width: "100%", borderCollapse: "collapse", fontSize: 14 },
  th: { background: "#f8f8f8", padding: "12px 16px", textAlign: "left", fontWeight: 600, color: "#444", borderBottom: "1px solid #eee" },
  tr: { borderBottom: "1px solid #f0f0f0" },
  td: { padding: "12px 16px", color: "#333", verticalAlign: "middle" },
  muted: { color: "#aaa", fontStyle: "italic" },
  avatar: { width: 36, height: 36, borderRadius: "50%", objectFit: "cover" },
  avatarPlaceholder: { width: 36, height: 36, borderRadius: "50%", background: "#6c63ff", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontWeight: 700, fontSize: 14 },
  editBtn: { background: "none", border: "1px solid #ddd", borderRadius: 6, padding: "6px 10px", cursor: "pointer", marginRight: 8, fontSize: 14 },
  deleteBtn: { background: "none", border: "1px solid #fca5a5", borderRadius: 6, padding: "6px 10px", cursor: "pointer", fontSize: 14 },
  addBtn: { background: "#10b981", color: "#fff", border: "none", borderRadius: 8, padding: "10px 20px", fontWeight: 600, cursor: "pointer", fontSize: 14 },
  cancelBtn: { background: "#f3f4f6", color: "#333", border: "none", borderRadius: 8, padding: "10px 20px", fontWeight: 600, cursor: "pointer", fontSize: 14 },
  deleteConfirmBtn: { background: "#ef4444", color: "#fff", border: "none", borderRadius: 8, padding: "10px 20px", fontWeight: 600, cursor: "pointer", fontSize: 14 },
  overlay: { position: "fixed", inset: 0, background: "rgba(0,0,0,0.4)", display: "flex", alignItems: "center", justifyContent: "center", zIndex: 1000 },
  modal: { background: "#fff", borderRadius: 16, padding: 32, width: "100%", maxWidth: 480, boxShadow: "0 20px 60px rgba(0,0,0,0.15)" },
  modalTitle: { fontSize: 20, fontWeight: 700, marginBottom: 20, marginTop: 0 },
  fieldWrap: { marginBottom: 16 },
  label: { display: "block", fontSize: 13, fontWeight: 600, color: "#555", marginBottom: 6 },
  input: { width: "100%", padding: "10px 12px", borderRadius: 8, border: "1px solid #ddd", fontSize: 14, boxSizing: "border-box", outline: "none" },
  modalActions: { display: "flex", justifyContent: "flex-end", gap: 12, marginTop: 24 },
};