//
//  Zodiac+Text.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/19/23.
//

import Foundation

// MARK: Zodiac Text
extension Arcana.Zodiac {
    
    // MARK: String
    // String Value
    var stringValue:String { return "\(self)".capitalized }
    
    // MARK: Text
    // Greek Zodiac
    var text:String {
        switch self {
        case .aries: return "Aries"
        case .taurus: return "Taurus"
        case .gemini: return "Gemini"
        case .cancer: return "Cancer"
        case .leo: return "Leo"
        case .virgo: return "Virgo"
        case .libra: return "Libra"
        case .scorpio: return "Scorpio"
        case .sagittarius: return "Sagittarius"
        case .capricorn: return "Capricorn"
        case .aquarius: return "Aquarius"
        case .pisces: return "Pisces"
        }
    }
    var emoji: String {
        switch self {
        case .aries: return "♈️" // Aries emoji
        case .taurus: return "♉️" // Taurus emoji
        case .gemini: return "♊️" // Gemini emoji
        case .cancer: return "♋️" // Cancer emoji
        case .leo: return "♌️" // Leo emoji
        case .virgo: return "♍️" // Virgo emoji
        case .libra: return "♎️" // Libra emoji
        case .scorpio: return "♏️" // Scorpio emoji
        case .sagittarius: return "♐️" // Sagittarius emoji
        case .capricorn: return "♑️" // Capricorn emoji
        case .aquarius: return "♒️" // Aquarius emoji
        case .pisces: return "♓️" // Pisces emoji
        }
    }
    // MARK: Chinese Zodiac
    var chineseEmoji: String {
        switch self {
        case .aries: return "🐀" // Rat for Aries
        case .taurus: return "🐂" // Ox for Taurus
        case .gemini: return "🐅" // Tiger for Gemini
        case .cancer: return "🐇" // Rabbit for Cancer
        case .leo: return "🐉" // Dragon for Leo
        case .virgo: return "🐍" // Snake for Virgo
        case .libra: return "🐎" // Horse for Libra
        case .scorpio: return "🐐" // Goat for Scorpio
        case .sagittarius: return "🐒" // Monkey for Sagittarius
        case .capricorn: return "🐓" // Rooster for Capricorn
        case .aquarius: return "🐕" // Dog for Aquarius
        case .pisces: return "🐖" // Pig for Pisces
        }
    }
    var chineseSymbol: String {
        switch self {
        case .aries: return "鼠" // Rat (鼠 shǔ)
        case .taurus: return "牛" // Ox (牛 niú)
        case .gemini: return "虎" // Tiger (虎 hǔ)
        case .cancer: return "兔" // Rabbit (兔 tù)
        case .leo: return "龙" // Dragon (龙 lóng)
        case .virgo: return "蛇" // Snake (蛇 shé)
        case .libra: return "马" // Horse (马 mǎ)
        case .scorpio: return "羊" // Goat (羊 yáng)
        case .sagittarius: return "猴" // Monkey (猴 hóu)
        case .capricorn: return "鸡" // Rooster (鸡 jī)
        case .aquarius: return "狗" // Dog (狗 gǒu)
        case .pisces: return "猪" // Pig (猪 zhū)
        }
    }
    var chineseZodiacAnimal: String {
        switch self {
        case .aries: return "Rat"
        case .taurus: return "Ox"
        case .gemini: return "Tiger"
        case .cancer: return "Rabbit"
        case .leo: return "Dragon"
        case .virgo: return "Snake"
        case .libra: return "Horse"
        case .scorpio: return "Goat"
        case .sagittarius: return "Monkey"
        case .capricorn: return "Rooster"
        case .aquarius: return "Dog"
        case .pisces: return "Pig"
        }
    }
    var chinesePronunciation: String {
        switch self {
        case .aries: return "Shǔ" // Rat (鼠 shǔ)
        case .taurus: return "Niú" // Ox (牛 niú)
        case .gemini: return "Hǔ" // Tiger (虎 hǔ)
        case .cancer: return "Tù" // Rabbit (兔 tù)
        case .leo: return "Lóng" // Dragon (龙 lóng)
        case .virgo: return "Shé" // Snake (蛇 shé)
        case .libra: return "Mǎ" // Horse (马 mǎ)
        case .scorpio: return "Yáng" // Goat (羊 yáng)
        case .sagittarius: return "Hóu" // Monkey (猴 hóu)
        case .capricorn: return "Jī" // Rooster (鸡 jī)
        case .aquarius: return "Gǒu" // Dog (狗 gǒu)
        case .pisces: return "Zhū" // Pig (猪 zhū)
        }
    }
    var chineseWordIPA: String {
        switch self {
        case .aries: return "ʂu˥" // Rat (鼠 shǔ)
        case .taurus: return "njoʊ˥" // Ox (牛 niú)
        case .gemini: return "xu˥" // Tiger (虎 hǔ)
        case .cancer: return "thu˥" // Rabbit (兔 tù)
        case .leo: return "lʊŋ˥" // Dragon (龙 lóng)
        case .virgo: return "ʂɤ˥" // Snake (蛇 shé)
        case .libra: return "ma˥" // Horse (马 mǎ)
        case .scorpio: return "jæŋ˥" // Goat (羊 yáng)
        case .sagittarius: return "hoʊ˥" // Monkey (猴 hóu)
        case .capricorn: return "d͡ʒi˥" // Rooster (鸡 jī)
        case .aquarius: return "goʊ˥" // Dog (狗 gǒu)
        case .pisces: return "d͡ʒu˥" // Pig (猪 zhū)
        }
    }
    var chinesePronunciationIPA: String {
        switch self {
        case .aries: return "/ʂu˥/ (shǔ)" // Rat (鼠 shǔ)
        case .taurus: return "/njoʊ˥/ (niú)" // Ox (牛 niú)
        case .gemini: return "/xu˥/ (hǔ)" // Tiger (虎 hǔ)
        case .cancer: return "/thu˥/ (tù)" // Rabbit (兔 tù)
        case .leo: return "/lʊŋ˥/ (lóng)" // Dragon (龙 lóng)
        case .virgo: return "/ʂɤ˥/ (shé)" // Snake (蛇 shé)
        case .libra: return "/ma˥/ (mǎ)" // Horse (马 mǎ)
        case .scorpio: return "/jæŋ˥/ (yáng)" // Goat (羊 yáng)
        case .sagittarius: return "/hoʊ˥/ (hóu)" // Monkey (猴 hóu)
        case .capricorn: return "/d͡ʒi˥/ (jī)" // Rooster (鸡 jī)
        case .aquarius: return "/goʊ˥/ (gǒu)" // Dog (狗 gǒu)
        case .pisces: return "/d͡ʒu˥/ (zhū)" // Pig (猪 zhū)
        }
    }
    var chineseWordFull: String {
        switch self {
        case .aries: return "Rat (鼠 shǔ) /ʂu˥/"
        case .taurus: return "Ox (牛 niú) /njoʊ˥/"
        case .gemini: return "Tiger (虎 hǔ) /xu˥/"
        case .cancer: return "Rabbit (兔 tù) /thu˥/"
        case .leo: return "Dragon (龙 lóng) /lʊŋ˥/"
        case .virgo: return "Snake (蛇 shé) /ʂɤ˥/"
        case .libra: return "Horse (马 mǎ) /ma˥/"
        case .scorpio: return "Goat (羊 yáng) /jæŋ˥/"
        case .sagittarius: return "Monkey (猴 hóu) /hoʊ˥/"
        case .capricorn: return "Rooster (鸡 jī) /d͡ʒi˥/"
        case .aquarius: return "Dog (狗 gǒu) /goʊ˥/"
        case .pisces: return "Pig (猪 zhū) /d͡ʒu˥/"
        }
    }

