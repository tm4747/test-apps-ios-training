//
//  PredatorDetail.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 10/2/25.
//

import SwiftUI
import MapKit

struct PredatorDetail: View {
    
    let predator: ApexPredator
    
    @State var position: MapCameraPosition
    
    var body: some View {
        
        GeometryReader { geo in
            /** ScrollViews - like VStacks but content starts at top rather than center         */
            ScrollView {
                ZStack(alignment: .bottomTrailing){                    //background image
                    Image(predator.type.rawValue)
                        .resizable()
                        .scaledToFit()
                        .overlay {
                            LinearGradient(stops: [
                                Gradient.Stop(color:.clear, location:0.8),
                                Gradient.Stop(color:.black, location:1),
                            ], startPoint: .top, endPoint: .bottom)
                        }
                    
                    // Dino image
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width / 1.5, height: geo.size.height / 3.7 )
                        .scaleEffect(x: -1)
                        .shadow(color: predator.type.background, radius: 7)
                        .offset(y:20)
                }
                VStack(alignment: .leading){
                    // Dino name
                    Text(predator.name)
                        .font(.largeTitle)
                    
                    // Current location
                    NavigationLink {
                        Image(predator.image)
                            .resizable()
                            .scaledToFit()
                    } label: {
                        Map(position: $position){
                            Annotation(predator.name, coordinate: predator.location){
                                Image(systemName: "mappin.and.ellipse")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                    .symbolEffect(.pulse)
                            }
                            .annotationTitles(.hidden)
                        }
                        .frame(height: 125)
                        .clipShape(.rect(cornerRadius: 15))
                    }
                   
                    
                    // Apppears in
                    Text("Appears In:")
                        .font(.title3)
                    
                    ForEach(predator.movies, id: \.self) { movie in
                        Text(" • " + movie)
                            .font(.subheadline)
                    }
                    
                    // Movie moments
                    Text("Movie Moments")
                        .font(.title)
                        .padding(.top, 15)
                    
                    ForEach(predator.movieScenes) { scene in
                        Text(scene.movie)
                            .font(.title2)
                            .padding(.vertical, 1)
                        
                        Text(scene.sceneDescription)
                            .padding(.bottom, 15)
                    }
                    
                    // Link to webpage
                    Text("Read More:")
                        .font(.caption)
                    
                    if let url = URL(string: predator.link) {
                        Link(predator.link, destination: url)
                            .font(.caption)
                            .foregroundStyle(.blue)
                    }

                }
                .padding()
                .padding(.bottom, 30)
                .frame(width: geo.size.width, alignment: .leading)
            }
        }
        .ignoresSafeArea()
        .toolbarBackground(.automatic)
    }
}

#Preview {
    let predator = Predators().apexPredators[11]
    NavigationStack {
        PredatorDetail(predator: predator,
                       position: .camera(
                        MapCamera(
                            centerCoordinate: predator.location, distance: 30000
                        )))
            .preferredColorScheme(.dark)
    }
}
