import SwiftUI

struct TextListView: View {
    @State var items: [Item] = load("test.json")

    var body: some View {
        NavigationStack {
            List(items, id: \.self, rowContent: rowContent)
                .listStyle(.plain)
                .navigationTitle("기출 문제")
        }
        .onAppear {
            items.sort { $0.year > $1.year }
        }
        
    }
    
    private func rowContent(_ item: Item) -> some View {
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
                Text(domain.description)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(domain.color.opacity(0.15))
                    .foregroundColor(domain.color)
                    .cornerRadius(6)
            }
        }
    }
    
    private func headLine(_ item: Item) -> some View {
        Text(item.title)
            .font(.headline)
    }
}
