import axios from 'axios'

class OTPService {
  constructor() {
    this.api = axios.create({
      baseURL: process.env.NODE_ENV === 'production' 
        ? 'https://hsk-shwe-flash.vercel.app/api'
        : 'http://localhost:5001/api',
      timeout: 30000
    })
  }

  // Generate and send OTP
  async sendOTP(phoneNumber, countryCode) {
    try {
      const response = await this.api.post('/otp/send', {
        phoneNumber: phoneNumber.replace(/\s/g, ''),
        countryCode: countryCode
      })
      return response.data
    } catch (error) {
      console.error('OTP send error:', error)
      throw error.response?.data || { error: 'Failed to send OTP' }
    }
  }

  // Verify OTP
  async verifyOTP(phoneNumber, countryCode, otp) {
    try {
      const response = await this.api.post('/otp/verify', {
        phoneNumber: phoneNumber.replace(/\s/g, ''),
        countryCode: countryCode,
        otp: otp
      })
      return response.data
    } catch (error) {
      console.error('OTP verify error:', error)
      throw error.response?.data || { error: 'Failed to verify OTP' }
    }
  }

  // Resend OTP
  async resendOTP(phoneNumber, countryCode) {
    try {
      const response = await this.api.post('/otp/resend', {
        phoneNumber: phoneNumber.replace(/\s/g, ''),
        countryCode: countryCode
      })
      return response.data
    } catch (error) {
      console.error('OTP resend error:', error)
      throw error.response?.data || { error: 'Failed to resend OTP' }
    }
  }
}

export default new OTPService()
