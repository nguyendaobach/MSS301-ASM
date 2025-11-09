import { useState, useEffect } from 'react';

function BlindBoxForm({ box, categories, onSubmit, onCancel }) {
  const [formData, setFormData] = useState({
    name: '',
    categoryId: '',
    brandId: '',
    rarity: 'Common',
    price: '',
    stock: '',
    releaseDate: ''
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    if (box) {
      setFormData({
        name: box.name || '',
        categoryId: box.category?.categoryID || '',
        brandId: box.brandID || '',
        rarity: box.rarity || 'Common',
        price: box.price || '',
        stock: box.stock || '',
        releaseDate: box.releaseDate || ''
      });
    }
  }, [box]);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);

    try {
      const payload = {
        name: formData.name,
        categoryId: parseInt(formData.categoryId),
        brandId: parseInt(formData.brandId),
        rarity: formData.rarity,
        price: parseFloat(formData.price),
        stock: parseInt(formData.stock),
        releaseDate: formData.releaseDate
      };

      await onSubmit(payload);
    } catch (err) {
      setError(err.response?.data || 'Failed to save BlindBox');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="modal-overlay" onClick={onCancel}>
      <div className="modal" onClick={(e) => e.stopPropagation()}>
        <h2>{box ? 'Edit BlindBox' : 'Create New BlindBox'}</h2>

        {error && <div className="error-message">{error}</div>}

        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Name *</label>
            <input
              type="text"
              name="name"
              value={formData.name}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label>Category *</label>
            <select
              name="categoryId"
              value={formData.categoryId}
              onChange={handleChange}
              required
            >
              <option value="">Select Category</option>
              {categories.map(cat => (
                <option key={cat.categoryID} value={cat.categoryID}>
                  {cat.name}
                </option>
              ))}
            </select>
          </div>

          <div className="form-group">
            <label>Brand ID *</label>
            <input
              type="number"
              name="brandId"
              value={formData.brandId}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label>Rarity *</label>
            <select
              name="rarity"
              value={formData.rarity}
              onChange={handleChange}
              required
            >
              <option value="Common">Common</option>
              <option value="Rare">Rare</option>
              <option value="Epic">Epic</option>
              <option value="Legendary">Legendary</option>
            </select>
          </div>

          <div className="form-group">
            <label>Price ($) *</label>
            <input
              type="number"
              step="0.01"
              name="price"
              value={formData.price}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label>Stock *</label>
            <input
              type="number"
              name="stock"
              value={formData.stock}
              onChange={handleChange}
              required
            />
          </div>

          <div className="form-group">
            <label>Release Date *</label>
            <input
              type="date"
              name="releaseDate"
              value={formData.releaseDate}
              onChange={handleChange}
              required
            />
          </div>

          <div className="modal-actions">
            <button type="button" className="btn btn-secondary" onClick={onCancel}>
              Cancel
            </button>
            <button type="submit" className="btn btn-primary" disabled={loading}>
              {loading ? 'Saving...' : (box ? 'Update' : 'Create')}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}

export default BlindBoxForm;
