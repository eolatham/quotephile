enum ValidationError: Error {
    case withMessage(String)
}

struct ErrorMessage {
    static let `default`: String = (
        "Something went wrong... " +
        "Please report this bug to the developer."
    )
    static let textEmpty: String = "Text is empty!"
    static let titleEmpty: String = "Title is empty!"
    static let quoteExists: String = "A quote with that text already exists!"
    static let quoteCollectionExists: String = "A quote collection with that title already exists!"
}
