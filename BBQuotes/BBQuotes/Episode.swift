//
//  Episode.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/17/25.
//

import Foundation

struct Episode: Decodable {
    let episode: Int // 101 -> season 1 , episode 01
    let title: String
    let image: URL
    let synopsis: String
    let writtenBy: String
    let directedBy: String
    let airDate: String
    
    var seasonEpisode: String {
        // Season - since episode is an int it will return an int -> no decimals.  Like usual, % returns remainder.
        "Season \(episode / 100) Episode \(episode % 100)"
    }
}
