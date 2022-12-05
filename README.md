# PasteboardPublisher

PasteboardPublisher is a simple library that adds a Combine publisher to AppKit's `NSPasteboard` class.

I created this because there is currently no way to "subscribe" to changes to an `NSPasteboard`, so it must be done by repeatedly polling the pasteboard's `changeCount`. This library just abstracts that away, and adds Combine compatability. I used this library in my pasteboard filtering app, [Plain Pasta](https://github.com/hisaac/PlainPasta), to great success.

I used many articles to build this library, but the one that finally connected the dots for me was [<cite>Creating a custom Combine Publisher to extend UIKit</cite>](https://www.avanderlee.com/swift/custom-combine-publisher/) by [Antoine van der Lee](https://www.avanderlee.com/about/).
