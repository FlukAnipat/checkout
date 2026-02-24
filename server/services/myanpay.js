import crypto from 'crypto';

// MyanMyanPay configuration
const MYANPAY_CONFIG = {
  appId: process.env.MYANPAY_APP_ID || 'MM_SANDBOX_123',
  publishableKey: process.env.MYANPAY_PUBLISHABLE_KEY || 'pk_test_sandbox_key',
  secretKey: process.env.MYANPAY_SECRET_KEY || 'sk_test_sandbox_key',
  apiBaseUrl: process.env.MYANPAY_API_BASE_URL || 'https://api.sandbox.myanmyanpay.com',
  webhookSecret: process.env.MYANPAY_WEBHOOK_SECRET || 'wh_sandbox_secret',
};

/**
 * Create payment with MyanMyanPay unified gateway
 */
export async function createMyanMyanPayPayment({ orderId, amount, currency, paymentMethod, userEmail, callbackUrl }) {
  try {
    const payload = {
      orderId,
      amount: Math.round(amount), // MyanMyanPay expects integer amounts
      currency: currency || 'MMK',
      paymentMethod, // Specific wallet (kbzpay, wavepay, etc.)
      customer: {
        email: userEmail,
      },
      callbackUrl,
      returnUrl: `${process.env.BASE_URL || 'http://localhost:3001'}/payment/success`,
      cancelUrl: `${process.env.BASE_URL || 'http://localhost:3001'}/payment/cancel`,
      metadata: {
        application: 'shwe_flash',
        version: '1.0.0',
      },
    };

    // Generate signature
    const signature = generateSignature(payload, MYANPAY_CONFIG.secretKey);
    
    const response = await fetch(`${MYANPAY_CONFIG.apiBaseUrl}/v1/payments`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${MYANPAY_CONFIG.publishableKey}`,
        'X-App-ID': MYANPAY_CONFIG.appId,
        'X-Signature': signature,
      },
      body: JSON.stringify(payload),
    });

    if (!response.ok) {
      const errorData = await response.json();
      throw new Error(`MyanMyanPay API error: ${errorData.message || response.statusText}`);
    }

    const data = await response.json();
    
    return {
      success: true,
      paymentId: data.paymentId,
      qr: data.qrCode || data.qr,
      expiresAt: data.expiresAt,
      paymentUrl: data.paymentUrl,
    };
  } catch (error) {
    console.error('MyanMyanPay payment creation error:', error);
    throw error;
  }
}

/**
 * Verify payment status with MyanMyanPay
 */
export async function verifyMyanMyanPayPayment(paymentId) {
  try {
    const response = await fetch(`${MYANPAY_CONFIG.apiBaseUrl}/v1/payments/${paymentId}`, {
      method: 'GET',
      headers: {
        'Authorization': `Bearer ${MYANPAY_CONFIG.secretKey}`,
        'X-App-ID': MYANPAY_CONFIG.appId,
      },
    });

    if (!response.ok) {
      throw new Error(`MyanMyanPay verification error: ${response.statusText}`);
    }

    const data = await response.json();
    
    return {
      success: true,
      status: data.status, // 'pending', 'completed', 'failed', 'expired'
      amount: data.amount,
      currency: data.currency,
      paymentMethod: data.paymentMethod,
      completedAt: data.completedAt,
      transactionId: data.transactionId,
    };
  } catch (error) {
    console.error('MyanMyanPay payment verification error:', error);
    throw error;
  }
}

/**
 * Generate HMAC signature for MyanMyanPay API requests
 */
function generateSignature(payload, secretKey) {
  const timestamp = Date.now().toString();
  const payloadString = JSON.stringify(payload);
  const message = `${timestamp}.${payloadString}`;
  
  return crypto
    .createHmac('sha256', secretKey)
    .update(message)
    .digest('hex');
}

/**
 * Verify webhook signature from MyanMyanPay
 */
export function verifyWebhookSignature(payload, signature, secret = MYANPAY_CONFIG.webhookSecret) {
  const expectedSignature = crypto
    .createHmac('sha256', secret)
    .update(JSON.stringify(payload))
    .digest('hex');
  
  return crypto.timingSafeEqual(
    Buffer.from(signature, 'hex'),
    Buffer.from(expectedSignature, 'hex')
  );
}

/**
 * Get supported MyanmarPay providers
 */
export function getMyanmarPayProviders() {
  return [
    {
      id: 'kbzpay',
      name: 'KBZ Pay',
      description: 'KBZ Bank mobile wallet',
      supported: true,
    },
    {
      id: 'wavepay',
      name: 'Wave Pay',
      description: 'Wave Money mobile wallet',
      supported: true,
    },
    {
      id: 'ayapay',
      name: 'AYA Pay',
      description: 'AYA Bank mobile wallet',
      supported: true,
    },
    {
      id: 'cbpay',
      name: 'CB Pay',
      description: 'CB Bank mobile wallet',
      supported: true,
    },
  ];
}

/**
 * Mock MyanMyanPay payment for development/testing
 */
export async function createMockMyanMyanPayPayment({ orderId, amount, paymentMethod }) {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 1000));
  
  // Generate mock QR code (in production, this comes from MyanMyanPay)
  const mockQrCode = `MMQR_${paymentMethod.toUpperCase()}_${orderId}_${amount}_MOCK`;
  
  return {
    success: true,
    paymentId: `MP_${Date.now()}_${Math.random().toString(36).substr(2, 9)}`,
    qr: mockQrCode,
    expiresAt: new Date(Date.now() + 15 * 60 * 1000).toISOString(), // 15 minutes
    paymentUrl: `https://sandbox.myanmyanpay.com/pay/${mockQrCode}`,
  };
}

/**
 * Mock payment verification for development/testing
 */
export async function verifyMockMyanMyanPayPayment(paymentId) {
  // Simulate API delay
  await new Promise(resolve => setTimeout(resolve, 500));
  
  // In development, randomly return success or pending for testing
  const isCompleted = Math.random() > 0.3; // 70% chance of completion
  
  return {
    success: true,
    status: isCompleted ? 'completed' : 'pending',
    amount: 18000,
    currency: 'MMK',
    paymentMethod: 'kbzpay',
    completedAt: isCompleted ? new Date().toISOString() : null,
    transactionId: isCompleted ? `TXN_${Date.now()}` : null,
  };
}

// Export mock functions for development
export const mock = {
  createPayment: createMockMyanMyanPayPayment,
  verifyPayment: verifyMockMyanMyanPayPayment,
};

// Use mock functions if in development mode
export const createPayment = process.env.NODE_ENV === 'development' 
  ? createMockMyanMyanPayPayment 
  : createMyanMyanPayPayment;

export const verifyPayment = process.env.NODE_ENV === 'development'
  ? verifyMockMyanMyanPayPayment
  : verifyMyanMyanPayPayment;
