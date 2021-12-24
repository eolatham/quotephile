# TODO

- Make @FetchRequest sorts and predicates fully dynamic (no hardcoded default parameters)
  - Default values are reused every time the request is re-executed, which resets user-changed sort/search settings
- Add ability to bulk-edit selected (or all by default) quotes in a quote collection:
  - "Move" button that appears in selection mode and triggers sheet allowing:
    - Move to a different quote collection
  - "Edit" button that appears in selection mode and triggers sheet allowing:
    - Overwrite author
    - Overwrite tags
    - Add tags
    - Remove tags
  - "Delete" button that appears in selection mode and triggers sheet allowing:
    - Delete quotes
- Add ability to bulk-import quotes into a quote collection from the clipboard or from a text file
