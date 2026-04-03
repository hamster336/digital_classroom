import React, { useEffect, useState } from "react";
import { Notice } from "../models/notice";
import { fetchNotices } from "../controllers/noticeController"; // 

const NoticePage: React.FC = () => {
  const [notices, setNotices] = useState<Notice[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    loadNotices();
  }, []);

  const loadNotices = async () => {
    try {
      setLoading(true);
      setError(null);
      const data = await fetchNotices();  
      setNotices(data);
    } catch (err) {
      setError("Failed to load notices. Please try again.");
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  // Loading state
  if (loading) return <div>Loading notices...</div>;

  // error state
  if (error) return <div style={{ color: "red" }}>{error}</div>;

  //Empty state
  if (notices.length === 0) return <div>No notices found.</div>;

  return (
    <div>
      <h2>Notices List</h2>

      <table border={1}>
        <thead>
          <tr>
            <th>Title</th>
            <th>Description</th>
            <th>Priority</th>
            <th>Published At</th>
          </tr>
        </thead>

        <tbody>
          {notices.map((notice) => (
            <tr key={notice.id ?? notice.title}>  {/* null-safe key */}
              <td>{notice.title}</td>
              <td>{notice.description}</td>
              <td>{notice.priority}</td>
              <td>{notice.publishedAt.toDateString()}</td>  {/* safe, publishedAt is always Date */}
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default NoticePage;