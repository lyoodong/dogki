import SwiftUI
import Firebase

struct TestListView: View {
    @State private var items: [Item] = load("test.json")
    @State private var selectedItem: Item?
    @State private var selectedDomains: Set<Domain> = Set(Domain.allCases)
    @State private var isPresented: Bool = false
    
    @StateObject private var nativeViewService = NativeAdService(adUnitID: NativeAdStyle.listItem.adUnitID, numberOfAds: 5)
    
    private var displayItems: [Item] {
        return items.filter { item in
            !Set(item.domains).isDisjoint(with: selectedDomains)
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if !nativeViewService.isLoading && !nativeViewService.cachedAds.isEmpty {
                    NativeAdsView(nativeAd: nativeViewService.cachedAds[0], style: .listItem)
                        .padding(.horizontal, 16)
                        .frame(height: 80)
                }
                
                if displayItems.isEmpty {
                    EmptyListView()
                } else {
                    list(displayItems)
                }
            }
            .animation(.default, value: displayItems)
            .animation(.default, value: nativeViewService.isLoading)
            .toolbar(content: toolbarContent)
            .navigationTitle("기출 문제")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $selectedItem, content: sheetContent)
        .sheet(isPresented: $isPresented, content: filterSheetContent)
        .onAppear {
            print("Debugs, onAppear")
            let event = "appear_testList"
            Analytics.logEvent(event, parameters: nil)
            nativeViewService.refreshAd()
        }
    }
    
    private func toolbarContent () -> some View {
        Button {
            isPresented = true
            let event = "tap_filter"
            Analytics.logEvent(event, parameters: nil)
            
        } label: {
            Image(systemName: "line.3.horizontal.decrease")
                .foregroundStyle(.blue)
        }
    }
    
    private func list(_ items: [Item]) -> some View {
        List(items, id: \.self, rowContent: rowContent)
            .listStyle(.plain)
    }
    
    
    private func banner() -> some View {
        Rectangle()
            .fill(.blue)
            .frame(height: 52)
    }
    
    private func rowContent(_ item: Item) -> some View {
        HStack(alignment: .center) {
            thumbnailImage(for: item)
            infoText(for: item)
            Spacer(minLength: 12)
            moreButton(for: item)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            selectedItem = item
            let event = "tap_testListItem"
            let parameters: [String : Any] = [
                "id" : item.id,
                "title" : item.title,
                "subtitle" : item.subtitle,
                "month" : item.month.rawValue,
                "year" : item.year,
                "domains" : item.domains.map{ $0.description }.joined()
            ]
            
            Analytics.logEvent(event, parameters: parameters)
        }
    }
    
    @ViewBuilder
    private func thumbnailImage(for item: Item) -> some View {
        if let pdfURL = bundleUrl(for: item.id, with: "pdf") {
            TestDFThumbnailView(url: pdfURL)
                .frame(width: 48, height: 64)
                .cornerRadius(4)
        }
    }
    
    private func infoText(for item: Item) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            subHeadLine(item)
            headLine(item)
        }
    }
    
    private func subHeadLine(_ item: Item) -> some View {
        HStack {
            subTitle(item.subtitle)
            domains(item.domains)
        }
    }
    
    private func subTitle(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(.secondary)
            .font(.subheadline)
    }
    
    private func domains(_ domains: [Domain]) -> some View {
        HStack(spacing: 6) {
            ForEach(domains, id: \.self) { domain in
                Text(domain.description)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(domain.color.opacity(0.15))
                    .foregroundStyle(domain.color)
                    .cornerRadius(6)
            }
        }
    }
    
    private func headLine(_ item: Item) -> some View {
        Text(item.title)
            .font(.headline)
            .lineLimit(2)
    }
    
    private func moreButton(for item: Item) -> some View {
        Menu {
            shareButton(for: item)
                .onTapGesture {
                    let event = "tap_shareButton"
                    let parameters: [String : Any] = [
                        "id" : item.id,
                        "title" : item.title,
                        "subtitle" : item.subtitle,
                        "month" : item.month.rawValue,
                        "year" : item.year,
                        "domains" : item.domains.map{ $0.description }.joined()
                    ]
                    
                    Analytics.logEvent(event, parameters: parameters)
                }
        } label: {
            Image(systemName: "ellipsis")
                .frame(width: 36, height: 36)
        }
    }
    
    @ViewBuilder
    private func shareButton(for item: Item) -> some View {
        let label = { Label("내보내기", systemImage: "square.and.arrow.up") }
        if let pdfURL = bundleUrl(for: item.id, with: "pdf") {
            ShareLink(item: pdfURL, label: label)
        }
    }
    
    @ViewBuilder
    private func sheetContent(for item: Item) -> some View {
        if let url = bundleUrl(for: item.id, with: "pdf") {
            TestPDFPreView(for: url)
        } else {
            Text("PDF를 찾을 수 없습니다.")
        }
    }
    
    private func filterSheetContent() -> some View {
        TestFilter(selectedDomains: $selectedDomains)
    }
}

