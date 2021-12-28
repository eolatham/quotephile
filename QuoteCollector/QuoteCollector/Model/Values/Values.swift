/**
 * A protocol for classes encapsulating user-editable entity values
 * and methods for formatting and validating them.
 */
protocol Values {
    /**
     * Formats all attributes that require formatting.
     * To be used when saving an entity.
     */
    func format()

    /**
     * Validates all attributes that require validation.
     * To be used when saving an entity.
     */
    func validate() throws
}
