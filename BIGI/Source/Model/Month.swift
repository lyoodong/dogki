import Foundation

enum Month: String, CaseIterable, CustomStringConvertible, Decodable {
    case june
    case september
    case november

    var description: String {
        switch self {
        case .june: return "6월"
        case .september: return "9월"
        case .november: return "11월"
        }
    }
}
