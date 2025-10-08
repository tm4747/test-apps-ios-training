//
//  PredatorMap.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 10/4/25.
//

import SwiftUI
import MapKit

struct PredatorMap: View {
    let predators = Predators()
    
    @State var position: MapCameraPosition
    @State var sattelite = false
    
    // Track which predator image was tapped
    @State private var selectedPredator: ApexPredator? = nil
    
    var body: some View {
        Map(position: $position) {
            ForEach(predators.apexPredators){ predator in
                Annotation(predator.name, coordinate: predator.location){
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                        .frame(height:100)
                        .shadow(color:.white, radius: 3)
                        .scaleEffect(x: -1)
                        .onTapGesture {
                            selectedPredator = predator
                        }
                }
            }
        }
        .mapStyle(sattelite ? .imagery(elevation: .realistic) : .standard(elevation: .realistic))
        .overlay(alignment: .bottomTrailing){
            Button {
                sattelite.toggle()
            } label: {
                Image(systemName: sattelite ? "globe.americas.fill" : "globe.americas")
                    .font(.largeTitle)
                    .imageScale(.large)
                    .padding(3)
                    .background(.ultraThinMaterial)
                    .clipShape(.rect(cornerRadius:7))
                    .shadow(radius:3)
                    .padding()
            }
        }
        .toolbarBackground(.automatic)
        // Present a sheet when an image is tapped - if selectedPredator has a value, show the sheet.  nil - don't show.  When sheet is dismissed, selectedPredator is set back to nil.  item: is better in this case than isPresented: (bool) because you want the content to be dynamic and based on whatever item: is set
        .sheet(item: $selectedPredator) { predator in
            PredatorDetailCard(predator: predator)
                .presentationDetents([.fraction(0.4)])
                .presentationBackground(.clear)  // optional: controls sheet height.  Normally (without this) the sheet would be full height
        }
    }
}

// MARK: - Detail Card View
struct PredatorDetailCard: View {
    let predator: ApexPredator
    
    var body: some View {
        VStack {
            Image(predator.image)
                .resizable()
                .scaledToFit()
                .frame(maxHeight: 200)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 5)
            
            Text(predator.name)
                .font(.title2)
                .bold()
                .padding(.top)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.blue).ignoresSafeArea().opacity(0.75))
    }
}

#Preview {
    NavigationStack {
        PredatorMap(position: .camera(MapCamera(
            centerCoordinate: Predators().apexPredators[2].location,
            distance: 1000,
            heading: 250,
            pitch: 80)))
        .preferredColorScheme(.dark)
    }
}
