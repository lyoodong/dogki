import SwiftUI

enum Tap: CaseIterable, CustomStringConvertible, Identifiable {
    case test
    case setting
}

extension Tap {
    var id: String { self.description }
    
    var description: String {
        switch self {
        case .test:
            "기출 문제"
        case .setting:
            "설정"
        }
    }
    
    var systemImage: String {
        switch self {
        case .test:
            "text.document"
        case .setting:
            "gearshape"
        }
    }
    
    @ViewBuilder
    var content: some View {
        switch self {
        case .test:
            TestListView()
        case .setting:
            Text("설정")
        }
    }
}
