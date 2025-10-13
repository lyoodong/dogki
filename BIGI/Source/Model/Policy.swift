enum Policy: CaseIterable, CustomStringConvertible, Identifiable {
    case term
    case privacy
    
    var id: String {
        return description
    }
    
    var url: String {
        switch self {
        case .term:
            return "https://example.com/terms"
        case .privacy:
            return "https://example.com/privacy"
        }
    }
    
    var description: String {
        switch self {
        case .term:
            "서비스 이용 약관"
        case .privacy:
            "개인정보처리 방침"
        }
    }
    
    var systemImage: String {
        switch self {
        case .term:
            "text.page.fill"
        case .privacy:
            "figure.child.and.lock.fill"
        }
    }
}