struct EmptyListView: View {
    var message: String = "문제가 없습니다"
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(.blue.opacity(0.8))
            
            Text(message)
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}


//import SwiftUI
//import Firebase
//
//// MARK: - TestListView
//
//struct TestListView: View {
//    @State private var items: [Item] = load("test.json")
//    @State private var selectedItem: Item?
//    @State private var selectedDomains: Set<Domain> = Set(Domain.allCases)
//    @State private var isPresented: Bool = false
//    @StateObject private var nativeViewModel = NativeAdViewModel(style: .listItem)
//    
//    private let adInterval = 5
//    
//    // 광고와 아이템을 섞은 리스트
//    private var mixedRows: [ListRow] {
//        var rows: [ListRow] = []
//        let filtered = items.filter { !Set($0.domains).isDisjoint(with: selectedDomains) }
//        
//        for (index, item) in filtered.enumerated() {
//            rows.append(.item(item))
//            if (index + 1) % adInterval == 0 {
//                rows.append(.ad(UUID().uuidString))
//            }
//        }
//        return rows
//    }
//    
//    var body: some View {
//        NavigationStack {
//            if mixedRows.isEmpty {
//                EmptyListView()
//            } else {
//                List {
//                    ForEach(mixedRows, id: \.id) { row in
//                        switch row {
//                        case .item(let item):
//                            rowContent(item)
//                                .listRowSeparator(.visible)
//                                .contentShape(Rectangle())
//                                .onTapGesture {
//                                    selectedItem = item
//                                    let event = "tap_testListItem"
//                                    let parameters: [String : Any] = [
//                                        "id" : item.id,
//                                        "title" : item.title,
//                                        "subtitle" : item.subtitle,
//                                        "month" : item.month.rawValue,
//                                        "year" : item.year,
//                                        "domains" : item.domains.map{ $0.description }.joined()
//                                    ]
//                                    Analytics.logEvent(event, parameters: parameters)
//                                }
//                            
//                        case .ad:
//                            if !nativeViewModel.isLoading && !nativeViewModel.isEmptyAds {
//                                NativeAdsView(nativeViewModel: nativeViewModel)
//                                    .frame(height: 80)
//                                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
//                                    .listRowSeparator(.hidden)
//                            } else {
//                                Color.clear
//                                    .frame(height: 0)
//                                    .listRowSeparator(.hidden)
//                            }
//                        }
//                    }
//                }
//                .listStyle(.plain)
//                .animation(.default, value: mixedRows)
//                .animation(.default, value: nativeViewModel.isLoading)
//            }
//        }
//        .toolbar(content: toolbarContent)
//        .navigationTitle("기출 문제")
//        .navigationBarTitleDisplayMode(.inline)
//        .sheet(item: $selectedItem, content: sheetContent)
//        .sheet(isPresented: $isPresented, content: filterSheetContent)
//        .onAppear {
//            Analytics.logEvent("appear_testList", parameters: nil)
//            nativeViewModel.refreshAd()
//        }
//    }
//}
//
//// MARK: - Toolbar
//
//extension TestListView {
//    private func toolbarContent() -> some View {
//        Button {
//            isPresented = true
//            Analytics.logEvent("tap_filter", parameters: nil)
//        } label: {
//            Image(systemName: "line.3.horizontal.decrease")
//                .foregroundStyle(.blue)
//        }
//    }
//}
//
//// MARK: - Row Rendering
//
//extension TestListView {
//    private func rowContent(_ item: Item) -> some View {
//        HStack(alignment: .center) {
//            thumbnailImage(for: item)
//            infoText(for: item)
//            Spacer(minLength: 12)
//            moreButton(for: item)
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//    }
//    
//    @ViewBuilder
//    private func thumbnailImage(for item: Item) -> some View {
//        if let pdfURL = bundleUrl(for: item.id, with: "pdf") {
//            TestDFThumbnailView(url: pdfURL)
//                .frame(width: 48, height: 64)
//                .cornerRadius(4)
//        }
//    }
//    
//    private func infoText(for item: Item) -> some View {
//        VStack(alignment: .leading, spacing: 6) {
//            subHeadLine(item)
//            headLine(item)
//        }
//    }
//    
//    private func subHeadLine(_ item: Item) -> some View {
//        HStack {
//            subTitle(item.subtitle)
//            domains(item.domains)
//        }
//    }
//    
//    private func subTitle(_ text: String) -> some View {
//        Text(text)
//            .foregroundStyle(.secondary)
//            .font(.subheadline)
//    }
//    
//    private func domains(_ domains: [Domain]) -> some View {
//        HStack(spacing: 6) {
//            ForEach(domains, id: \.self) { domain in
//                Text(domain.description)
//                    .font(.caption)
//                    .padding(.horizontal, 6)
//                    .padding(.vertical, 3)
//                    .background(domain.color.opacity(0.15))
//                    .foregroundStyle(domain.color)
//                    .cornerRadius(6)
//            }
//        }
//    }
//    
//    private func headLine(_ item: Item) -> some View {
//        Text(item.title)
//            .font(.headline)
//            .lineLimit(2)
//    }
//    
//    private func moreButton(for item: Item) -> some View {
//        Menu {
//            shareButton(for: item)
//                .onTapGesture {
//                    let event = "tap_shareButton"
//                    let parameters: [String : Any] = [
//                        "id" : item.id,
//                        "title" : item.title,
//                        "subtitle" : item.subtitle,
//                        "month" : item.month.rawValue,
//                        "year" : item.year,
//                        "domains" : item.domains.map{ $0.description }.joined()
//                    ]
//                    Analytics.logEvent(event, parameters: parameters)
//                }
//        } label: {
//            Image(systemName: "ellipsis")
//                .frame(width: 36, height: 36)
//        }
//    }
//    
//    @ViewBuilder
//    private func shareButton(for item: Item) -> some View {
//        let label = { Label("내보내기", systemImage: "square.and.arrow.up") }
//        if let pdfURL = bundleUrl(for: item.id, with: "pdf") {
//            ShareLink(item: pdfURL, label: label)
//        }
//    }
//}
//
//// MARK: - Sheet Views
//
//extension TestListView {
//    @ViewBuilder
//    private func sheetContent(for item: Item) -> some View {
//        if let url = bundleUrl(for: item.id, with: "pdf") {
//            TestPDFPreView(for: url)
//        } else {
//            Text("PDF를 찾을 수 없습니다.")
//        }
//    }
//    
//    private func filterSheetContent() -> some View {
//        TestFilter(selectedDomains: $selectedDomains)
//    }
//}
//
//// MARK: - Empty View
//
//struct EmptyListView: View {
//    var message: String = "문제가 없습니다"
//    
//    var body: some View {
//        VStack(spacing: 12) {
//            Image(systemName: "checkmark.circle.fill")
//                .font(.system(size: 40))
//                .foregroundColor(.blue.opacity(0.8))
//            
//            Text(message)
//                .font(.headline)
//                .foregroundColor(.secondary)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(.systemGroupedBackground))
//    }
//}
//
//// MARK: - ListRow Enum
//
//enum ListRow: Identifiable, Equatable {
//    case item(Item)
//    case ad(String)
//    
//    var id: String {
//        switch self {
//        case .item(let item): return item.id
//        case .ad(let uuid): return "ad-\(uuid)"
//        }
//    }
//}
