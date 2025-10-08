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
import SwiftUI

class Predators {
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []
    
    // Track both filter criteria
   var selectedType: APType = .all
   var selectedMovie: String? = nil

    var allMovies: [String] = []
    
    init() {
        decodeApexPredatorData()
        collectAllMovies() // call after data is loaded
    }
    
    func decodeApexPredatorData() {
        // if file exists, store the file url in this constant
        if let url = Bundle.main.url(forResource: "jpapexpredators", withExtension: "json"){
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                allApexPredators = try decoder.decode([ApexPredator].self, from: data)
                apexPredators = allApexPredators
            } catch {
                print("error decoding JSON data: \(error)")
            }
        }
    }
    // ✅ Collect all unique movie titles
   private func collectAllMovies() {
       let movies = allApexPredators.flatMap { $0.movies }
       allMovies = Array(Set(movies)).sorted() // remove duplicates + sort
   }
    
    func search(for searchTerm: String) -> [ApexPredator] {
        if searchTerm.isEmpty {
            return apexPredators
        } else {
            return apexPredators.filter {
                predator in predator.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }
    
    func sort(by alphabetical: Bool){
        apexPredators.sort{ predator1, predator2 in
            if alphabetical {
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
    }
    
    func applyFilters() {
       apexPredators = allApexPredators.filter { predator in
           // type filter
           (selectedType == .all || predator.type == selectedType)
           &&
           // movie filter
           (selectedMovie == nil ||
            selectedMovie!.isEmpty ||
            predator.movies.contains(where: {
                $0.caseInsensitiveCompare(selectedMovie!) == .orderedSame
            })
           )
       }
   }

   func filter(by type: APType) {
       selectedType = type
       applyFilters()
   }

   func filter(by movie: String?) {
       selectedMovie = movie
       applyFilters()
   }

}