    // MARK: Other Languages
    var greekWordIPA: String {
        switch self {
        case .aries: return "ˈkrioʊs" // Aries word IPA in Greek
        case .taurus: return "ˈtoɾos" // Taurus word IPA in Greek
        case .gemini: return "ˈdʒemini" // Gemini word IPA in Greek
        case .cancer: return "ˈkarkinos" // Cancer word IPA in Greek
        case .leo: return "ˈleːo" // Leo word IPA in Greek
        case .virgo: return "ˈpsefthɪs" // Virgo word IPA in Greek
        case .libra: return "ˈzʊɣos" // Libra word IPA in Greek
        case .scorpio: return "ˈskorpi.os" // Scorpio word IPA in Greek
        case .sagittarius: return "ˌtoxotis" // Sagittarius word IPA in Greek
        case .capricorn: return "ˈkriːnos" // Capricorn word IPA in Greek
        case .aquarius: return "ˈidroxoos" // Aquarius word IPA in Greek
        case .pisces: return "ˈiχθues" // Pisces word IPA in Greek
        }
    }
    var americanEnglishWordIPA: String {
        switch self {
        case .aries: return "ˈɛəriːz" // Aries word IPA in American English
        case .taurus: return "ˈtɔːrəs" // Taurus word IPA in American English
        case .gemini: return "ˈdʒɛmɪnaɪ" // Gemini word IPA in American English
        case .cancer: return "ˈkænsər" // Cancer word IPA in American English
        case .leo: return "ˈliːoʊ" // Leo word IPA in American English
        case .virgo: return "ˈvɜːrɡoʊ" // Virgo word IPA in American English
        case .libra: return "ˈliːbrə" // Libra word IPA in American English
        case .scorpio: return "ˈskɔːrpioʊ" // Scorpio word IPA in American English
        case .sagittarius: return "ˌsædʒɪˈtɛriəs" // Sagittarius word IPA in American English
        case .capricorn: return "ˈkæprɪˌkɔːrn" // Capricorn word IPA in American English
        case .aquarius: return "əˈkwɛriəs" // Aquarius word IPA in American English
        case .pisces: return "ˈpaɪsiːz" // Pisces word IPA in American English
        }
    }
    var aproximateAncientEgyptianWordIPA: String { // may not be accurate...
        switch self {
        case .aries: return "Hery" // Aries word IPA in Ancient Egyptian
        case .taurus: return "Meskhety" // Taurus word IPA in Ancient Egyptian
        case .gemini: return "Pekhati" // Gemini word IPA in Ancient Egyptian
        case .cancer: return "Xaty" // Cancer word IPA in Ancient Egyptian
        case .leo: return "Sesh" // Leo word IPA in Ancient Egyptian
        case .virgo: return "Spd" // Virgo word IPA in Ancient Egyptian
        case .libra: return "Smau" // Libra word IPA in Ancient Egyptian
        case .scorpio: return "I͗qr" // Scorpio word IPA in Ancient Egyptian
        case .sagittarius: return "Kerket" // Sagittarius word IPA in Ancient Egyptian
        case .capricorn: return "Kap" // Capricorn word IPA in Ancient Egyptian
        case .aquarius: return "Hapi" // Aquarius word IPA in Ancient Egyptian
        case .pisces: return "Aar" // Pisces word IPA in Ancient Egyptian
        }
    }
    var spanishWordIPA: String {
        switch self {
        case .aries: return "ˈaɾjes"
        case .taurus: return "ˈtauɾo"
        case .gemini: return "ˈxeminis"
        case .cancer: return "ˈkanθer"
        case .leo: return "ˈle.o"
        case .virgo: return "ˈbiɾɣo"
        case .libra: return "ˈliβɾa"
        case .scorpio: return "esˈkoɾpjo"
        case .sagittarius: return "saxiˈtaɾjo"
        case .capricorn: return "kapɾikoɾˈnjo"
        case .aquarius: return "aˈkwjaɾjo"
        case .pisces: return "ˈpiskis"
        }
    }
    var frenchWordIPA: String {
        switch self {
        case .aries: return "bɛlje"
        case .taurus: return "toʁo"
        case .gemini: return "ʒemo"
        case .cancer: return "kɑ̃sɛʁ"
        case .leo: return "ljɔ̃"
        case .virgo: return "vjɛʁʒ"
        case .libra: return "balɑ̃s"
        case .scorpio: return "skɔʁpjɔ̃"
        case .sagittarius: return "saʒitɛʁ"
        case .capricorn: return "kapʁikɔʁn"
        case .aquarius: return "vɛʁso"
        case .pisces: return "pwasɔ̃"
        }
    }
    var germanWordIPA: String {
        switch self {
        case .aries: return "ˈvɪdɐ"
        case .taurus: return "ʃtiːɐ̯"
        case .gemini: return "ˈt͡svɪlɪŋə"
        case .cancer: return "kʁɛps"
        case .leo: return "ˈløːvə"
        case .virgo: return "ˈjʊŋfraʊ"
        case .libra: return "ˈvaːɡə"
        case .scorpio: return "skoˈʁpi̯oːn"
        case .sagittarius: return "ˈʃʏtsə"
        case .capricorn: return "ˈʃtaɪn.bɔk"
        case .aquarius: return "ˈvasɐman"
        case .pisces: return "ˈfɪʃə"
        }
    }

