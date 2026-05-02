import React, { useEffect, useState } from "react";
import { Subject } from "../models/subject";
import { fetchSubject } from "../controllers/subjectController";  

const SubjectsPage: React.FC = () => {
  const [subjects, setSubjects] = useState<Subject[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null);  // error state

  useEffect(() => {
    loadSubjects();
  }, []);

  const loadSubjects = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchSubject();   
      setSubjects(data);
    } catch (err) {
      setError("Failed to load subject. Please try again.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading subject...</div>;
  if (error) return <div style={{ color: "red" }}>{error}</div>;
  if (subjects.length === 0) return <div>No subject found.</div>;

  return (
    <div style={{ padding: "20px" }}>
      <h2>Subjects List</h2>

      <table
        border={1}
        cellPadding={8}
        style={{ borderCollapse: "collapse", width: "100%" }}
      >
        <thead>
          <tr>
            <th>Name</th>
            <th>Class ID</th>
            <th>Teacher ID</th>
          </tr>
        </thead>

        <tbody>
          {subjects.map((subject) => (
            <tr key={subject.id ?? subject.name}>  {/* null-safe key */}
              <td>{subject.name}</td>
              <td>{subject.classId}</td>
              <td>{subject.teacherId}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default SubjectsPage;