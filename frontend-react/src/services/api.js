import axios from 'axios';

const API_BASE_URL = 'http://localhost:8080';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json'
  }
});

// Interceptor để thêm token vào mọi request
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Account Service
export const accountAPI = {
  login: (credentials) => api.post('/api/account/login', credentials),
  validateToken: (token) => api.post('/api/account/validate', {}, {
    headers: { Authorization: `Bearer ${token}` }
  })
};

// BlindBox Service
export const blindBoxAPI = {
  getAll: () => api.get('/api/blindboxes'),
  create: (data) => api.post('/api/blindboxes', data),
  update: (id, data) => api.put(`/api/blindboxes/${id}`, data),
  delete: (id) => api.delete(`/api/blindboxes/${id}`),
  getCategories: () => api.get('/api/blindboxes/categories')
};

// Brand Service
export const brandAPI = {
  validate: (id) => api.get(`/api/brand/validate/${id}`)
};

export default api;
