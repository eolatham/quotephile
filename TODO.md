# TODO

- Exit selection mode after bulk moves and deletes
- Fix bug where changing quote collection name kills quote collection view
  - This happens because changing the name sometimes changes the sections in the underlying sectioned fetch request (and quote collection views are dynamically rendered based on that)
- Add ability to bulk-import quotes into a quote collection from the clipboard or from a text file
- Add ability to bulk-export quotes to a text file
- Evaluate app performance with thousands of quotes
- Test backing up and restoring app data with iCloud backup
