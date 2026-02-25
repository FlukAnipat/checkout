// Test Resend API directly
import { Resend } from 'resend';
import dotenv from 'dotenv';

dotenv.config();

console.log('🔧 Testing Resend API...');
console.log('🔧 RESEND_API_KEY exists:', !!process.env.RESEND_API_KEY);

try {
  const resend = new Resend(process.env.RESEND_API_KEY || 're_X8kFVKZJ_Gss3RTeVu9Ywib1c4o2rxzev');
  
  const result = await resend.emails.send({
    from: 'HSK Shwe Flash <notifications@resend.dev>',
    to: 'anipat5556666@gmail.com', // Testing API only allows this email
    subject: 'Test Email - HSK Shwe Flash',
    html: '<h1>Test Email</h1><p>This is a test email from HSK Shwe Flash.</p>'
  });
  
  console.log('✅ Email sent successfully:', result);
} catch (error) {
  console.error('❌ Email sending failed:', error.message);
  console.error('🔧 Full error:', error);
}
