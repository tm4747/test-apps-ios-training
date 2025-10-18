//
//  ViewModel.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/12/25.
//

/*
 ViewModel - what makes it different froma  controller is that the ViewModel is observable to the View.  Much more intimate connection than most other files within an app.
 The View treats the ViewMOdel properties as its own properties.  Since this file is so exposed, you want to consider access control -> privacy of our code.
  - Access control - restrics access to parts of your code from code in other source files and modules.  How public / private do we make our functions and properties in structs & classes?
 */

import Foundation
import SwiftUI

/*
 @Observable - makes all properties @State properties, so if any of them changes, the view re-renders
 */
@Observable
/*
 @MainActor - “All code that runs in this class (or struct, or function) must execute on the main thread.”   is responsible for anything that affects the UI — drawing views, updating text, changing colors, etc.   If you update UI-related state from a background thread (for example, from a network response or a background task), you can get crashes or visual glitches.
  - seems like it essentially is a Required or Important tag
 */
@MainActor
/*
 class - in a class it's required that each variable is set to something
 */
class ViewModel {
    
    enum FetchStatus {
        case notStarted
        case fetching
        case successQuote
        case successEpisode
        case successCharacter
        case failed(error: Error)
    }
    
    // This cannot be SET outside the class, but GET is fine/public
    private(set) var status: FetchStatus = .notStarted
    
    private let fetcher = FetchService()
    
    var quote: Quote
    var character: Char
    var episode: Episode
    
    /*
     init is where you can set values for all properties.  They can be set in other way(s), but here is common.
     */
    init() {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let quoteData = try! Data(contentsOf: Bundle.main.url(forResource: "samplequote", withExtension: "json")!)
        quote = try! decoder.decode(Quote.self, from: quoteData)
        
        let characterData = try! Data(contentsOf: Bundle.main.url(forResource: "samplecharacter", withExtension: "json")!)
        character = try! decoder.decode(Char.self, from: characterData)
        
        let episodeData = try! Data(contentsOf: Bundle.main.url(forResource: "sampleepisode", withExtension: "json")!)
        episode = try! decoder.decode(Episode.self, from: episodeData)
    }
    
    // leave public - this funciton must be run from view when user taps "get quote" button
    func getQuoteData(for show: String) async {
        status = .fetching
        
        do {
            quote = try await fetcher.fetchQuote(from: show)
            
            character = try await fetcher.fetchCharacter(quote.character)
              
            character.death = try await fetcher.fetchDeath(for: character.name)
            
            status = .successQuote
        } catch {
            status = .failed(error: error)
        }
    }
    /*
     TODO: fill out this function
     */
    func getRandomCharacterData(for show: String) async {
        status = .fetching
        
        do {
            character = try await fetcher.fetchRandomCharacter(from: show)
            
            status = .successCharacter
        } catch {
            status = .failed(error: error)
        }
    }
    
    func getEpisode(for show: String) async {
        status = .fetching
        
        do {
            if let unwrappedEpisode = try await fetcher.fetchEpisode(from: show) {
                episode = unwrappedEpisode
            }
            status = .successEpisode
        } catch {
            status = .failed(error: error)
        }
    }
}


