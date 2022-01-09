# Quotephile

Author: Eric Latham

Email: ericoliverlatham@gmail.com

## Description

An [iOS app](https://apps.apple.com/us/app/quotephile/id1602992535) that makes it easy to collect, organize, and share text quotes

## Development

Developing this app was my first experience with Swift, iOS app development, and mobile app development in general, and it was both infuriating and delightful.

I began with merely an idea of an app that I would want to use to organize all of my favorite quotes (because despite the massive number of apps that exist, I could never find one dedicated to storing a personal collection of quotes, much less doing it _well_).

I used [this tutorial](https://www.raywenderlich.com/27201015-dynamic-core-data-with-swiftui-tutorial-for-ios) as a template to build off of, and I learned the ins and outs of the Swift programming language and SwiftUI as I went along (with the help of countless other online tutorials, StackOverflow posts, and Apple's developer documentation).

Despite my lack of formal education in iOS app development, I was able to put this thing together in about 3 weeks, and the final product is something I use every day!

## Features

### Create

- Create a quote collection with a unique name to hold quotes
- Create a quote with unique text, an author, a work, and tags
- Create many quotes at once from a line-delimited list

### List

- List all quote collections
- List all quotes in a specific quote collection
- List all quotes in all quote collections

### Search

- Search for quote collections by name
- Search for quotes by text, author, work, and tags

### Sort

- Sort quote collections by name, date created, and date changed
- Sort quotes by tags, author first name, author last name, work, date created, and date changed
- Persist sort settings on a per-view basis

### Collapse

- Collapse sections of sorted quotes or quote collections while navigating through them

### Select

- Select quotes or quote collections individually and by section
- Invert the current selection of quotes or quote collections

### Edit

- Rename a quote collection individually
- Edit a quote individually to change its text, author, work, and tags
- Edit a selection of quotes in bulk to overwrite their authors and works and edit their tags
  - If editing tags, choose to replace tags, add tags, or remove tags

### Move

- Move a quote individually to another quote collection
- Move a selection of quotes in bulk to another quote collection

### Delete

- Delete a quote collection individually (which also deletes all of its quotes)
- Delete a selection of quote collections in bulk (which also deletes all of their quotes)
- Delete a quote individually
- Delete a selection of quotes in bulk

### Style

- Customize the style of a quote in display mode by choosing whether or not to surround it with quotation marks, to include its author and work, and to put the author and work on a new line
- Persist style settings on a per-quote basis

### Share

- Copy a quote from its display view

### Export

- Export a selection of quotes to a text file

### Backup

- Create a backup file containing all currently saved quote collections

### Restore

- Restore quote collections from a saved backup file

## Privacy Policy

- Quotephile does not collect any personal information from users.
- Quotephile simply provides a convenient interface for managing local data (user-generated quotes) on an iOS device.
- Content created within Quotephile is saved directly to the device that the app is installed on and is never uploaded, sent, or otherwise shared anywhere else by Quotephile without the user's explicit consent.
