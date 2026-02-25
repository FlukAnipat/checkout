// Railway startup wrapper - catches import errors
console.log('🔧 Starting Shwe Flash server...');
console.log('🔧 Node.js version:', process.version);
console.log('🔧 PORT:', process.env.PORT);
console.log('🔧 NODE_ENV:', process.env.NODE_ENV);
console.log('🔧 DATABASE_URL exists:', !!process.env.DATABASE_URL);
console.log('🔧 DB_NAME:', process.env.DB_NAME);
console.log('🔧 DB_HOST:', process.env.DB_HOST);

try {
  await import('./server/server.js');
} catch (err) {
  console.error('❌ Failed to start server:', err.message);
  console.error('❌ Stack:', err.stack);
  
  // Keep process alive so Railway shows the error in logs
  setInterval(() => {
    console.log('⚠️ Server failed to start. Waiting for redeploy...');
  }, 30000);
}
