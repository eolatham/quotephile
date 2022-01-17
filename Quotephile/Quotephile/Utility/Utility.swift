import Foundation

struct Utility {
    static func dateToMonthString(date: Date) -> String {
        return date.formatted(.dateTime.month(.wide).year())
    }

    static func cleanWhitespace(string: String) -> String {
        return string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .joined(separator: " ")
    }

    static func cleanWhitespace(string: Substring) -> String {
        return string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: " ")
            .joined(separator: " ")
    }

    static func join(strings: [String], separator: String = " ") -> String {
        return strings
            .joined(separator: separator)
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
