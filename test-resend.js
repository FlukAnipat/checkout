// Test Resend API directly
import { Resend } from 'resend';
import dotenv from 'dotenv';

dotenv.config();

console.log('🔧 Testing Resend API...');
console.log('🔧 RESEND_API_KEY exists:', !!process.env.RESEND_API_KEY);

try {
  const resend = new Resend(process.env.RESEND_API_KEY);
  
  const result = await resend.emails.send({
    from: 'HSK Shwe Flash <delivered@resend.dev>',
    to: 'test@example.com', // Change to your email for testing
    subject: 'Test Email - HSK Shwe Flash',
    html: '<h1>Test Email</h1><p>This is a test email from HSK Shwe Flash.</p>'
  });
  
  console.log('✅ Email sent successfully:', result);
} catch (error) {
  console.error('❌ Email sending failed:', error.message);
  console.error('🔧 Full error:', error);
}
