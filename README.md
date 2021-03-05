# PasteboardMonitor

PasteboardMonitor is a simple library that adds a Combine publisher to AppKit's `NSPasteboard` class.

This library is a work in progress, and is not yet fully tested. It is being developed alongside my pasteboard filtering app, [Plain Pasta](https://github.com/hisaac/PlainPasta). Please refer to that code for a working example of usage.

I created this as a learning exercise to help gain understanding of Combine, and also as a chance to help out the macOS developer community, even in a small way. There is currently no way to "subscribe" to changes on an `NSPasteboard`, so it must be done by repeatedly polling the pasteboard's `changeCount`. This library abstracts that away, and adds a Combine `Publisher` API.

Future plans are to also add an `NSNotificationCenter` emitter if consumers prefer to use that interface.

I used many articles to build this library, but the one that finally connected the dots for me was [<cite>Creating a custom Combine Publisher to extend UIKit</cite>](https://www.avanderlee.com/swift/custom-combine-publisher/) by [Antoine van der Lee](https://www.avanderlee.com/about/).
