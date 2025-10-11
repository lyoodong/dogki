import SwiftUI
import PDFKit

struct TestListPDFPreView: View {
    let url: URL
    @State private var thumbnail: UIImage?

    var body: some View {
        Group {
            if let image = thumbnail {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .animation(.easeInOut, value: image)
            } else {
                ProgressView()
            }
        }
        .task {
            thumbnail = await renderPDFThumbnail(from: url)
        }
    }

    private func renderPDFThumbnail(from url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let image = pdfThumbnail(from: url)
                continuation.resume(returning: image)
            }
        }
    }

    private func pdfThumbnail(from url: URL, width: CGFloat = 200) -> UIImage? {
        guard let pdfDocument = PDFDocument(url: url),
              let page = pdfDocument.page(at: 0) else { return nil }

        let pageRect = page.bounds(for: .mediaBox)
        let pdfScale = width / pageRect.width
        let scaledSize = CGSize(width: pageRect.width * pdfScale,
                                height: pageRect.height * pdfScale)

        UIGraphicsBeginImageContextWithOptions(scaledSize, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }

        UIColor.white.set()
        context.fill(CGRect(origin: .zero, size: scaledSize))

        context.saveGState()
        context.translateBy(x: 0, y: scaledSize.height)
        context.scaleBy(x: pdfScale, y: -pdfScale)
        page.draw(with: .mediaBox, to: context)
        context.restoreGState()

        let thumbnailImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return thumbnailImage
    }
}
