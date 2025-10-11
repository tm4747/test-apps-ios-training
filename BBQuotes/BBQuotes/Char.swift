//
//  Char.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/11/25.
//

import Foundation

struct Char: Decodable {
    // let means constant - value cannot change
    let name: String
    let birthday: String
    let occupations: [String]
    let images: [URL]
    let aliases: [String]
    let status: String
    let portrayedBy: String
    // adding ? after TYPE indicates an optional property.  It will be set to nil if no value assigned
    // USAGE - Text(death ?? "unknown") - this will show the value set to death unless it's = nil, in which case "unknown" will be displayed
    //  - another way -> if death != nil { // display text }
    //  - another way -> if let actualNumber = Int(possibleNumber) { print "the string \"\(possibleNumber)\" has an int avlue of \(actualNumber)" } else { print "no good" }
    // FORCE UNWRAPPING -  Text(death!) - this will try to force the value to be displayed.  App will crash if death == nil
    //   -  the reason this is a feature is because there are instances where we actually want to do this, where  we know there's going to be a value there
    var death: Death?
}
