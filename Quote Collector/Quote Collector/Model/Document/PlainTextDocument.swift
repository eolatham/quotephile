import SwiftUI
import UniformTypeIdentifiers

/**
 * Used to export quotes to a text file.
 * Adapted from [this article](https://betterprogramming.pub/importing-and-exporting-files-in-swiftui-719086ec712).
 */
struct PlainTextDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.plainText] }

    var text: String

    init(text: String) {
        self.text = text
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else { throw CocoaError(.fileReadCorruptFile) }
        text = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: text.data(using: .utf8)!)
    }

    static func quoteList(quotes: Set<Quote>) -> PlainTextDocument {
        return PlainTextDocument(
            text: quotes.map({ quote in quote.exportText })
                        .joined(separator: "\n\n")
        )
    }
}
