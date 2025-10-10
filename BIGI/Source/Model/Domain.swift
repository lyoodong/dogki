import SwiftUI

enum Domain: String, CaseIterable, CustomStringConvertible, Decodable {
    case humanities
    case social
    case technology
    case science
    case reading
    case arts

    var description: String {
        switch self {
        case .humanities: return "인문"
        case .social: return "사회"
        case .technology: return "기술"
        case .science: return "과학"
        case .reading: return "독서론"
        case .arts: return "예술"
        }
    }

    var color: Color {
        switch self {
        case .humanities: return .red
        case .social: return .orange
        case .technology: return .blue
        case .science: return .green
        case .reading: return .purple
        case .arts: return .pink
        }
    }
}
