//
//  EpisodeView.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/17/25.
//

import SwiftUI

struct EpisodeView: View {
    let episode: Episode
    
    var body: some View {
        VStack(alignment: .leading){
            Text(episode.title)
                .font(.largeTitle)
            Text(episode.seasonEpisode)
                .font(.largeTitle)
            
            AsyncImage(url: episode.image){ image in
                image
                .resizable()
                .scaledToFit()
                .clipShape(.rect(cornerRadius: 15))
            } placeholder: {
                ProgressView()
            }
            
            Text(episode.synopsis)
                .font(.title3)
                .minimumScaleFactor(0.5)
                .padding(.bottom)
            
            Text("Written By: \(episode.writtenBy)")
            
            Text("Directed By: \(episode.directedBy)")
            
            Text("Aired: \(episode.airDate)")
        }
        .padding()
        .background(.black.opacity(0.6))
        .foregroundStyle(.white)
        .clipShape(.rect(cornerRadius: 25))
        .padding(.horizontal)
    }
}

#Preview {
    EpisodeView(episode: ViewModel().episode)
}
