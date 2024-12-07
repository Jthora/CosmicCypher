//
//  CoreAstrology+Aspect.swift
//  CosmicCypher
//
//  Created by Jordan Trana on 11/20/23.
//

import SwiftAA
import Foundation

// MARK: Aspect
extension CoreAstrology {
    // Aspect
    public final class Aspect {
        // properties
        public var relation:AspectRelation
        public var primaryBody:AspectBody
        public var secondaryBody:AspectBody
        
        // accessors
        public var type:AspectType { return AspectType(primaryBodyType: primaryBody.type, relationType: relation.type, secondaryBodyType: secondaryBody.type) }
        public var hash:AspectType.SymbolHash { return type.hash }
        
        // MARK: Init
        // init
        public init(primaryBody:AspectBody, relation:AspectRelation, secondaryBody:AspectBody) {
            self.primaryBody = primaryBody
            self.secondaryBody = secondaryBody
            self.relation = relation
        }
        
        // init from AspectType and Date
        public init?(type:AspectType, date:Date) {
            guard let b1 = AspectBody(type: type.primaryBodyType, date: date),
                  let b2 = AspectBody(type: type.secondaryBodyType, date: date),
                  let d = b1.longitudeDifference(from: b2, on: date),
                  let r = AspectRelation(nodeDistance: d) else { return nil }
            self.primaryBody = b1
            self.secondaryBody = b2
            self.relation = r
        }
        
        // MARK: Methods
        // Difference between longitudes
        public func longitudeDifference(for date:Date) -> Degree? {
            return primaryBody.longitudeDifference(from: secondaryBody, on: date)
        }
        // Relative angle of aspect
        public var positionAngle:Degree {
            return primaryBody.positionAngle(relativeTo: secondaryBody)
        }
        /// ratio = orbDistance / orb
        public var concentration:Double? {
            return self.relation.concentration
        }
        // should remove
        public func shouldRemove(comparedTo other:CoreAstrology.Aspect) -> Bool {
            if relation.type == other.relation.type && primaryBody == other.secondaryBody && secondaryBody == other.primaryBody {
                return primaryBody.type.rawValue > other.primaryBody.type.rawValue
            }
            return false
        }
        // angle difference
        public func angleDiff(for date:Date, coords:GeographicCoordinates, magnitude:Bool = true) -> Degree? {
            let d = self.primaryBody.equatorialCoordinates.alpha.inDegrees - self.secondaryBody.equatorialCoordinates.alpha.inDegrees
            return magnitude ? abs(d) : d
        }
        // orb strength
        public var orbStrength:Double {
            let orb = self.relation.type.orb.value
            let dist = abs(self.relation.orbDistance.value)
            let strength = (orb - dist)/orb
            return strength
        }
        
