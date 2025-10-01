//
//  ContentView.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 9/23/25.
//

import SwiftUI

struct ContentView: View {
    let predators = Predators()
    
    @State var searchText = ""
    @State var alphabetical = false
    
    var filteredDinos: [ApexPredator] {
        predators.sort(by: alphabetical)
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List(filteredDinos){ predator in
                NavigationLink {
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                } label: {
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
                }
            }
            .navigationTitle("Apex Predators")
            .searchable(text: $searchText)
            .autocorrectionDisabled()
            .animation(.default, value: searchText)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            alphabetical.toggle()
                        }
                    } label: {
                        let imageFile = alphabetical ? "film" : "textformat"
                        Image(systemName: imageFile)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
