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
    
    /*
     Init is not required in a struct.  However, if you start typing init -> and then hit tab, the hidden init funciton (which was present but hidden) appears in the codebase.  From here you can modify it.
     */
    enum CodingKeys: CodingKey {
        case name
        case birthday
        case occupations
        case images
        case aliases
        case status
        case portrayedBy
        case death
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.birthday = try container.decode(String.self, forKey: .birthday)
        self.occupations = try container.decode([String].self, forKey: .occupations)
        self.images = try container.decode([URL].self, forKey: .images)
        self.aliases = try container.decode([String].self, forKey: .aliases)
        self.status = try container.decode(String.self, forKey: .status)
        self.portrayedBy = try container.decode(String.self, forKey: .portrayedBy)
        
        // GET and decode the death data
        let deathDecoder = JSONDecoder()
        deathDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let deathData = try Data(contentsOf: Bundle.main.url(forResource:
                                                                "sampledeath", withExtension: "json")!)
        death = try deathDecoder.decode(Death.self, from: deathData)
    }
}
