import React, { useEffect, useState } from "react";
import { Classroom } from "../models/classroom";
import { fetchClassrooms } from "../controllers/classroomController";  

const ClassroomPage: React.FC = () => {
  const [classrooms, setClassrooms] = useState<Classroom[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadClassrooms();
  }, []);

  const loadClassrooms = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchClassrooms();  // use controller
      setClassrooms(data);
    } catch (err) {
      setError("Failed to load classrooms. Please try again.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading classrooms...</div>;
  if (error) return <div style={{ color: "red" }}>{error}</div>;
  if (classrooms.length === 0) return <div>No classrooms found.</div>;

  return (
    <div>
      <h2>Classroom List</h2>
      <table border={1}>
        <thead>
          <tr>
            <th>Name</th>
            <th>Faculty</th>
            <th>Start Year</th>
            <th>End Year</th>
            <th>Status</th>
          </tr>
        </thead>
        <tbody>
          {classrooms.map((classroom) => (
            <tr key={classroom.id ?? classroom.name}>  {/* null-safe key */}
              <td>{classroom.name}</td>
              <td>{classroom.faculty}</td>
              <td>{classroom.startYear}</td>
              <td>{classroom.endYear}</td>
              <td>{classroom.isActive ? "Active" : "Inactive"}</td>  {/*fixed isActive */}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ClassroomPage;