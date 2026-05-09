import { Navigate, Route, BrowserRouter as Router, Routes } from 'react-router-dom';
import { AdminLayout } from './components/layout/AdminLayout';
import { AuthProvider } from './context/AuthContext';
import { DataProvider } from './context/DataContext';
import { LoginPage } from './features/auth/LoginPage';
import { SignupPage } from './features/auth/SignupPage';
import { Dashboard } from './features/dashboard/Dashboard';
import {
  ClassroomManagement,
  NoticeManagement,
  SubjectManagement
} from './features/management/Entities';
import {
  StudentManagement,
  TeacherManagement
} from './features/management/Users';
import { ProfilePage } from './features/profile/ProfilePage';
import SchedulePage from './pages/schedulespage';
import { SettingsPage } from './features/settings/SettingsPage';

function AppRoutes() {
  return (
    <Routes>
      <Route path="/login" element={<LoginPage />} />
      <Route path="/signup" element={<SignupPage />} />

      <Route path="/" element={<AdminLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<Dashboard />} />
        <Route path="classrooms" element={<ClassroomManagement />} />
        <Route path="subjects" element={<SubjectManagement />} />
        <Route path="teachers" element={<TeacherManagement />} />
        <Route path="students" element={<StudentManagement />} />
        <Route path="notices" element={<NoticeManagement />} />
        <Route path="schedules" element={<SchedulePage />} />
        <Route path="profile" element={<ProfilePage />} />
        <Route path="settings" element={<SettingsPage />} />
        <Route path="*" element={<div className="p-8 text-center text-xl">404 - Page Not Found</div>} />
      </Route>
    </Routes>
  );
}

function App() {
  return (
    <Router>
      <AuthProvider>
        <DataProvider>
          <AppRoutes />
        </DataProvider>
      </AuthProvider>
    </Router>
  );
}

export default App;