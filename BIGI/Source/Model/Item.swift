import Foundation

struct Item: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let year: Int
    let month: ExamMonth
    let domains: [Domain]

    var subtitle: String {
        switch month {
        case .november:
            return "\(year)학년도 수능"
        case .june, .september:
            return "\(year)학년도 \(month.description) 평가원"
        }
    }
}
