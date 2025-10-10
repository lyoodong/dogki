import Foundation

struct Item: Decodable, Hashable {
    let title: String
    let year: Int
    let month: Month
    let domains: [Domain]
    let type: Category?
    
    var subtitle: String {
        switch month {
        case .november:
            if let type = type {
                return "\(year)학년도 수능 \(type.description)형"
            } else {
                return "\(year)학년도 수능"
            }
        case .june, .september:
            if let type = type {
                return "\(year)학년도 \(month.description) 평가원 \(type.description)형"
            } else {
                return "\(year)학년도 \(month.description) 평가원"
            }
        }
    }
}
