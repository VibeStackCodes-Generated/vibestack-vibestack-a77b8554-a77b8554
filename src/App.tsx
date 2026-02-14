import { Routes, Route, Link, useLocation } from 'react-router';
import LoginPage from './pages/login';
import SignupPage from './pages/signup';
import { AuthGuard } from './components/auth-guard';
import { useAuth } from './hooks/use-auth';
import DashboardPage from './pages/dashboard';
import WardsPage from './pages/wards';
import AssignmentsPage from './pages/assignments';
import PatientsPage from './pages/patients';
import ClinicalNotesPage from './pages/clinical_notes';
import { ChatPanel } from './components/chat-panel';
import { LayoutDashboard, Table2, MessageSquare, LogOut, Home } from 'lucide-react';

function Sidebar() {
  const location = useLocation();
  const { signOut } = useAuth();

  return (
    <aside className="w-64 border-r border-border bg-card h-screen flex flex-col shrink-0">
      <div className="p-4 border-b border-border">
        <h1 className="font-bold text-lg tracking-tight">BedFlow Dashboard</h1>
      </div>
      <nav className="flex-1 p-2 space-y-1">
        <Link to="/" className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors ${location.pathname === '/' ? 'bg-accent text-accent-foreground font-medium' : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground'}`}>
          <LayoutDashboard className="h-4 w-4" />
          Dashboard
        </Link>
        <Link to="/wards" className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors ${location.pathname === '/wards' ? 'bg-accent text-accent-foreground font-medium' : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground'}`}>
          <Table2 className="h-4 w-4" />
          Wards
        </Link>
        <Link to="/assignments" className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors ${location.pathname === '/assignments' ? 'bg-accent text-accent-foreground font-medium' : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground'}`}>
          <Table2 className="h-4 w-4" />
          Assignments
        </Link>
        <Link to="/patients" className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors ${location.pathname === '/patients' ? 'bg-accent text-accent-foreground font-medium' : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground'}`}>
          <Table2 className="h-4 w-4" />
          Patients
        </Link>
        <Link to="/clinical_notes" className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors ${location.pathname === '/clinical_notes' ? 'bg-accent text-accent-foreground font-medium' : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground'}`}>
          <Table2 className="h-4 w-4" />
          ClinicalNotes
        </Link>
        <Link to="/messages" className={`flex items-center gap-3 rounded-lg px-3 py-2 text-sm transition-colors ${location.pathname === '/messages' ? 'bg-accent text-accent-foreground font-medium' : 'text-muted-foreground hover:bg-accent/50 hover:text-foreground'}`}>
          <MessageSquare className="h-4 w-4" />
          Messages
        </Link>
      </nav>
      <div className="p-2 border-t border-border">
        <button onClick={() => signOut()} className="flex items-center gap-3 rounded-lg px-3 py-2 text-sm text-muted-foreground hover:bg-accent/50 hover:text-foreground w-full transition-colors">
          <LogOut className="h-4 w-4" />
          Sign out
        </button>
      </div>
    </aside>
  );
}

function ProtectedLayout() {
  return (
    <AuthGuard>
      <div className="flex h-screen">
        <Sidebar />
        <main className="flex-1 overflow-auto">
          <Routes>
            <Route path="/" element={<DashboardPage />} />
            <Route path="/wards" element={<WardsPage />} />
            <Route path="/assignments" element={<AssignmentsPage />} />
            <Route path="/patients" element={<PatientsPage />} />
            <Route path="/clinical_notes" element={<ClinicalNotesPage />} />
            <Route path="/messages" element={<ChatPanel />} />
          </Routes>
        </main>
      </div>
    </AuthGuard>
  );
}

export default function App() {
  return (
    <div className="min-h-screen bg-background text-foreground">
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route path="/signup" element={<SignupPage />} />
        <Route path="/*" element={<ProtectedLayout />} />
      </Routes>
    </div>
  );
}
