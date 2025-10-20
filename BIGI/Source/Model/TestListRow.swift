import Foundation

enum TestListRow: Identifiable, Equatable {
    case item(Item)
    case ad(Int)

    var id: String {
        switch self {
        case .item(let item): return item.id
        case .ad(let index): return "ad-\(index)"
        }
    }
}
