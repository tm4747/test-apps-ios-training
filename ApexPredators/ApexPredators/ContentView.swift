//
//  ContentView.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 9/23/25.
//

import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject var predators = Predators()
        
    @State var searchText = ""
    @State var alphabetical = false
    @State var selectedType = APType.all
    @State var selectedMovie = nil as String?
        
    var filteredDinos: [ApexPredator] {
        predators.selectedType = selectedType
        predators.selectedMovie = selectedMovie
        predators.applyFilters()
        predators.sort(by: alphabetical)
        return predators.search(for: searchText)
    }
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(filteredDinos){ predator in
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
                /*
                 onDelete is an event handler attached to a List or ForEach view.  It tells SwiftUI how to handle row deletion when using user swipes to delete or taps the edit button.
                 .onDelete modifier - called automatically when the user performs a delete action - swiping left on a row or tapping the delete icon in edit mode.
                 indexSet - collection of the row indices that were deleted.  Even though usually it's one index (one row deleted), IndexSet supports multiple simutaneous deletions
                 for index in indexSet - you loop through all deleted indices, in case there are multiple
                 let predator = filteredDinos[index] - this finds the predator corresponding to the index in your current displayed list (filteredDinos)
                 predators.delete(predator) - self explanatory
                 */
                .onDelete { indexSet in
                    for index in indexSet {
                        let predator = filteredDinos[index]
                        predators.delete(predator)
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
                            Text("any")
                                .tag(Optional("any"))
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