    // MARK: Copy Text
    // Subtitle
    var subtitle: String {
        switch self {
        case .aries: return "Trailblazer"
        case .taurus: return "Determined One"
        case .gemini: return "Adaptable Mind"
        case .cancer: return "Nurturer"
        case .leo: return "Confident Leader"
        case .virgo: return "Analytical Mind"
        case .libra: return "Harmonizer"
        case .scorpio: return "Passionate Soul"
        case .sagittarius: return "Adventurous Spirit"
        case .capricorn: return "Ambitious Achiever"
        case .aquarius: return "Original Humanitarian"
        case .pisces: return "Imaginative Dreamer"
        }
    }
    
    // Keywords
    /// Combined String
    var combinedKeywords: String {
        return keywords.joined(separator: ", ")
    }
    /// List
    var keywords: [String] {
        let keywordsDict: [Arcana.Zodiac: [String]] = [
            .aries: ["Courage", "Independence", "Optimism"],
            .taurus: ["Stability", "Patience", "Determination"],
            .gemini: ["Adaptability", "Curiosity", "Communication"],
            .cancer: ["Emotion", "Intuition", "Nurturing"],
            .leo: ["Confidence", "Creativity", "Leadership"],
            .virgo: ["Detail-oriented", "Analytical", "Practical"],
            .libra: ["Balance", "Diplomacy", "Harmony"],
            .scorpio: ["Passion", "Intuition", "Determination"],
            .sagittarius: ["Adventure", "Optimism", "Independence"],
            .capricorn: ["Ambition", "Discipline", "Responsibility"],
            .aquarius: ["Originality", "Humanitarian", "Independence"],
            .pisces: ["Intuition", "Compassion", "Imagination"]
        ]
        return keywordsDict[self] ?? []
    }
    
