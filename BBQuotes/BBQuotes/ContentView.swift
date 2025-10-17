//
//  ContentView.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/11/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab(Constants.bbName, systemImage: "tortoise") {
                QuoteView(show: Constants.bbName)
            }
            Tab(Constants.bcsName, systemImage: "briefcase") {
                QuoteView(show: Constants.bcsName)
            }
            Tab(Constants.ecName, systemImage: "car") {
                QuoteView(show: Constants.ecName)
            }
            Tab(Constants.cbName, systemImage: "heart") {
                QuoteView(show: Constants.cbName)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
