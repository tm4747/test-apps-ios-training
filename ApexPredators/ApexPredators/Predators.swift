//
//  Predators.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 9/24/25.
//
/**
 This class imports data from a JSON file into a useable object, an array of ApexPredator objects, using the ApexPredator model
 */
import Foundation

class Predators {
    var apexPredators: [ApexPredator] = []
    
    init() {
        decodeApexPredatorData()
    }
    
    func decodeApexPredatorData() {
        // if file exists, store the file url in this constant
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json"){
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                apexPredators = try decoder.decode([ApexPredator].self, from: data)
            } catch {
                print("error decoding JSON data: \(error)")
            }
        }
    }
}
