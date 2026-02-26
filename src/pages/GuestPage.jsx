import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ArrowRight, Play, Crown, BookOpen, Star, Users, Download, ChevronRight, Sparkles, Zap, Award } from 'lucide-react'

export default function GuestPage() {
  const navigate = useNavigate()
  const [email, setEmail] = useState('')

  const handleGetStarted = () => {
    navigate('/login')
  }

  const handleLogin = () => {
    navigate('/login')
  }

  const handleDownloadApp = () => {
    // Will link to APK download
    window.open('#', '_blank')
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50">
      {/* Hero Section */}
      <div className="relative overflow-hidden">
        {/* Background Pattern */}
        <div className="absolute inset-0 opacity-5">
          <div className="absolute top-10 left-10 w-72 h-72 bg-blue-500 rounded-full blur-3xl"></div>
          <div className="absolute top-20 right-20 w-96 h-96 bg-purple-500 rounded-full blur-3xl"></div>
          <div className="absolute bottom-20 left-1/2 w-80 h-80 bg-amber-500 rounded-full blur-3xl"></div>
        </div>

        {/* Navigation */}
        <nav className="relative px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <div className="w-10 h-10 rounded-xl gradient-primary flex items-center justify-center">
              <span className="text-white font-black text-lg">HSK</span>
            </div>
            <span className="text-xl font-black text-gray-900">Shwe Flash</span>
          </div>
          <div className="flex items-center gap-3">
            <button onClick={handleDownloadApp}
              className="px-4 py-2 rounded-xl bg-gray-900 text-white text-sm font-medium hover:bg-gray-800 transition-colors cursor-pointer flex items-center gap-2">
              <Download size={16} />
              Download App
            </button>
            <button onClick={handleLogin}
              className="px-4 py-2 rounded-xl gradient-primary text-white text-sm font-bold hover:shadow-lg transition-all cursor-pointer">
              Login
            </button>
          </div>
        </nav>

        {/* Hero Content */}
        <div className="relative px-6 py-16 text-center">
          <div className="max-w-4xl mx-auto">
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-amber-50 border border-amber-200 mb-6">
              <Sparkles size={16} className="text-amber-500" />
              <span className="text-sm font-bold text-amber-700">Learn Chinese HSK 1-6</span>
            </div>
            
            <h1 className="text-5xl md:text-6xl font-black text-gray-900 mb-6 leading-tight">
              Master Chinese
              <span className="block text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-purple-600">
                HSK Vocabulary
              </span>
            </h1>
            
            <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto leading-relaxed">
              The most effective way to learn Chinese vocabulary with flashcards, 
              interactive study modes, and progress tracking. Join thousands of students 
              mastering HSK levels 1-6.
            </p>

            <div className="flex flex-col sm:flex-row items-center justify-center gap-4 mb-12">
              <button onClick={handleGetStarted}
                className="px-8 py-4 rounded-xl gradient-primary text-white font-bold text-lg shadow-lg hover:shadow-xl transition-all cursor-pointer flex items-center gap-2">
                Start Learning Free
                <ArrowRight size={20} />
              </button>
              <button onClick={handleDownloadApp}
                className="px-8 py-4 rounded-xl bg-white border-2 border-gray-200 text-gray-900 font-bold text-lg hover:bg-gray-50 transition-colors cursor-pointer flex items-center gap-2">
                <Download size={20} />
                Download APK
              </button>
            </div>

            {/* Stats */}
            <div className="grid grid-cols-3 gap-8 max-w-lg mx-auto">
              <div className="text-center">
                <div className="text-3xl font-black text-gray-900">5K+</div>
                <div className="text-sm text-gray-500">Vocabulary Words</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-black text-gray-900">6</div>
                <div className="text-sm text-gray-500">HSK Levels</div>
              </div>
              <div className="text-center">
                <div className="text-3xl font-black text-gray-900">50K+</div>
                <div className="text-sm text-gray-500">Students</div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Features Section */}
      <div className="px-6 py-20 bg-white">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-16">
            <h2 className="text-4xl font-black text-gray-900 mb-4">
              Everything You Need to Master HSK
            </h2>
            <p className="text-xl text-gray-600 max-w-2xl mx-auto">
              Comprehensive learning tools designed for effective vocabulary acquisition
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            <div className="p-8 rounded-2xl bg-gradient-to-br from-blue-50 to-blue-100 border border-blue-200">
              <div className="w-14 h-14 rounded-xl bg-blue-500 flex items-center justify-center mb-6">
                <BookOpen size={28} className="text-white" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-3">Structured Learning</h3>
              <p className="text-gray-600 leading-relaxed">
                Follow the official HSK curriculum with 5,000+ vocabulary words 
                organized by difficulty level from HSK 1 to HSK 6.
              </p>
            </div>

            <div className="p-8 rounded-2xl bg-gradient-to-br from-purple-50 to-purple-100 border border-purple-200">
              <div className="w-14 h-14 rounded-xl bg-purple-500 flex items-center justify-center mb-6">
                <Zap size={28} className="text-white" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-3">Smart Flashcards</h3>
              <p className="text-gray-600 leading-relaxed">
                Interactive flashcards with spaced repetition, audio pronunciation, 
                and multi-language support (English, Myanmar, Thai).
              </p>
            </div>

            <div className="p-8 rounded-2xl bg-gradient-to-br from-amber-50 to-amber-100 border border-amber-200">
              <div className="w-14 h-14 rounded-xl bg-amber-500 flex items-center justify-center mb-6">
                <Award size={28} className="text-white" />
              </div>
              <h3 className="text-xl font-bold text-gray-900 mb-3">Track Progress</h3>
              <p className="text-gray-600 leading-relaxed">
                Monitor your learning journey with detailed statistics, 
                achievements, and personalized study recommendations.
              </p>
            </div>
          </div>
        </div>
      </div>

      {/* HSK Levels Preview */}
      <div className="px-6 py-20 bg-gray-50">
        <div className="max-w-6xl mx-auto">
          <div className="text-center mb-12">
            <h2 className="text-4xl font-black text-gray-900 mb-4">
              Master All HSK Levels
            </h2>
            <p className="text-xl text-gray-600">
              Progressive learning path from beginner to advanced
            </p>
          </div>

          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4">
            {[
              { level: 1, color: 'from-red-500 to-red-600', words: 150, label: 'Beginner' },
              { level: 2, color: 'from-orange-500 to-orange-600', words: 150, label: 'Elementary' },
              { level: 3, color: 'from-yellow-500 to-yellow-600', words: 300, label: 'Pre-Intermediate' },
              { level: 4, color: 'from-green-500 to-green-600', words: 600, label: 'Intermediate' },
              { level: 5, color: 'from-blue-500 to-blue-600', words: 1300, label: 'Advanced' },
              { level: 6, color: 'from-purple-500 to-purple-600', words: 2500, label: 'Proficient' },
            ].map((hsk) => (
              <div key={hsk.level} className="group cursor-pointer" onClick={handleGetStarted}>
                <div className={`relative rounded-2xl bg-gradient-to-br ${hsk.color} p-6 text-white shadow-lg hover:shadow-xl transition-all hover:-translate-y-1`}>
                  <div className="text-3xl font-black mb-2">HSK {hsk.level}</div>
                  <div className="text-sm opacity-90 mb-3">{hsk.words} words</div>
                  <div className="text-xs opacity-75">{hsk.label}</div>
                  <div className="absolute top-3 right-3 opacity-0 group-hover:opacity-100 transition-opacity">
                    <ChevronRight size={16} />
                  </div>
                </div>
              </div>
            ))}
          </div>

          <div className="text-center mt-12">
            <button onClick={handleGetStarted}
              className="px-8 py-4 rounded-xl gradient-primary text-white font-bold text-lg shadow-lg hover:shadow-xl transition-all cursor-pointer">
              Start Your Journey
              <ArrowRight size={20} className="inline ml-2" />
            </button>
          </div>
        </div>
      </div>

      {/* Premium Section */}
      <div className="px-6 py-20 bg-white">
        <div className="max-w-4xl mx-auto">
          <div className="text-center mb-12">
            <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-amber-50 border border-amber-200 mb-6">
              <Crown size={16} className="text-amber-500" />
              <span className="text-sm font-bold text-amber-700">Premium Features</span>
            </div>
            <h2 className="text-4xl font-black text-gray-900 mb-4">
              Unlock Your Full Potential
            </h2>
            <p className="text-xl text-gray-600">
              Get unlimited access to all HSK levels and advanced features
            </p>
          </div>

          <div className="grid md:grid-cols-2 gap-8">
            <div className="p-8 rounded-2xl border border-gray-200">
              <h3 className="text-xl font-bold text-gray-900 mb-4">Free Plan</h3>
              <ul className="space-y-3">
                <li className="flex items-start gap-3">
                  <div className="w-5 h-5 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <div className="w-2 h-2 rounded-full bg-gray-400"></div>
                  </div>
                  <span className="text-gray-600">HSK Level 1 (150 words)</span>
                </li>
                <li className="flex items-start gap-3">
                  <div className="w-5 h-5 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <div className="w-2 h-2 rounded-full bg-gray-400"></div>
                  </div>
                  <span className="text-gray-600">Basic flashcards</span>
                </li>
                <li className="flex items-start gap-3">
                  <div className="w-5 h-5 rounded-full bg-gray-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <div className="w-2 h-2 rounded-full bg-gray-400"></div>
                  </div>
                  <span className="text-gray-600">Progress tracking</span>
                </li>
              </ul>
            </div>

            <div className="p-8 rounded-2xl border-2 border-amber-200 bg-gradient-to-br from-amber-50 to-orange-50">
              <div className="flex items-center gap-2 mb-4">
                <Crown size={20} className="text-amber-500" />
                <h3 className="text-xl font-bold text-gray-900">Premium</h3>
              </div>
              <ul className="space-y-3">
                <li className="flex items-start gap-3">
                  <div className="w-5 h-5 rounded-full bg-amber-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Star size={12} className="text-amber-500" />
                  </div>
                  <span className="text-gray-600">All HSK Levels 1-6 (5,000+ words)</span>
                </li>
                <li className="flex items-start gap-3">
                  <div className="w-5 h-5 rounded-full bg-amber-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Star size={12} className="text-amber-500" />
                  </div>
                  <span className="text-gray-600">Advanced study modes</span>
                </li>
                <li className="flex items-start gap-3">
                  <div className="w-5 h-5 rounded-full bg-amber-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Star size={12} className="text-amber-500" />
                  </div>
                  <span className="text-gray-600">Offline access (app only)</span>
                </li>
                <li className="flex items-start gap-3">
                  <div className="w-5 h-5 rounded-full bg-amber-100 flex items-center justify-center flex-shrink-0 mt-0.5">
                    <Star size={12} className="text-amber-500" />
                  </div>
                  <span className="text-gray-600">Priority support</span>
                </li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      {/* CTA Section */}
      <div className="px-6 py-20 bg-gradient-to-r from-blue-600 to-purple-600">
        <div className="max-w-4xl mx-auto text-center">
          <h2 className="text-4xl font-black text-white mb-6">
            Ready to Master Chinese?
          </h2>
          <p className="text-xl text-white/90 mb-8 max-w-2xl mx-auto">
            Join thousands of students learning Chinese vocabulary with our proven method. 
            Start your journey today!
          </p>
          <div className="flex flex-col sm:flex-row items-center justify-center gap-4">
            <button onClick={handleGetStarted}
              className="px-8 py-4 rounded-xl bg-white text-blue-600 font-bold text-lg hover:bg-gray-50 transition-colors cursor-pointer flex items-center gap-2">
              Start Free
              <ArrowRight size={20} />
            </button>
            <button onClick={handleDownloadApp}
              className="px-8 py-4 rounded-xl bg-white/20 border-2 border-white/30 text-white font-bold text-lg hover:bg-white/30 transition-colors cursor-pointer flex items-center gap-2">
              <Download size={20} />
              Download App
            </button>
          </div>
        </div>
      </div>

      {/* Footer */}
      <footer className="px-6 py-12 bg-gray-900 text-white">
        <div className="max-w-6xl mx-auto">
          <div className="grid md:grid-cols-4 gap-8 mb-8">
            <div>
              <div className="flex items-center gap-2 mb-4">
                <div className="w-8 h-8 rounded-xl bg-white flex items-center justify-center">
                  <span className="text-gray-900 font-black text-sm">HSK</span>
                </div>
                <span className="text-lg font-black">Shwe Flash</span>
              </div>
              <p className="text-gray-400 text-sm">
                Master Chinese vocabulary with interactive learning tools.
              </p>
            </div>
            <div>
              <h4 className="font-bold mb-4">Product</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li><button onClick={handleGetStarted} className="hover:text-white cursor-pointer">Features</button></li>
                <li><button onClick={handleGetStarted} className="hover:text-white cursor-pointer">Pricing</button></li>
                <li><button onClick={handleDownloadApp} className="hover:text-white cursor-pointer">Download App</button></li>
              </ul>
            </div>
            <div>
              <h4 className="font-bold mb-4">Support</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li><button onClick={handleLogin} className="hover:text-white cursor-pointer">Login</button></li>
                <li><button onClick={handleGetStarted} className="hover:text-white cursor-pointer">Register</button></li>
                <li><button onClick={handleGetStarted} className="hover:text-white cursor-pointer">Help</button></li>
              </ul>
            </div>
            <div>
              <h4 className="font-bold mb-4">Company</h4>
              <ul className="space-y-2 text-gray-400 text-sm">
                <li><button className="hover:text-white cursor-pointer">About</button></li>
                <li><button className="hover:text-white cursor-pointer">Contact</button></li>
                <li><button className="hover:text-white cursor-pointer">Privacy</button></li>
              </ul>
            </div>
          </div>
          <div className="border-t border-gray-800 pt-8 text-center text-gray-400 text-sm">
            <p>&copy; 2026 HSK Shwe Flash. All rights reserved.</p>
          </div>
        </div>
      </footer>
    </div>
  )
}