        // MARK: Description
        // Combined Description
        public var planetNodeEffectDescription:String {
            let description = self.description
            let planetaryEffectDescription = self.planetaryEffectDescription()
            if description.count == planetaryEffectDescription.count {
                return self.planetaryEffectDescription(flipPlanets: true)
            }
            return planetaryEffectDescription
        }
        // Description
        public var description:String {
            return primaryBody.type.description + relation.defaultDescription + secondaryBody.type.description
        }
        // Short Description
        public var shortDescription:String {
            return primaryBody.type.shortDescription + relation.defaultDescription + secondaryBody.type.shortDescription
        }
        // Long Description
        public var longDescription:String {
            return primaryBody.type.longDescription + relation.defaultDescription + secondaryBody.type.longDescription
        }
        // Planetary Effect Description
        public func planetaryEffectDescription(flipPlanets:Bool = false) -> String {
            
            let relation = self.relation.type
            let primarybody = flipPlanets ? self.secondaryBody.type : self.primaryBody.type
            let secondaryBody = flipPlanets ? self.primaryBody.type : self.secondaryBody.type
            
            switch primarybody {
            case .sun:
                switch secondaryBody {
                case .moon:
                    switch relation {
                    case .conjunction: return self.description + "Revitalizing, new beginnings"
                    case .sextile: return self.description + "Gain through more work"
                    case .square: return self.description + "Don't force matter; patience needed"
                    case .trine: return self.description + "Ease with the opposite sex"
                    case .fiveTwelfth: return self.description + "Period of self-examination and transformation"
                    case .opposition: return self.description + "Hard work for little gain"
                    default: return self.description
                    }
                case .mercury:
                    switch relation {
                        case .conjunction: return self.description + "Short trip; pay attention to details"
                        case .sextile: return self.description + "Harmonious communication"
                        case .square: return self.description + "Challenges in communication; mental tension"
                        case .trine: return self.description + "Ease in expression; mental stimulation"
                        case .fiveTwelfth: return self.description + "Analytical thinking; seeking practical solutions"
                        case .opposition: return self.description + "Conflict in ideas; need for compromise"
                        default: return self.description
                    }
                case .venus:
                    switch relation {
                        case .conjunction: return self.description + "Harmony in relationships; artistic expression"
                        case .sextile: return self.description + "Positive connections; social ease"
                        case .square: return self.description + "Challenges in relationships; need for balance"
                        case .trine: return self.description + "Harmonious connections; emotional fulfillment"
                        case .fiveTwelfth: return self.description + "Creative endeavors; seeking pleasure"
                        case .opposition: return self.description + "Tensions in relationships; need for compromise"
                        default: return self.description
                    }
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Job accented; high energy, quarrels"
                    case .sextile: return self.description + "Nervous energy; need self-control"
                    case .square: return self.description + "Use restraint; quick acting"
                    case .trine: return self.description + "Finish projects, meet people"
                    case .fiveTwelfth: return self.description + "Fitful bursts of dynamic action"
                    case .opposition: return self.description + "Quarrels, energy needs direction"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Get out of a rut; philosophical"
                    case .sextile: return self.description + "Optimistic; big promises and dreams"
                    case .square: return self.description + "Personal problems; be philosophical"
                    case .trine: return self.description + "Financial opportunities, self-assurance"
                    case .fiveTwelfth: return self.description + "Exaggerated self-image can cause disagreements"
                    case .opposition: return self.description + "Extravagance, exaggeration, wasted time"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Think seriously about life direction"
                    case .sextile: return self.description + "Success; patient, steady efforts"
                    case .square: return self.description + "Losses from gambling; low energy"
                    case .trine: return self.description + "Good for dealing with authority"
                    case .fiveTwelfth: return self.description + "Minor obsticles presented by authority figures"
                    case .opposition: return self.description + "Hard work; responsibilites pile up"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Keep mind on job, magnetism"
                    case .sextile: return self.description + "Original, put creative ideas into action"
                    case .square: return self.description + "Make mistakes, keep action steady"
                    case .trine: return self.description + "Excitement and fun, life of the party"
                    case .fiveTwelfth: return self.description + "Rebellion against selfish interest"
                    case .opposition: return self.description + "Resentment, dicord; be tactful"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Active imagination, inspiration"
                    case .sextile: return self.description + "Meditation, inner understanding"
                    case .square: return self.description + "Judgement poor; postpone decisions"
                    case .trine: return self.description + "Idealism, friendship, romance"
                    case .fiveTwelfth: return self.description + "Opportunity to glimpse own spiritual nature"
                    case .opposition: return self.description + "Impractical, idealistic"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Increased aggressiveness, independence"
                    case .sextile: return self.description + "Community groups, creative changes"
                    case .square: return self.description + "Others' plans conflict with yours"
                    case .trine: return self.description + "Make progressive changes"
                    case .fiveTwelfth: return self.description + "Struggle between ego and spiritual will"
                    case .opposition: return self.description + "More agressive; possible unwise action"
                    default: return self.description
                    }
                default: return self.description
                }
            case .moon:
                switch secondaryBody {
                case .mercury:
                    switch relation {
                    case .conjunction: return self.description + "Temperamental actions and words"
                    case .sextile: return self.description + "Quick thinking, many ideas"
                    case .square: return self.description + "Restlessness, indecision, worry"
                    case .trine: return self.description + "Reach decisions, persuade others"
                    case .fiveTwelfth: return self.description + "Need for balancing thinking and emotions"
                    case .opposition: return self.description + "Handle routine work and details"
                    default: return self.description
                    }
                case .venus:
                    switch relation {
                    case .conjunction: return self.description + "Ideas of beauty and decoration"
                    case .sextile: return self.description + "Harmony; affectionate, cheerful"
                    case .square: return self.description + "Relax with friends, extravagance"
                    case .trine: return self.description + "Beautiful purchases, redecoration"
                    case .fiveTwelfth: return self.description + "Discrimination required in romantic situations"
                    case .opposition: return self.description + "Excess in emotions, extravagance"
                    default: return self.description
                    }
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Keep active, finish tasks"
                    case .sextile: return self.description + "Nervousness and excitement"
                    case .square: return self.description + "Impulsive, emotional thinking"
                    case .trine: return self.description + "Harmony; cheerful and exciting"
                    case .fiveTwelfth: return self.description + "Direct, impulsive emotions"
                    case .opposition: return self.description + "High energy, but not cooperation"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Contentment, optimism; idealistic"
                    case .sextile: return self.description + "Cheerful; cooperation"
                    case .square: return self.description + "Excess, broken promises; impractical"
                    case .trine: return self.description + "Overly optimistic progress with ideas"
                    case .fiveTwelfth: return self.description + "Questions concerning philosophical outlook"
                    case .opposition: return self.description + "Extravagance, should seek enjoyment"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Dependability, responsibility"
                    case .sextile: return self.description + "Easy to help those in need; good advice"
                    case .square: return self.description + "Disciplined work, serious thinking"
                    case .trine: return self.description + "Accomplishment through patience"
                    case .fiveTwelfth: return self.description + "Need to examine repressed emotions"
                    case .opposition: return self.description + "Stick with plans, efficency; budget time"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "High hopes, unrealistic plans"
                    case .sextile: return self.description + "Original, inventive, creative"
                    case .square: return self.description + "Erratic or eccentric behavior, quick mind"
                    case .trine: return self.description + "Originality; influence others"
                    case .fiveTwelfth: return self.description + "Abrupt changes in moods unsettle old patterns"
                    case .opposition: return self.description + "Distractions, unvonventional acts or thoughts"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Distractions, sensitive emotions"
                    case .sextile: return self.description + "Intuitions, creativity, meditations"
                    case .square: return self.description + "Judgement poor; gullible, impressionable"
                    case .trine: return self.description + "Idealistic, romantic, friendly"
                    case .fiveTwelfth: return self.description + "Discriminate between apathy and relaxation"
                    case .opposition: return self.description + "Distruct intuition, postpone decisions"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Involvement with others, quiet conversations"
                    case .sextile: return self.description + "Enlightening descussions, intense feelings"
                    case .square: return self.description + "Make few demands on others and yourself"
                    case .trine: return self.description + "Romance, pleasure, popularity"
                    case .fiveTwelfth: return self.description + "Emotional upheavals threan inner security"
                    case .opposition: return self.description + "Daydreams, snags in plans"
                    default: return self.description
                    }
                default: return self.description
                }
            case .mercury:
                switch secondaryBody {
                case .venus:
                    switch relation {
                    case .conjunction: return self.description + "More artistic and pleasant"
                    case .sextile: return self.description + "Emotional happiness and calm"
                    case .square: return self.description + "Write letters, make phone calls"
                    case .trine: return self.description + "Unexpected meetings, social invitations"
                    case .fiveTwelfth: return self.description + "Misunderstood affection"
                    case .opposition: return self.description + "Meet new people, conversations"
                    default: return self.description
                    }
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Ideas abound; impulsive, easy communications"
                    case .sextile: return self.description + "Good sense of humor, social ease"
                    case .square: return self.description + "Touchy; challenge in communications"
                    case .trine: return self.description + "Quick mind; can get your point across"
                    case .fiveTwelfth: return self.description + "Avoid nervous overstrain"
                    case .opposition: return self.description + "Be tactful, could have arguments"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Good news; study; tolerant"
                    case .sextile: return self.description + "Reunions, travel plans, new ideas"
                    case .square: return self.description + "Quick to jump to conclusions"
                    case .trine: return self.description + "Interesting and reqarding work"
                    case .fiveTwelfth: return self.description + "exaggerated ideas cloud judgement"
                    case .opposition: return self.description + "Be practical; the center of everyone's attention"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Serious thinking; attention to details"
                    case .sextile: return self.description + "Plan ahead; good judgement"
                    case .square: return self.description + "Be diplomatic, avoid stubbornness"
                    case .trine: return self.description + "Make realistic decisions for your future"
                    case .fiveTwelfth: return self.description + "Laborious thinking impedes communication"
                    case .opposition: return self.description + "Delay in plans, watch what you put into writing"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Mind sparks with original ideas"
                    case .sextile: return self.description + "Can find support for your ideas"
                    case .square: return self.description + "Sarcastic; don't worry about things"
                    case .trine: return self.description + "New friends; social life exciting"
                    case .fiveTwelfth: return self.description + "Need to concentrate on one interest at a time"
                    case .opposition: return self.description + "Temperamental; many small irritations"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Confused or idealistic thinking"
                    case .sextile: return self.description + "Intuitie awareness, cleverness"
                    case .square: return self.description + "Escapist tendencies, laziness"
                    case .trine: return self.description + "Romantic, idealistic thoughts"
                    case .fiveTwelfth: return self.description + "Healing through creative visualizations"
                    case .opposition: return self.description + "Gossip, scandalous news"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Be subtle, not forceful"
                    case .sextile: return self.description + "Get small tasks done quickly"
                    case .square: return self.description + "Minor mistakes, overspending"
                    case .trine: return self.description + "Can gain support for special plan"
                    case .fiveTwelfth: return self.description + "Implusive, outspoken; some quarrels"
                    case .opposition: return self.description + "Careful analysis of psychological imbalances"
                    default: return self.description
                    }
                default: return self.description
                }
            case .venus:
                switch secondaryBody {
                case .mars:
                    switch relation {
                    case .conjunction: return self.description + "Popular; extravagance, love"
                    case .sextile: return self.description + "Can easily express your feelings"
                    case .square: return self.description + "Extravagance with pleasures and luxuries"
                    case .trine: return self.description + "Can put values and beliefs into action"
                    case .fiveTwelfth: return self.description + "Sexual desires need refined expression"
                    case .opposition: return self.description + "Can be imposed on; sensitive feelings"
                    default: return self.description
                    }
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Life seems happier, more joyful"
                    case .sextile: return self.description + "Friendly to all; lighthearted"
                    case .square: return self.description + "Personal ubset; sensitive feelings"
                    case .trine: return self.description + "You recieve the rewards you deserve"
                    case .fiveTwelfth: return self.description + "Reassessment of a romantic partner"
                    case .opposition: return self.description + "Be practical and realistic in all plans"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Make plans for parties and get-togethers"
                    case .sextile: return self.description + "New career opportunities, success"
                    case .square: return self.description + "May be sarcastic with loved ones"
                    case .trine: return self.description + "Sincere, realistic, stable"
                    case .fiveTwelfth: return self.description + "Unconscious scruples upset romantic harmony"
                    case .opposition: return self.description + "Don't compare yourself with others; duty"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "May be attracted to a new love interest"
                    case .sextile: return self.description + "Peaceful thoughts end arguments"
                    case .square: return self.description + "Excitement in love life"
                    case .trine: return self.description + "Surround yourself with beauty and pleasure"
                    case .fiveTwelfth: return self.description + "Restlessness in a relationship; seeking freedom"
                    case .opposition: return self.description + "Impulsive feelings, changes in mood"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Creative, romantic time"
                    case .sextile: return self.description + "Can recieve a cherished hope or wish"
                    case .square: return self.description + "Let your light and your talents shine"
                    case .trine: return self.description + "Redecoration, creativity, daydreaming"
                    case .fiveTwelfth: return self.description + "Express musical inspirations"
                    case .opposition: return self.description + "Impractical idealism, deceptive thoughts"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Don't force a commitment from a loved one"
                    case .sextile: return self.description + "Take the initiative, don't sit at home"
                    case .square: return self.description + "May judge others too harshly"
                    case .trine: return self.description + "Romantic happiness, friendships"
                    case .fiveTwelfth: return self.description + "A fading relationship dies"
                    case .opposition: return self.description + "Exciting romance could start"
                    default: return self.description
                    }
                default: return self.description
                }
            case .mars:
                switch secondaryBody {
                case .jupiter:
                    switch relation {
                    case .conjunction: return self.description + "Optimistic, willing to take a chance"
                    case .sextile: return self.description + "Can use your talents to get what you want"
                    case .square: return self.description + "Urge to get away from everything"
                    case .trine: return self.description + "Can make progress at work and home"
                    case .fiveTwelfth: return self.description + "Overly exuberant"
                    case .opposition: return self.description + "Avoid extravagance, add to your security"
                    default: return self.description
                    }
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Tackle all projects that take a lot of energy"
                    case .sextile: return self.description + "Work goes smoothly if preplanned"
                    case .square: return self.description + "Duties may be forced on you by others"
                    case .trine: return self.description + "Good time for reunion with old friends or family"
                    case .fiveTwelfth: return self.description + "Nervous restraint"
                    case .opposition: return self.description + "Nervousness, inability to act"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Take it easy, don't get excited"
                    case .sextile: return self.description + "Good with anything you attempt; success"
                    case .square: return self.description + "False starts, accidents, high-strung"
                    case .trine: return self.description + "Think about your future, not your past"
                    case .fiveTwelfth: return self.description + "Rash and impulsive actions"
                    case .opposition: return self.description + "Self-control in thinking and acting needed"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Impracticality with money and energy"
                    case .sextile: return self.description + "Changes can lead to excitement"
                    case .square: return self.description + "Laziness, procrastination, religious fanaticism"
                    case .trine: return self.description + "Intuitively know what to do and how to do it"
                    case .fiveTwelfth: return self.description + "Under-energized, delusional dreams"
                    case .opposition: return self.description + "Don't force others to act when you don't"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Difficult to handle personal matters"
                    case .sextile: return self.description + "Will be able to tackle any problem"
                    case .square: return self.description + "Not the time to make changes in your life"
                    case .trine: return self.description + "Can clear away the clutter in your life"
                    case .fiveTwelfth: return self.description + "Restlessness and unease; causes unknown"
                    case .opposition: return self.description + "Restlessness; strong desire for changes"
                    default: return self.description
                    }
                default: return self.description
                }
            case .jupiter:
                switch secondaryBody {
                case .saturn:
                    switch relation {
                    case .conjunction: return self.description + "Orderly; prudent expansion toward objectives"
                    case .sextile: return self.description + "Confidence and achievement"
                    case .square: return self.description + "Lack of purpose and faith; Ill-timing"
                    case .trine: return self.description + "Faith in destiny; inspired constructiveness"
                    case .fiveTwelfth: return self.description + "Restlessness and unease"
                    case .opposition: return self.description + "Vacillation and doubt of goals and ambitions"
                    default: return self.description
                    }
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Unexpected good fortune or understanding"
                    case .sextile: return self.description + "New consideration"
                    case .square: return self.description + "Zesty pursuit or unfeasible tangents"
                    case .trine: return self.description + "New and firtuitous insights"
                    case .fiveTwelfth: return self.description + "Distruct of shared values and ideals"
                    case .opposition: return self.description + "Disorienting, sudden developments"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Creative and spiritual optimism"
                    case .sextile: return self.description + "Mystical inspiration"
                    case .square: return self.description + "Unsound approach to abstract, mystical ideas"
                    case .trine: return self.description + "Access to universal love and creativity"
                    case .fiveTwelfth: return self.description + "Beliefs overstep ideals"
                    case .opposition: return self.description + "Hold conflicting views about reality and idealism"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Efforts at psychological improvement"
                    case .sextile: return self.description + "Interest in spiritual, psychological, occult ideas"
                    case .square: return self.description + "Coercive use of willpower for a \"spiritual\" goal"
                    case .trine: return self.description + "Spiritual, psychological regeneration and growth"
                    case .fiveTwelfth: return self.description + "Conflict between truth and emotions"
                    case .opposition: return self.description + "Gradiose, exploitive schemes that tend to fail"
                    default: return self.description
                    }
                default: return self.description
                }
            case .saturn:
                switch secondaryBody {
                case .uranus:
                    switch relation {
                    case .conjunction: return self.description + "Tension to build; constructive alertness"
                    case .sextile: return self.description + "Limited creative freedom"
                    case .square: return self.description + "Conflict between independence and success"
                    case .trine: return self.description + "Success where others fail; quick insight"
                    case .fiveTwelfth: return self.description + "Uptight about limited independence"
                    case .opposition: return self.description + "Frustrating resistance, non-submission, accidents"
                    default: return self.description
                    }
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "Focus on spiritual objectives; mystical cynicism"
                    case .sextile: return self.description + "Spiritual insights further ambitions"
                    case .square: return self.description + "Escape from responsibility; loss of ambition"
                    case .trine: return self.description + "Hidden resources give support"
                    case .fiveTwelfth: return self.description + "Imagination is distrusted"
                    case .opposition: return self.description + "Hidden influences impede material goals"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Externalization of psychological realities"
                    case .sextile: return self.description + "Increased self-discipline and moral integrity"
                    case .square: return self.description + "Watch out for dangerous circumstances"
                    case .trine: return self.description + "Willpower to accomplish objectives easily"
                    case .fiveTwelfth: return self.description + "Haunting fear of failure"
                    case .opposition: return self.description + "Coercive suppression by self or others"
                    default: return self.description
                    }
                default: return self.description
                }
            case .uranus:
                switch secondaryBody {
                case .neptune:
                    switch relation {
                    case .conjunction: return self.description + "New mystical, spiritual impressions and feelings"
                    case .sextile: return self.description + "New interests in the spiritual side of life"
                    case .square: return self.description + "Deluded freedom, sudden mistaken impressions"
                    case .trine: return self.description + "Sudden helpful precognitions, imaginations"
                    case .fiveTwelfth: return self.description + "Hidden, revolutionary disturbances"
                    case .opposition: return self.description + "Erratic behavior caused by deluded motivations"
                    default: return self.description
                    }
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Sudden expression of strong emotions"
                    case .sextile: return self.description + "New psychological awareness"
                    case .square: return self.description + "Emotional strife, fanaticism, upsets, disturbance"
                    case .trine: return self.description + "Powerful, helpful release of emotional energy"
                    case .fiveTwelfth: return self.description + "Uncorrdinated energy inputs and outputs"
                    case .opposition: return self.description + "Ideals oppose emotional drive"
                    default: return self.description
                    }
                default: return self.description
                }
            case .neptune:
                switch secondaryBody {
                case .pluto:
                    switch relation {
                    case .conjunction: return self.description + "Imagination and desire unite"
                    case .sextile: return self.description + "Desire to create"
                    case .square: return self.description + "Desire impeded by delusion"
                    case .trine: return self.description + "Spiritual goodwill; help from beyond"
                    case .fiveTwelfth: return self.description + "Deluded drive; emotion oversteps reality"
                    case .opposition: return self.description + "Unconcious conflict"
                    default: return self.description
                    }
                default: return self.description
                }
            default: return self.description
            }
        }
    }
}
