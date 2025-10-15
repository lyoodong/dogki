import Foundation

enum UserSupport: String, CaseIterable, CustomStringConvertible, Identifiable {
    case review
    case email
    
    var id: String {
        return description
    }
    
    var description: String {
        switch self {
        case .review:
            "리뷰 남기기"
        case .email:
            "피드백 보내기"
        }
    }
    
    var systemImage: String {
        switch self {
        case .review:
            "star.fill"
        case .email:
            "envelope.fill"
        }
    }
}
