enum ValidationError: Error {
    case withMessage(String)
}

struct ErrorMessage {
    static let `default`: String = (
        "Something went wrong... " +
        "Please report this bug to the developer."
    )
    static let textEmpty: String = "Text is empty!"
    static let nameEmpty: String = "Name is empty!"
}
