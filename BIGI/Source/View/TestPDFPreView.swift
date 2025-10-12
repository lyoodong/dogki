import SwiftUI
import PDFKit

struct PDFRepresentableView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> PDFView {
        let view = PDFView()
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        view.displayDirection = .vertical
        view.backgroundColor = .systemBackground
        view.document = PDFDocument(url: url)
        return view
    }
    
    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct TestPDFPreView: View {
    @Environment(\.dismiss) private var dismiss
    let url: URL
    
    init(for url: URL) {
        self.url = url
    }

    var body: some View {
        NavigationStack {
            PDFRepresentableView(url: url)
                .navigationTitle("미리보기")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(content: toolBarContent)
        }
    }
    
    private func toolBarContent() -> some ToolbarContent {
        let action = {dismiss() }
        let label = { Image(systemName: "xmark").foregroundStyle(.blue) }
        
        return ToolbarItem(placement: .topBarTrailing) {
            Button(action: action, label: label)
        }
    }
}
