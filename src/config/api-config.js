// API Configuration - Easy switching between local and hosting environments

export const API_CONFIG = {
  // 🏠 Local Development
  LOCAL: {
    API_BASE: '/api',
    BASE_URL: 'http://localhost:5001',
    DESCRIPTION: 'Local development server'
  },
  
  // 🚀 Production Hosting
  PRODUCTION: {
    API_BASE: 'https://your-domain.com/api',
    BASE_URL: 'https://your-domain.com',
    DESCRIPTION: 'Production hosting server'
  },
  
  // 🧪 Testing/Staging
  STAGING: {
    API_BASE: 'https://staging.your-domain.com/api',
    BASE_URL: 'https://staging.your-domain.com',
    DESCRIPTION: 'Staging testing server'
  }
};

// Current environment selector
export const CURRENT_ENV = import.meta.env.PROD ? 'PRODUCTION' : 'LOCAL';

// Get current API configuration
export const getAPIConfig = () => {
  return API_CONFIG[CURRENT_ENV];
};

// Quick switch function for development
export const switchEnvironment = (env) => {
  if (!API_CONFIG[env]) {
    console.error(`Environment ${env} not found. Available: ${Object.keys(API_CONFIG).join(', ')}`);
    return API_CONFIG.LOCAL;
  }
  return API_CONFIG[env];
};

// Export current configuration
export const { API_BASE, BASE_URL, DESCRIPTION } = getAPIConfig();

// Debug info
console.log(`🌐 API Environment: ${CURRENT_ENV}`);
console.log(`📍 API Base: ${API_BASE}`);
console.log(`🏠 Base URL: ${BASE_URL}`);
console.log(`📝 Description: ${DESCRIPTION}`);
