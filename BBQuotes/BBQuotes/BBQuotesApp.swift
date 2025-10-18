//
//  BBQuotesApp.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/11/25.
//

import SwiftUI

@main
struct BBQuotesApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

/**
 Coding challenges:
 ✅   Fetch a quote automatically when the app launches
 ✅   When you fetch a quote - show a random char image
 ✅   Fetch random character -> use baseUrl/characters/random
    1. fetch a character
    2. make sure the character is in the currently selected show (productions property)
    3. if not, fetch again and repeat until the character IS in currently selected production
    4. show character data in an existing or new view
 - componentize buttons in FetchView
 - in character view -> add a place to show a random quote.
    - also add button to pull another random quote
    - baseUrl/quotes/random?character=Walter+White
 - Sometimes fetch a simpson's quote (20%)
    - thesimpsonsquoteapi.glitch.me ->  /quotes
 */


/**
 Version 2 Feature List
 ✅  Add El Camino tab
 ✅  Utilize all character images on character view
 ✅ ON characterView, auto-scroll to bottom after status is shown
 ✅  Fetch episode data
 ✅  Extend String to get rid of long image and color names
 ✅  Create static constants for show names. 
 */
