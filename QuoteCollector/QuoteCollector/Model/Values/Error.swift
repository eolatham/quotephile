enum ValidationError: Error {
    case withMessage(String)
}

struct ErrorMessage {
    static let `default`: String = (
        "Something went wrong... " +
        "Please report this bug to the developer."
    )
    static let nameEmpty: String = "Name is empty!"
    static let nameTooLong: String = "Name is too long!"
    static let textEmpty: String = "Text is empty!"
    static let textTooLong: String = "Text is too long!"
    static let authorFirstNameTooLong: String = "Author first name is too long!"
    static let authorLastNameTooLong: String = "Author last name is too long!"
    static let tagsTooLong: String = "Tags are too long!"
}