    // Descriptions
    var description: String {
        switch self {
        case .aries: return "Enthusiastic trailblazers known for their courage and leadership qualities."
        case .taurus: return "Reliable and patient individuals who value stability and determination."
        case .gemini: return "Adaptable and curious communicators with a love for variety and learning."
        case .cancer: return "Emotionally intuitive nurturers deeply connected to their feelings and empathy."
        case .leo: return "Confident and creative leaders who radiate charisma and self-assuredness."
        case .virgo: return "Detail-oriented and analytical minds focused on practical solutions and precision."
        case .libra: return "Balanced and diplomatic harmonizers seeking peace and fairness in all aspects."
        case .scorpio: return "Passionate and determined individuals guided by intuition and intensity."
        case .sagittarius: return "Adventurous and optimistic free spirits driven by independence and exploration."
        case .capricorn: return "Ambitious and disciplined achievers dedicated to responsibility and success."
        case .aquarius: return "Original and humanitarian souls advocating for independence and innovation."
        case .pisces: return "Intuitive and compassionate dreamers immersed in imagination and empathy."
        }
    }
    
    // Details
    var details: String {
        switch self {
        case .aries: return "Aries individuals are enthusiastic and courageous trailblazers. They are natural leaders, driven by a strong sense of initiative and a desire to explore new possibilities."
        case .taurus: return "Taurus individuals are reliable and patient. They value stability and determination, often displaying a strong sense of dedication and practicality in everything they do."
        case .gemini: return "Gemini individuals are adaptable and curious communicators. They have a love for variety, often displaying a dual nature that fuels their intellectual pursuits."
        case .cancer: return "Cancer individuals are emotionally intuitive nurturers. Deeply connected to their feelings, they possess a strong sense of empathy and are often seen as caregivers."
        case .leo: return "Leo individuals are confident and creative leaders. They radiate charisma and self-assuredness, often taking center stage with their magnetic personality."
        case .virgo: return "Virgo individuals are detail-oriented and analytical. They have a keen focus on practical solutions and precision, often displaying a systematic approach in their endeavors."
        case .libra: return "Libra individuals seek balance and diplomacy in all aspects of life. They are harmonizers, striving for peace and fairness while maintaining a diplomatic approach."
        case .scorpio: return "Scorpio individuals are passionate and determined. Guided by intuition and intensity, they approach life with deep emotions and an unwavering determination."
        case .sagittarius: return "Sagittarius individuals are adventurous and optimistic. They have a free-spirited nature and are driven by a desire for independence and exploration."
        case .capricorn: return "Capricorn individuals are ambitious and disciplined achievers. Dedicated to responsibility and success, they approach life with a strong sense of determination."
        case .aquarius: return "Aquarius individuals are original and humanitarian. They advocate for independence and innovation, often displaying a progressive and visionary mindset."
        case .pisces: return "Pisces individuals are intuitive and compassionate dreamers. Immersed in imagination and empathy, they possess a deep connection to the emotional world."
        }
    }
    
