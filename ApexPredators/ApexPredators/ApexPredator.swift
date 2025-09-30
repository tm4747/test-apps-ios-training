//
//  ApexPredator.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 9/23/25.
//

import SwiftUI

struct ApexPredator: Decodable, Identifiable {
    let id: Int
    let name: String
    let type: APType
    let latitude: Double
    let longitude: Double
    let movies: [String]
    let movieScenes: [MovieScene]
    let link: String
    
    var image: String {
        name.lowercased().replacingOccurrences(of: " ", with: "")
    }

    struct MovieScene: Decodable {
        let id: Int
        let movie: String
        let sceneDescription: String
    }
    
    enum APType: String, Decodable {
        case land // "land"
        case air
        case sea
        
        var background: Color {
            switch self {
                case .land:
                    .brown
                case .air:
                    .teal
                case .sea:
                    .blue
            }
        }
    }
}
