import React, { useEffect, useState } from "react";
import { Teacher } from "../models/teacher";
import { fetchTeachers } from "../controllers/teacherController";

const TeacherPage: React.FC = () => {
  const [teachers, setTeachers] = useState<Teacher[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null); 

  useEffect(() => {
    loadTeachers();
  }, []);

  const loadTeachers = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchTeachers();
      setTeachers(data);
    } catch (err) {
      setError("Failed to load teachers. Please try again.");
      console.error("Error fetching teachers:", err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading teachers...</div>;
  if (error) return <div style={{ color: "red" }}>{error}</div>;
  if (teachers.length === 0) return <div>No teachers found.</div>;

  return (
    <div style={{ padding: "20px" }}>
      <h2>Teachers List</h2>

      <table
        border={1}
        cellPadding={8}
        style={{ borderCollapse: "collapse", width: "100%" }}
      >
        <thead>
          <tr>
            <th>Employee ID</th>
            <th>Subject IDs</th>
            <th>Class IDs</th>
            <th>Avatar</th>
            <th>Last Checked Notices</th>
          </tr>
        </thead>

        <tbody>
          {teachers.map((teacher) => (
            <tr key={teacher.id ?? teacher.employeeId}>

              <td>{teacher.employeeId}</td> {/*  fixed: removed stray { } */}

              <td>
                {teacher.subjectIds.length > 0
                  ? teacher.subjectIds.join(", ")
                  : "No subjects"}
              </td>

              <td>
                {teacher.classIds.length > 0
                  ? teacher.classIds.join(", ")
                  : "No classes"}
              </td>

              <td>
                {teacher.avatarUrl ? (
                  <img
                    src={teacher.avatarUrl}
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
                {teacher.lastCheckedNotices
                  ? teacher.lastCheckedNotices.toLocaleString()
                  : "Never"}
              </td>

            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default TeacherPage;