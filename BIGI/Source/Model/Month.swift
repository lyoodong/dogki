import Foundation

enum Month: Int, CaseIterable, CustomStringConvertible, Decodable {
    case june = 6
    case september = 9
    case november = 11

    var description: String {
        switch self {
        case .june: return "6월"
        case .september: return "9월"
        case .november: return "11월"
        }
    }
}
