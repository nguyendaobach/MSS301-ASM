import { useState, useEffect } from 'react';
import { blindBoxAPI } from '../services/api';
import BlindBoxCard from './BlindBoxCard';
import BlindBoxForm from './BlindBoxForm';

function Dashboard({ userRole, onLogout }) {
  const [blindBoxes, setBlindBoxes] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [showForm, setShowForm] = useState(false);
  const [editingBox, setEditingBox] = useState(null);

  const isAdmin = userRole === 1;

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      const [boxesRes, categoriesRes] = await Promise.all([
        blindBoxAPI.getAll(),
        blindBoxAPI.getCategories()
      ]);
      setBlindBoxes(boxesRes.data);
      setCategories(categoriesRes.data);
    } catch (error) {
      console.error('Failed to load data:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleCreate = () => {
    setEditingBox(null);
    setShowForm(true);
  };

  const handleEdit = (box) => {
    setEditingBox(box);
    setShowForm(true);
  };

  const handleDelete = async (id) => {
    if (!window.confirm('Are you sure you want to delete this BlindBox?')) return;

    try {
      await blindBoxAPI.delete(id);
      await loadData();
    } catch (error) {
      alert(error.response?.data || 'Failed to delete');
    }
  };

  const handleFormSubmit = async (data) => {
    try {
      if (editingBox) {
        await blindBoxAPI.update(editingBox.blindBoxID, data);
      } else {
        await blindBoxAPI.create(data);
      }
      setShowForm(false);
      await loadData();
    } catch (error) {
      throw error;
    }
  };

  const filteredBoxes = blindBoxes.filter(box =>
    box.name?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  if (loading) {
    return <div className="loading">Loading BlindBoxes...</div>;
  }

  return (
    <div className="dashboard">
      <header className="header">
        <h1>🎁 BlindBox Management System</h1>
        <div className="user-info">
          <span className={`badge ${isAdmin ? 'badge-admin' : 'badge-user'}`}>
            {isAdmin ? 'ADMIN' : 'USER'}
          </span>
          <button className="btn-logout" onClick={onLogout}>
            Logout
          </button>
        </div>
      </header>

      <div className="controls">
        <div className="search-box">
          <input
            type="text"
            placeholder="Search BlindBoxes..."
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
        {isAdmin && (
          <button className="btn btn-primary" onClick={handleCreate}>
            + Add New BlindBox
          </button>
        )}
      </div>

      {filteredBoxes.length === 0 ? (
        <div className="empty-state">
          <h3>No BlindBoxes Found</h3>
          <p>{searchTerm ? 'Try a different search term' : 'Start by adding a new BlindBox'}</p>
        </div>
      ) : (
        <div className="blindbox-grid">
          {filteredBoxes.map(box => (
            <BlindBoxCard
              key={box.blindBoxID}
              box={box}
              isAdmin={isAdmin}
              onEdit={() => handleEdit(box)}
              onDelete={() => handleDelete(box.blindBoxID)}
            />
          ))}
        </div>
      )}

      {showForm && (
        <BlindBoxForm
          box={editingBox}
          categories={categories}
          onSubmit={handleFormSubmit}
          onCancel={() => setShowForm(false)}
        />
      )}
    </div>
  );
}

export default Dashboard;
