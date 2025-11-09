function BlindBoxCard({ box, isAdmin, onEdit, onDelete }) {
  const getRarityClass = (rarity) => {
    const rarityLower = rarity?.toLowerCase() || '';
    if (rarityLower.includes('legendary')) return 'rarity-legendary';
    if (rarityLower.includes('epic')) return 'rarity-epic';
    if (rarityLower.includes('rare')) return 'rarity-rare';
    return 'rarity-common';
  };

  return (
    <div className="blindbox-card">
      <div className="card-image">
        🎁
      </div>
      <div className="card-body">
        <h3 className="card-title">{box.name}</h3>
        
        <div className="card-info">
          <div className="info-row">
            <span className="info-label">Category:</span>
            <span>{box.category?.name || 'N/A'}</span>
          </div>
          <div className="info-row">
            <span className="info-label">Rarity:</span>
            <span className={`rarity ${getRarityClass(box.rarity)}`}>
              {box.rarity || 'Common'}
            </span>
          </div>
          <div className="info-row">
            <span className="info-label">Stock:</span>
            <span>{box.stock || 0} units</span>
          </div>
          <div className="info-row">
            <span className="info-label">Release:</span>
            <span>{box.releaseDate || 'N/A'}</span>
          </div>
          <div className="info-row">
            <span className="info-label">Brand ID:</span>
            <span>#{box.brandID}</span>
          </div>
        </div>

        <div className="price">${box.price?.toFixed(2) || '0.00'}</div>

        {isAdmin && (
          <div className="card-actions">
            <button className="btn btn-success btn-small" onClick={onEdit}>
              Edit
            </button>
            <button className="btn btn-danger btn-small" onClick={onDelete}>
              Delete
            </button>
          </div>
        )}
      </div>
    </div>
  );
}

export default BlindBoxCard;
