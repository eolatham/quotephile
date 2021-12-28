/**
 * A protocol for classes encapsulating user-editable entity values
 * and methods for formatting and validating them.
 */
protocol Values {
    /**
     * Formats all attributes that require formatting and
     * validates all attributes that require validation.
     * To be used before saving an entity.
     */
    func formatAndValidate() throws
}
