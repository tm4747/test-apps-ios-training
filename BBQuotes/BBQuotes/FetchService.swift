//
//  FetchService.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/11/25.
//

import Foundation

struct FetchService {
    enum FetchError: Error {
        case badResponse
    }
    
    // Here you need the ! because the URL type is optional by default, BUT you can't really use the URL type if it is optional (lol).  Not sure what the purpose of all this is - perhaps it has to do with when you're pulling the URL dynamically and maybe no or a wrong value will be pulled?
    //  -  alternately, you could coalesce by adding a default in case nil is passed.  In the following case the url is hardcoded so we don't need to worry about nil being assigned
    //  -  essentially, force unwrap if you know there's going to be a value (!).  coalesce if the value is being passed and there is a change it will be nil (such as being pulled via api)
    let baseUrl = URL(string: "https://breaking-bad-api-six.vercel.app/api")!
    
    func fetchQuote(from show: String) async throws -> Quote {
        // Build fetch url
        let quoteURL = baseUrl.appending(path: "quotes/random")
        let fetchURL = quoteURL.appending(queryItems: [URLQueryItem(name:"production", value: show)])
        
        // try to fetch data from url
        /* returns tuple containing both data and response objects
         func data( from url: URL, delegate: (any URLSessionTaskDelegate)? = nil ) async throws -> (Data, URLResponse)
          Data - is the data returned.  URLResponse - is the url response code (200 etc...)
         */
        let (data, response) = try await URLSession.shared.data(from: fetchURL)
        
        // handle response
        // ??? WHAT IS HAPPENING HERE?
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw FetchError.badResponse
        }
        
        // decode data
        
        //return quote
    }
}
