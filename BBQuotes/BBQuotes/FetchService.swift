//
//  FetchService.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/11/25.
//

import Foundation

/*
 This could alternately be called FetchController.  In MVC, this would be a controller, which essentially controls all the fetching.
 ViewModel - this would be a file which essentially models the available data for a view.  (mvc pattern vs MvmV pattern - Model - ViewModel - View)
 Access control - which of these things do we need to access from outside the struct?  If not, make things private.
 
 */

struct FetchService {
    private enum FetchError: Error {
        case badResponse
    }
    
    // Here you need the ! because the URL type is optional by default, BUT you can't really use the URL type if it is optional (lol).  Not sure what the purpose of all this is - perhaps it has to do with when you're pulling the URL dynamically and maybe no or a wrong value will be pulled?
    //  -  alternately, you could coalesce by adding a default in case nil is passed.  In the following case the url is hardcoded so we don't need to worry about nil being assigned
    //  -  essentially, force unwrap if you know there's going to be a value (!).  coalesce if the value is being passed and there is a change it will be nil (such as being pulled via api)
    private let baseUrl = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    func fetchQuote(from show: String) async throws -> Quote {
        // Build fetch url
        let quoteURL = baseUrl.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name:"production", value: show)])
        
        // try to fetch data from url
        /* returns tuple containing both data and response objects
         func data( from url: URL, delegate: (any URLSessionTaskDelegate)? = nil ) async throws -> (Data, URLResponse)
          Data - is the data returned.  URLResponse - is the url response code (200 etc...)  */
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        /* handle response - set response to response if the response is a HTTPURLResponse (which means we connected to a webserver) -> “Make sure that the response is an HTTPURLResponse and that its status code is 200. If not, stop execution and throw a badResponse error.” -> if either of the condition fails, the else block runs
         guard -> ensures certain conditions are true before continuing
            as? HTTPURLResponse -> means “try to cast this value to an HTTPURLResponse.” -> if the cast succeeds and statusCode is 200, we get a new HTTPURLResponse variable response  */
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // decode data
        /*
         Quote.self is used instead of Quote because Quote alone would be taken for a type.  You want the thing version of the type, which is what adding the .self implies
         */
        let quote = try JSONDecoder().decode(Quote.self, from: data)
        
        //return quote
        return quote
    }
    
    
    func fetchCharacter(_ name: String) async throws -> Char {
        // Build fetch url
        let characterURL = baseUrl.appending(path: "characters")
        let fetchURL = characterURL.appending(queryItems: [URLQueryItem(name:"name", value: name)])
        
        // try to fetch data from url
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // decode data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let characters = try decoder.decode([Char].self, from: data)
        
        //return quote
        return characters[0]
    }
    
    // TODO: build out - will need to confirm we're returning a Char not [Char].  Also, will have to keep fetching data until we get one matching hte show
    func fetchRandomCharacter(from show: String) async throws -> Char {
        var characterFromShowFound = false
        var foundCharacter: Char? = nil
        
        // Build fetch url
        let fetchURL = baseUrl.appending(path: "characters/random")
        
        while !characterFromShowFound {
            // try to fetch data
            let (data, response) = try await URLSession.shared.data(from: fetchURL)
            
            // check response
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                    throw FetchError.badResponse
                }
            
            // decode json data into Char
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let character = try decoder.decode(Char.self, from: data)
            
            // if String array character.productions contains show, set characterFromShowFound to true
            if character.productions.contains(where: { $0.caseInsensitiveCompare(show) == .orderedSame }) {
                characterFromShowFound = true
                foundCharacter = character
            }
            
            // Optional: add small delay to avoid hammering the API
            try await Task.sleep(nanoseconds: 200_000_000) // 0.2s
        }

        //return quote
        guard let foundCharacter else {
            throw FetchError.badResponse
        }
            
        return foundCharacter
    }
    
    
    func fetchDeath(for character: String) async throws -> Death? {
        let fetchURL = baseUrl.appending(path: "deaths")
        
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let deaths = try decoder.decode([Death].self, from: data)
        
        for death in deaths {
            if death.character == character {
                return death
            }
        }
        return nil
    }
    
    
    func fetchEpisode(from show: String) async throws -> Episode? {
        // Build fetch url
        let episodeURL = baseUrl.appending(path: "episodes")
        let fetchURL = episodeURL.appending(queryItems: [URLQueryItem(name:"production", value: show)])
        
        // try to fetch data from url
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // handle response
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // decode data
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let episodes = try decoder.decode([Episode].self, from: data)
        
        //return quote
        return episodes.randomElement()
    }
    
    
}
