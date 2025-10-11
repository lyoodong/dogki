import SwiftUI
import PDFKit

struct TestListView: View {
    @State var items: [Item] = load("test.json")
    
    var body: some View {
        NavigationStack {
            VStack {
                list(items)
                banner()
            }
            .ignoresSafeArea(.all, edges: .bottom)
            .toolbar(content: toolbarContent)
        }
        .onAppear {
            items.sort { $0.year > $1.year }
        }
    }
    
    private func toolbarContent () -> some View {
        Button {
            print("필터 액션")
        } label: {
            Image(systemName: "line.3.horizontal.decrease.circle")
                .foregroundStyle(.blue)
        }
    }

    private func list(_ items: [Item]) -> some View {
        List(items, id: \.self, rowContent: rowContent)
            .listStyle(.plain)
            .navigationTitle("기출 문제")
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
            shareButton(for: item)
        }
    }
    
    @ViewBuilder
    private func thumbnailImage(for item: Item) -> some View {
        if let pdfURL = bundleUrl(for: "20260902", with: "pdf"){
            TestListPDFPreView(url: pdfURL)
                .frame(width: 40)
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
        HStack {
            ForEach(domains, id: \.self) { domain in
                HStack(spacing: 4) {
                    Image(systemName: "folder.fill")
                        .imageScale(.small)
                    Text(domain.description)
                }
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
    }
    
    @ViewBuilder
    private func shareButton(for item: Item) -> some View {
        if let pdfURL = bundleUrl(for: "20260902", with: "pdf"){
            ShareLink(item: pdfURL, label: shareLinkLabel)
                .buttonStyle(.plain)
        }
    }
    
    private func shareLinkLabel() -> some View {
        Image(systemName: "square.and.arrow.up")
            .imageScale(.medium)
            .foregroundStyle(.blue)
            .frame(width: 40, height: 40)
            .background(Material.ultraThin, in: Circle())
    }
}
