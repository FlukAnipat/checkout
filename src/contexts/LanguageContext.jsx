import { createContext, useContext, useState, useEffect } from 'react'

// Language options matching Flutter app
export const LANGUAGES = {
  english: { code: 'EN', name: 'English', nativeName: 'English', flag: '🇬🇧' },
  burmese: { code: 'MY', name: 'Burmese', nativeName: 'မြန်မာ', flag: '🇲🇲' },
  englishAndBurmese: { code: 'EN+MY', name: 'English + Burmese', nativeName: 'English + မြန်မာ', flag: '🇬🇧🇲🇲' },
}

const LanguageContext = createContext()

export function LanguageProvider({ children }) {
  const [language, setLanguage] = useState(() => {
    return localStorage.getItem('sf_language') || 'english'
  })

  useEffect(() => {
    localStorage.setItem('sf_language', language)
  }, [language])

  // Get meaning based on selected language (matches Flutter Vocabulary.getMeaning)
  const getMeaning = (word) => {
    if (!word) return ''
    const en = word.meaning_en || word.meaningEn || word.meaning || ''
    const my = word.meaning_my || word.meaningMy || ''
    const fallback = en || word.hanzi || 'No meaning'

    switch (language) {
      case 'english':
        return en || fallback
      case 'burmese':
        return my || fallback
      case 'englishAndBurmese':
        if (my && en !== my) return `${en || fallback}\n${my}`
        return en || fallback
      default:
        return en || fallback
    }
  }

  // Get example sentences based on selected language (matches Flutter Vocabulary.getExample)
  const getExample = (exampleText) => {
    if (!exampleText) return ''

    const parts = exampleText.split('\n\n')
    const sentences = []

    for (const part of parts) {
      if (!part.trim()) continue
      const lines = part.split('\n')
      if (!lines.length) continue

      let chineseSentence = null
      let englishSentence = null
      let burmeseSentence = null

      for (const line of lines) {
        const trimmed = line.trim()
        if (!trimmed) continue

        // Numbered Chinese sentence
        if (/^\d+\.\s*[\u4e00-\u9fff]/.test(trimmed)) {
          chineseSentence = trimmed
        }
        // English (Latin chars, no Chinese, no Burmese)
        else if (/^[a-zA-Z]/.test(trimmed) && !/[\u4e00-\u9fff]/.test(trimmed) && !/[\u1000-\u109F]/.test(trimmed)) {
          englishSentence = trimmed
        }
        // Burmese
        else if (/[\u1000-\u109F]/.test(trimmed)) {
          burmeseSentence = trimmed
        }
      }

      if (chineseSentence) {
        let sentence = chineseSentence
        switch (language) {
          case 'english':
            if (englishSentence) sentence += '\n' + englishSentence
            break
          case 'burmese':
            if (burmeseSentence) sentence += '\n' + burmeseSentence
            break
          case 'englishAndBurmese':
            if (englishSentence) sentence += '\n' + englishSentence
            if (burmeseSentence) sentence += '\n' + burmeseSentence
            break
        }
        sentences.push(sentence)
      }
    }

    return sentences.join('\n\n')
  }

  // Get language display info
  const currentLang = LANGUAGES[language] || LANGUAGES.english

  return (
    <LanguageContext.Provider value={{
      language,
      setLanguage,
      currentLang,
      getMeaning,
      getExample,
      availableLanguages: Object.entries(LANGUAGES).map(([key, val]) => ({ key, ...val })),
    }}>
      {children}
    </LanguageContext.Provider>
  )
}

export function useLanguage() {
  const context = useContext(LanguageContext)
  if (!context) throw new Error('useLanguage must be used within LanguageProvider')
  return context
}
