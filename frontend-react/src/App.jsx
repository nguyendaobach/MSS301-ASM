import { useState } from 'react';
import './App.css';
import Login from './components/Login';
import Dashboard from './components/Dashboard';

function App() {
  const [isLoggedIn, setIsLoggedIn] = useState(!!localStorage.getItem('token'));
  const [userRole, setUserRole] = useState(parseInt(localStorage.getItem('role') || '0'));

  const handleLogin = (token, role) => {
    localStorage.setItem('token', token);
    localStorage.setItem('role', role);
    setUserRole(role);
    setIsLoggedIn(true);
  };

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('role');
    setIsLoggedIn(false);
    setUserRole(0);
  };

  return (
    <>
      {!isLoggedIn ? (
        <Login onLogin={handleLogin} />
      ) : (
        <Dashboard userRole={userRole} onLogout={handleLogout} />
      )}
    </>
  );
}

export default App;
