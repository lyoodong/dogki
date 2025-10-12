import SwiftUI

struct TestListView: View {
    @State private var items: [Item] = load("test.json")
    @State private var selectedItem: Item?
    @State private var selectedDomains: Set<Domain> = Set(Domain.allCases)
    @State private var isPresented: Bool = false
    
    private var displayItems: [Item] {
        return items.filter { item in
            !Set(item.domains).isDisjoint(with: selectedDomains)
        }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if displayItems.isEmpty {
                    EmptyListView()
                } else {
                    list(displayItems)
                }
                
                banner()
            }
            .animation(.default, value: displayItems)
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(content: toolbarContent)
            .navigationTitle("기출 문제")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(item: $selectedItem, content: sheetContent)
        .sheet(isPresented: $isPresented, content: filterSheetContent)
    }

    private func toolbarContent () -> some View {
        Button {
            isPresented = true
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
        .onTapGesture { selectedItem = item }
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
