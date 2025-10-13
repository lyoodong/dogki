import Foundation

enum Info: CaseIterable, CustomStringConvertible, Identifiable {
    case version
    
    var id: String {
        return description
    }
    
    var description: String {
        switch self {
        case .version:
            return "앱 버전"
        }
    }
    
    var systemImage: String {
        switch self {
        case .version:
            return "info.circle"
        }
    }
}
