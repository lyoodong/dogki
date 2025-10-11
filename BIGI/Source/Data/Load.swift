import Foundation

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = bundleUrl(for: filename)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func bundleUrl(for name: String, with withExtension: String? = nil) -> URL? {
    Bundle.main.url(forResource: name, withExtension: withExtension)
}
