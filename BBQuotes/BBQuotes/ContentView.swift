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
            Tab("Breaking Bad", systemImage: "tortoise") {
                QuoteView(show: "Breaking Bad")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            Tab("Better Call Saul", systemImage: "briefcase") {
                QuoteView(show: "Better Call Saul")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            Tab("El Camino", systemImage: "car") {
                QuoteView(show: "El Camino")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
            Tab("Care Bears", systemImage: "heart") {
                QuoteView(show: "Care Bears")
                    .toolbarBackgroundVisibility(.visible, for: .tabBar)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
