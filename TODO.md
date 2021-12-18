# TODO

- Add launch screen (see [here](https://betterprogramming.pub/launch-screen-with-swiftui-bd2958771f3b))
- Add ability to search and sort `Quotes` by tags
- Add ability to search for quotes in any `QuoteCollection`
  - This can be done by adding a default and immutable `QuoteCollection` called "All Quotes"
    - Make the `QuoteListView` `quoteCollection` parameter optional; without it, the view displays all quotes
    - Render a constant "All Quotes" `QuoteListView` (don't pass a `QuoteCollection`) before the `ForEach` in the `QuoteCollectionListView` component
- Finish `QuoteView` (add copy/share/edit functionality)
  - The user should be able to change `Quote` text, author, and collection attribute values
