import React, { useEffect, useState } from "react";
import { Schedule } from "../models/schedules";
import { fetchSchedules } from "../controllers/scheduleController";  

const SchedulePage: React.FC = () => {
  const [schedules, setSchedules] = useState<Schedule[]>([]);
  const [loading, setLoading] = useState<boolean>(false);
  const [error, setError] = useState<string | null>(null); 

  useEffect(() => {
    loadSchedules();
  }, []);

  const loadSchedules = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchSchedules();  
      setSchedules(data);
    } catch (err) {
      setError("Failed to load schedules. Please try again.");
      console.error("Error loading schedules:", err);
    } finally {
      setLoading(false);
    }
  };

  if (loading) return <div>Loading schedules...</div>;
  if (error) return <div style={{ color: "red" }}>{error}</div>;

  return (
    <div style={{ padding: "20px" }}>
      <h2>Class Schedule</h2>

      <table
        border={1}
        cellPadding={8}
        style={{ borderCollapse: "collapse", width: "100%" }}
      >
        <thead>
          <tr>
            <th>Class ID</th>
            <th>Subject ID</th>
            <th>Day</th>
            <th>Start Time</th>
            <th>End Time</th>
          </tr>
        </thead>

        <tbody>
          {schedules.length === 0 ? (
            <tr>
              <td colSpan={5} style={{ textAlign: "center" }}>
                No schedules found
              </td>
            </tr>
          ) : (
            schedules.map((schedule) => (
              <tr key={schedule.id ?? schedule.classId}>  {/* null-safe key */}
                <td>{schedule.classId}</td>
                <td>{schedule.subjectId}</td>
                <td>{schedule.dayOfWeek}</td>
                <td>{schedule.startTime.slice(0,5)}</td>   {/*"09:00:00"->"09:00" so we have sliced(0,5) */}
                <td>{schedule.endTime.slice(0,5)}</td>     {    }
              </tr>
            ))
          )}
        </tbody>
      </table>
    </div>
  );
};

export default SchedulePage;