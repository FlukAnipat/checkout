import { useState } from 'react'
import { Phone, Globe, Check } from 'lucide-react'

const countries = [
  { code: '+95', name: 'Myanmar', flag: '🇲🇲', pattern: /^[0-9]{7,11}$/ },
  { code: '+66', name: 'Thailand', flag: '🇹🇭', pattern: /^[0-9]{9,10}$/ },
  { code: '+1', name: 'USA', flag: '🇺🇸', pattern: /^[0-9]{10}$/ },
  { code: '+44', name: 'UK', flag: '🇬🇧', pattern: /^[0-9]{10,11}$/ },
  { code: '+86', name: 'China', flag: '🇨🇳', pattern: /^[0-9]{11}$/ },
  { code: '+65', name: 'Singapore', flag: '🇸🇬', pattern: /^[0-9]{8}$/ },
  { code: '+81', name: 'Japan', flag: '🇯🇵', pattern: /^[0-9]{10,11}$/ },
  { code: '+82', name: 'South Korea', flag: '🇰🇷', pattern: /^[0-9]{9,10}$/ },
  { code: '+91', name: 'India', flag: '🇮🇳', pattern: /^[0-9]{10}$/ },
  { code: '+84', name: 'Vietnam', flag: '🇻🇳', pattern: /^[0-9]{9,10}$/ },
  { code: '+60', name: 'Malaysia', flag: '🇲🇾', pattern: /^[0-9]{9,10}$/ },
  { code: '+62', name: 'Indonesia', flag: '🇮🇩', pattern: /^[0-9]{9,12}$/ },
]

export default function CountryPhoneInput({ value, onChange, error, setError }) {
  const [selectedCountry, setSelectedCountry] = useState(countries[0])
  const [phoneNumber, setPhoneNumber] = useState('')
  const [showDropdown, setShowDropdown] = useState(false)
  const [phoneValid, setPhoneValid] = useState(false)

  const validatePhone = (phone, country) => {
    if (!phone.trim()) {
      setError('Phone number is required')
      setPhoneValid(false)
      return false
    }
    
    if (!country.pattern.test(phone.replace(/\s/g, ''))) {
      setError(`Invalid ${country.name} phone number format`)
      setPhoneValid(false)
      return false
    }
    
    setError('')
    setPhoneValid(true)
    return true
  }

  const handlePhoneChange = (e) => {
    const phone = e.target.value
    setPhoneNumber(phone)
    
    if (phone) {
      validatePhone(phone, selectedCountry)
    } else {
      setError('')
      setPhoneValid(false)
    }
  }

  const handleCountrySelect = (country) => {
    setSelectedCountry(country)
    setShowDropdown(false)
    
    if (phoneNumber) {
      validatePhone(phoneNumber, country)
    }
    
    onChange({
      countryCode: country.code,
      phone: phoneNumber,
      country: country.name
    })
  }

  const handlePhoneBlur = () => {
    if (phoneNumber) {
      validatePhone(phoneNumber, selectedCountry)
      onChange({
        countryCode: selectedCountry.code,
        phone: phoneNumber,
        country: selectedCountry.name
      })
    }
  }

  return (
    <div className="space-y-2">
      <label className="block text-sm font-semibold text-gray-600 mb-1.5">
        Phone Number <span className="text-red-500">*</span>
      </label>
      
      {/* Country Selection */}
      <div className="relative">
        <button
          type="button"
          onClick={() => setShowDropdown(!showDropdown)}
          className="w-full px-4 py-3 rounded-xl border border-gray-200 bg-gray-50/50 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent focus:bg-white transition-all text-left flex items-center justify-between"
        >
          <div className="flex items-center gap-3">
            <span className="text-lg">{selectedCountry.flag}</span>
            <div>
              <div className="text-sm font-medium text-gray-900">{selectedCountry.name}</div>
              <div className="text-xs text-gray-500">{selectedCountry.code}</div>
            </div>
          </div>
          <Globe size={18} className="text-gray-400" />
        </button>

        {showDropdown && (
          <div className="absolute z-10 w-full mt-1 bg-white border border-gray-200 rounded-xl shadow-lg max-h-60 overflow-y-auto">
            {countries.map((country) => (
              <button
                key={country.code}
                type="button"
                onClick={() => handleCountrySelect(country)}
                className="w-full px-4 py-3 hover:bg-gray-50 transition-colors flex items-center gap-3 text-left"
              >
                <span className="text-lg">{country.flag}</span>
                <div className="flex-1">
                  <div className="text-sm font-medium text-gray-900">{country.name}</div>
                  <div className="text-xs text-gray-500">{country.code}</div>
                </div>
                {selectedCountry.code === country.code && (
                  <Check size={16} className="text-green-500" />
                )}
              </button>
            ))}
          </div>
        )}
      </div>

      {/* Phone Number Input */}
      <div className="relative">
        <div className="absolute left-4 top-1/2 -translate-y-1/2 text-sm font-medium text-gray-600">
          {selectedCountry.code}
        </div>
        <input
          type="tel"
          value={phoneNumber}
          onChange={handlePhoneChange}
          onBlur={handlePhoneBlur}
          placeholder="Enter phone number"
          className={`w-full pl-20 pr-12 py-3 rounded-xl border bg-gray-50/50 focus:outline-none focus:ring-2 transition-all text-gray-800 placeholder-gray-300 ${
            error
              ? 'border-red-200 focus:ring-red-500 focus:border-red-300'
              : phoneValid
              ? 'border-green-200 focus:ring-green-500 focus:border-green-300'
              : 'border-gray-200 focus:ring-primary-500 focus:border-transparent'
          } focus:bg-white`}
        />
        <div className="absolute right-3 top-1/2 -translate-y-1/2">
          {phoneValid ? (
            <div className="w-5 h-5 rounded-full bg-green-100 flex items-center justify-center">
              <Check size={12} className="text-green-600" />
            </div>
          ) : (
            <Phone size={18} className="text-gray-400" />
          )}
        </div>
      </div>

      {error && (
        <p className="text-xs text-red-600 mt-1">{error}</p>
      )}

      <p className="text-xs text-gray-400">
        Format: {selectedCountry.name} phone number ({selectedCountry.code})
      </p>
    </div>
  )
}
