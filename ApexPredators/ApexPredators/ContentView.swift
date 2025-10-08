//
//  ContentView.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 9/23/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    let predators = Predators()
        
    @State var searchText = ""
    @State var alphabetical = false
    @State var selectedType = APType.all
    @State var selectedMovie = nil as String?
        
    var filteredDinos: [ApexPredator] {
        
        predators.filter(by: selectedType)
        predators.sort(by: alphabetical)
        predators.filter(by: selectedMovie)
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List(filteredDinos){ predator in
                NavigationLink {
                    
                    PredatorDetail(predator: predator,
                                   position: .camera(
                                    MapCamera(
                                        centerCoordinate: predator.location,
                                        distance: 30000
                                    )))
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
                        Image(systemName: alphabetical ? "film" : "textformat")
                            .symbolEffect(.bounce, value:alphabetical)
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Menu {
                        Picker("Filter", selection: $selectedMovie.animation()){
                            ForEach(predators.allMovies, id: \.self) { movie in
                                Text(movie.capitalized)
                                    .tag(Optional(movie))
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Menu {
                        Picker("Filter", selection: $selectedType.animation()){
                            ForEach(APType.allCases) {
                                type in
                                Label(type.rawValue.capitalized, systemImage: type.icon)
                            }
                        }
                    } label: {
                        Image(systemName: "slider.horizontal.3")
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
