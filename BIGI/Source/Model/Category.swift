import Foundation

enum Category: String, CustomStringConvertible, Decodable {
    case a = "A"
    case b = "B"
    
    var description: String {
        switch self {
        case .a:
            return "A"
        case .b:
            return "B"
        }
    }
}