    // MARK: Transit Experience Text
    // Transit Experiences
    enum TransitExperienceOption {
        case traits
        case emotional
        case practical
    }
    
    // Transit Experience String
    func transitExperience(_ version:TransitExperienceOption) -> String {
        switch version {
        case .traits:
            switch self {
            case .aries: return "A surge of energy and a desire for new beginnings characterize this transit for Aries individuals."
            case .taurus: return "Stability, determination, and focus on material security are highlighted during this transit for Taurus."
            case .gemini: return "Increased communication, curiosity, and adaptability define the transit for Gemini individuals."
            case .cancer: return "Emotional connection, intuition, and nurturing tendencies are prominent during this transit for Cancer."
            case .leo: return "Boosted confidence, creative expression, and a desire to lead are emphasized for Leo individuals during this transit."
            case .virgo: return "Heightened organization, practicality, and attention to detail mark this transit for Virgo."
            case .libra: return "Harmony, balance in relationships, and diplomatic approaches define the transit for Libra individuals."
            case .scorpio: return "Intensified emotions, deep intuition, and determination characterize this transit for Scorpio."
            case .sagittarius: return "Strong urges for exploration, optimism, and adventure are highlighted during this transit for Sagittarius."
            case .capricorn: return "Focused on career goals, discipline, and a sense of responsibility define this transit for Capricorn."
            case .aquarius: return "Inclination towards humanitarian causes, innovative thinking, and independence mark this transit for Aquarius."
            case .pisces: return "Heightened creativity, a deeper spiritual connection, and a compassionate nature define this transit for Pisces."
            }
        case .emotional:
            switch self {
            case .aries: return "Emotionally charged and driven by enthusiasm for new beginnings."
            case .taurus: return "Feeling emotionally secure and grounded, valuing stability and comfort."
            case .gemini: return "Emotionally stimulated and curious, seeking varied experiences."
            case .cancer: return "Deeply connected emotionally, nurturing and protective of loved ones."
            case .leo: return "Emotionally fulfilled when expressing creativity and receiving admiration."
            case .virgo: return "Emotionally satisfied through organized routines and attention to detail."
            case .libra: return "Emotionally balanced when fostering harmonious relationships and peace."
            case .scorpio: return "Emotionally intense and driven by powerful feelings and desires."
            case .sagittarius: return "Emotionally fulfilled when exploring new adventures and ideas."
            case .capricorn: return "Emotionally driven by ambition and achieving long-term goals."
            case .aquarius: return "Emotionally connected to humanitarian causes and innovative ideas."
            case .pisces: return "Emotionally sensitive and creative, deeply in tune with emotions and imagination."
            }
        case .practical:
            switch self {
            case .aries: return "During this transit, Aries individuals might feel driven to take bold actions and initiate new projects."
            case .taurus: return "Taurus individuals could focus on financial stability and practical matters, seeking long-term security."
            case .gemini: return "Gemini individuals might prioritize communication and networking, seeking practical solutions and exchanging ideas."
            case .cancer: return "Cancer individuals may focus on home and family matters, seeking emotional security and nurturing their loved ones."
            case .leo: return "Leos might channel their creativity into practical endeavors, seeking recognition and taking leadership roles."
            case .virgo: return "Virgos might focus on organizing and analyzing details, aiming for practical improvements in their work and routine."
            case .libra: return "Libra individuals might strive for balance and harmony in their relationships, seeking practical compromises."
            case .scorpio: return "Scorpios might delve deep into research or transformation, seeking practical solutions to personal or emotional issues."
            case .sagittarius: return "Sagittarius individuals might seek practical wisdom through learning or travel, expanding their horizons."
            case .capricorn: return "Capricorns could focus on career goals and practical achievements, aiming for long-term success."
            case .aquarius: return "Aquarius individuals might advocate for practical changes and innovations, seeking progress and societal improvements."
            case .pisces: return "Pisces individuals might engage in practical creativity or spiritual activities, seeking inner fulfillment."
            }
        }
    }
    
}
