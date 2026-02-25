import express from 'express';

const app = express();
const PORT = process.env.PORT || 8080;

app.get('/api/test', (req, res) => {
  res.json({ 
    message: 'Test server is running!',
    timestamp: new Date().toISOString(),
    env: process.env.NODE_ENV
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Test server running on port ${PORT}`);
  console.log(`🔧 Environment: ${process.env.NODE_ENV}`);
  console.log(`🔧 PORT: ${PORT}`);
});
