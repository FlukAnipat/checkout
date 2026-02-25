import api from './api.js'

const emailConfirmationService = {
  // Send confirmation email
  sendConfirmation: async ({ email, firstName, lastName }) => {
    const response = await api.post('/email-confirmation/send-confirmation', {
      email,
      firstName,
      lastName
    })
    return response.data
  },

  // Confirm email via token
  confirmEmail: async (token) => {
    const response = await api.get(`/email-confirmation/confirm?token=${token}`)
    return response.data
  },

  // Check if email is confirmed
  checkStatus: async (email) => {
    const response = await api.post('/email-confirmation/check-status', {
      email
    })
    return response.data
  },

  // Resend confirmation email
  resendConfirmation: async ({ email, firstName, lastName }) => {
    const response = await api.post('/email-confirmation/resend', {
      email,
      firstName,
      lastName
    })
    return response.data
  }
}

export default emailConfirmationService
