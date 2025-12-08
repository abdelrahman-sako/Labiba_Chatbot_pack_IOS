//
//  AppState.swift
//  Visit Jordan Bot
//
//  Created by AhmeDroid on 9/21/16.
//  Copyright © 2016 Imagine Technologies. All rights reserved.
//

import UIKit
import Foundation

class Emoticonizer
{
    class func emoticonizeString(aString: String) -> String
    {

        let mappings = [
            //Please refer to this link: http://unicode.org/emoji/charts/full-emoji-list.html
            //Facebook keyboard shortcuts: http://www.shoutmeloud.com/list-of-facebook-keyboard-shortcuts-and-emoticons.html
            ":P": "\u{1F61C}",
            ":-P": "\u{1F61C}",

            ":D": "\u{1F604}",
            ":-D": "\u{1F604}",

            ":)": "\u{1F642}",
            ":-)": "\u{1F642}",

            ":|": "\u{1F610}",
            ">.<": "\u{1F606}",
            ">_<": "\u{1F606}",
            ";)": "\u{1F609}",
            "=P": "\u{1F60B}",
            ":J": "\u{1F609}",
            ":(": "\u{1F61E}",
            ">:(": "\u{1F621}",
            ":'(": "\u{1F622}",
            ":O": "\u{1F631}",
            "X(": "\u{1F632}",
            "<3": "\u{2764}"
        ]

        var text = aString

        // Begin Emoticon Search
        // Set the CharacterSets to separate words.
        let words = text.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        for i in 0..<words.count
        {

            let word = words[i]
            for (search, replace) in mappings
            {

                if let _ = word.range(of: search, options: .caseInsensitive)
                {
                    text = text.replacingOccurrences(of: word, with: replace)
                }
            }

            let symbol = "&#x"

            if word.hasPrefix(symbol)
            {

                if let int = Int(word.replacingOccurrences(of: symbol, with: ""), radix: 16)
                {
                    if let scalar = UnicodeScalar(int)
                    {
                        text = text.replacingOccurrences(of: word, with: String(scalar))
                    }
                }
            }
        }

        return text
    }
}
