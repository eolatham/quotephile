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

    static func join(strings: [String?], separator: String = "\n") -> String {
        var joined = ""
        for s in strings {
            if s != nil {
                if joined.isEmpty { joined = s! }
                else { joined = joined + separator + s! }
            }
        }
        return joined
    }
}
