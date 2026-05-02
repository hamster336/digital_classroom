import React, { useEffect, useState } from "react";
import { Student } from "../models/student";
import { fetchStudents } from "../controllers/studentController"; // ✅ use controller

const StudentPage: React.FC = () => {
  const [students, setStudents] = useState<Student[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);   // error state added

  useEffect(() => {
    loadStudents();
  }, []);

  const loadStudents = async () => {   // this avoid conflict
    try {
      setLoading(true);
      setError(null);
      const data = await fetchStudents();   // controller is used
      setStudents(data);
    } catch (err) {
      setError("Failed to load students. Please try again.");
      console.error("Error fetching students:", err);
    } finally {
      setLoading(false);
    }
  };

  // loading state
  if (loading) return <div>Loading students...</div>;

  // error state
  if (error) return <div style={{ color: "red" }}>{error}</div>;

  return (
    <div style={{ padding: "20px" }}>
      <h2>Students List</h2>

      <table
        border={1}
        cellPadding={8}
        style={{ borderCollapse: "collapse", width: "100%" }}
      >
        <thead>
          <tr>
            <th>Roll No</th>
            <th>Class ID</th>
            <th>Subjects</th>
            <th>Avatar</th>
            <th>Last Checked Notices</th>
          </tr>
        </thead>

        <tbody>
          {students.length === 0 ? (
            <tr>
              <td colSpan={5} style={{ textAlign: "center" }}>
                No students found
              </td>
            </tr>
          ) : (
            students.map((student) => (
              <tr key={student.id ?? student.rollNo}>  {/* null-safe key */}

                <td>{student.rollNo}</td>

                <td>{student.classId}</td>

                <td>
                  {student.subjectIds.length > 0
                    ? student.subjectIds.join(", ")
                    : "No subjects"}   {/* empty array fallback */}
                </td>

                <td>
                  {student.avatarUrl ? (
                    <img
                      src={student.avatarUrl}
                      alt="avatar"
                      width="40"
                      height="40"
                      style={{ borderRadius: "50%" }}
                    />
                  ) : (
                    "No Image"
                  )}
                </td>

                <td>
                  {student.lastCheckedNotices
                    ? student.lastCheckedNotices.toLocaleDateString()  // UTC→local
                    : "Never"}   {/* null-safe */}
                </td>

              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
};

export default StudentPage;