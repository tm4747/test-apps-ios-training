//
//  ContentView.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 9/23/25.
//

import SwiftUI

struct ContentView: View {
    let predators = Predators()
    var body: some View {
        List(predators.apexPredators){ predator in
            HStack {
                Image(predator.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width:100, height: 100)
                    .shadow(color: .white, radius: 1)
                VStack(alignment: .leading) {
                    // name
                    Text(predator.name)
                        .fontWeight(.bold)
                    Text(predator.type.rawValue.capitalized)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 13)
                        .padding(.vertical, 5)
                        .background(predator.type.background)
                        .clipShape(.capsule)

                }
            }
//            HStack {
//                // Dinosaur image
//                Image(predator.image)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width:100, height: 100)
//                    .shadow(color: .white, radius: 1)
//                
//                VStack(alignment: .leading) {
//                    // name
//                    Text(predator.name)
//                        .fontWeight(.bold)
//                    // type
//                    Text(predator.type.capitalized)
//                        .font(.subheadline)
//                        .fontWeight(.semibold)
//                        .padding(.horizontal, 13)
//                        .padding(.vertical, 5)
//                    
//                }
//            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
