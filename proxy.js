const express = require('express');
const { createProxyMiddleware } = require('http-proxy-middleware');
const cors = require('cors');

const app = express();

// Habilitar CORS
app.use(cors());

// Proxy para el backend
app.use('/api', createProxyMiddleware({
  target: 'http://127.0.0.1:8000',
  changeOrigin: true,
  pathRewrite: {
    '^/api': '', // reescribir /api a /
  },
}));

app.listen(3001, () => {
  console.log('Proxy ejecutándose en http://localhost:3001');
});
