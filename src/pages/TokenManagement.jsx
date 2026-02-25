import { useState, useEffect } from 'react'
import { authAPI } from '../services/api'
import { Copy, Plus, Trash2, Shield, Users, Link } from 'lucide-react'

export default function TokenManagement() {
  const [tokens, setTokens] = useState([])
  const [newToken, setNewToken] = useState('')
  const [loading, setLoading] = useState(false)
  const [copied, setCopied] = useState('')

  // Generate unique token
  const generateToken = () => {
    const random = Math.random().toString(36).substring(2, 8)
    return `sales_${random}`
  }

  // Copy registration URL
  const copyRegistrationUrl = (token) => {
    const url = `https://hsk.shwe-flash.com/#/register/${token}`
    navigator.clipboard.writeText(url)
    setCopied(token)
    setTimeout(() => setCopied(''), 2000)
  }

  // Create new token
  const createToken = async () => {
    if (!newToken.trim()) return
    
    setLoading(true)
    try {
      // In production, save to database
      const tokenData = {
        token: newToken,
        createdAt: new Date().toISOString(),
        createdBy: 'admin',
        status: 'active'
      }
      
      setTokens(prev => [...prev, tokenData])
      setNewToken('')
    } catch (error) {
      console.error('Error creating token:', error)
    } finally {
      setLoading(false)
    }
  }

  // Delete token
  const deleteToken = (tokenToDelete) => {
    setTokens(prev => prev.filter(t => t.token !== tokenToDelete))
  }

  // Initialize with default token
  useEffect(() => {
    setTokens([
      {
        token: 'salesHSK',
        createdAt: new Date().toISOString(),
        createdBy: 'admin',
        status: 'active'
      }
    ])
  }, [])

  return (
    <div className="p-6 max-w-4xl mx-auto">
      <div className="mb-8">
        <h1 className="text-2xl font-bold text-gray-900 mb-2">Sales Registration Management</h1>
        <p className="text-gray-600">
          Generate registration tokens for sales team members
        </p>
      </div>

      {/* Create New Token */}
      <div className="bg-white rounded-xl border border-gray-200 p-6 mb-6">
        <h2 className="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2">
          <Plus size={20} />
          Create Registration Token
        </h2>
        
        <div className="flex gap-3">
          <input
            type="text"
            value={newToken}
            onChange={(e) => setNewToken(e.target.value)}
            placeholder="sales_abc123"
            className="flex-1 px-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
          />
          <button
            onClick={() => setNewToken(generateToken())}
            className="px-4 py-2 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition-colors"
          >
            Generate
          </button>
          <button
            onClick={createToken}
            disabled={!newToken.trim() || loading}
            className="px-4 py-2 bg-primary-500 text-white rounded-lg hover:bg-primary-600 disabled:opacity-50 disabled:cursor-not-allowed transition-colors"
          >
            Create Token
          </button>
        </div>
      </div>

      {/* Active Tokens */}
      <div className="bg-white rounded-xl border border-gray-200 p-6">
        <h2 className="text-lg font-semibold text-gray-800 mb-4 flex items-center gap-2">
          <Shield size={20} />
          Active Registration Tokens
        </h2>

        <div className="space-y-3">
          {tokens.map((tokenData) => (
            <div key={tokenData.token} className="flex items-center justify-between p-4 bg-gray-50 rounded-lg">
              <div className="flex-1">
                <div className="font-mono font-semibold text-gray-900">
                  {tokenData.token}
                </div>
                <div className="text-sm text-gray-500">
                  Created: {new Date(tokenData.createdAt).toLocaleDateString()}
                </div>
                <div className="text-sm text-gray-500">
                  Status: <span className="text-green-600">{tokenData.status}</span>
                </div>
              </div>
              
              <div className="flex items-center gap-2">
                <button
                  onClick={() => copyRegistrationUrl(tokenData.token)}
                  className="p-2 text-gray-600 hover:text-primary-500 hover:bg-primary-50 rounded-lg transition-colors"
                  title="Copy registration URL"
                >
                  {copied === tokenData.token ? (
                    <div className="w-5 h-5 text-green-500">✓</div>
                  ) : (
                    <Copy size={18} />
                  )}
                </button>
                
                {tokenData.token !== 'salesHSK' && (
                  <button
                    onClick={() => deleteToken(tokenData.token)}
                    className="p-2 text-gray-600 hover:text-red-500 hover:bg-red-50 rounded-lg transition-colors"
                    title="Delete token"
                  >
                    <Trash2 size={18} />
                  </button>
                )}
              </div>
            </div>
          ))}
        </div>

        {tokens.length === 0 && (
          <div className="text-center py-8 text-gray-500">
            <Users size={48} className="mx-auto mb-4 opacity-50" />
            <p>No active tokens</p>
          </div>
        )}
      </div>

      {/* Instructions */}
      <div className="mt-6 bg-blue-50 border border-blue-200 rounded-xl p-6">
        <h3 className="font-semibold text-blue-900 mb-2">How to use:</h3>
        <ol className="text-sm text-blue-800 space-y-1 list-decimal list-inside">
          <li>Sales person contacts you for registration</li>
          <li>Generate a unique token or use existing one</li>
          <li>Copy the registration URL (hsk.shwe-flash.com) and send to the sales person</li>
          <li>They can register using that URL</li>
          <li>After registration, they get access to sales dashboard</li>
        </ol>
        <div className="mt-3 p-3 bg-blue-100 rounded-lg">
          <p className="text-xs text-blue-700">
            <strong>URL Format:</strong> https://hsk.shwe-flash.com/#/register/[token]
          </p>
        </div>
      </div>
    </div>
  )
}
