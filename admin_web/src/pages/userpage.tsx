import React, { useEffect, useState } from "react";
import { user } from "../models/user";
import { getUsers } from "../supabase/user";

const UsersPage: React.FC = () => {

  const [users, setUsers] = useState<user[]>([]);

  useEffect(() => {
    loadUsers();
  }, []);

  const loadUsers = async () => {
    const data = await getUsers();
    setUsers(data);
  };

  return (
    <div>
      <h2>Users List</h2>

      <table border={1}>
        <thead>
          <tr>
            <th>Full Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Created At</th>
          </tr>
        </thead>

        <tbody>
          {users.map((user) => (
            <tr key={user.id}>
              <td>{user.full_name}</td>
              <td>{user.email}</td>
              <td>{user.role}</td>
              <td>{user.created_at.toDateString()}</td>
            </tr>
          ))}
        </tbody>

      </table>
    </div>
  );
};

export default UsersPage;