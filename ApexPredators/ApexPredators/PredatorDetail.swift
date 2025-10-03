//
//  PredatorDetail.swift
//  ApexPredators
//
//  Created by Tom Molinaro on 10/2/25.
//

import SwiftUI

struct PredatorDetail: View {
    
    let predator: ApexPredator
    
    var body: some View {
        
        GeometryReader { geo in
            /** ScrollViews - like VStacks but content starts at top rather than center         */
            ScrollView {
                ZStack(alignment: .bottomTrailing){                    //background image
                    Image(predator.type.rawValue)
                        .resizable()
                        .scaledToFit()
                    
                    // Dino image
                    Image(predator.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width / 1.5, height: geo.size.height / 3.7 )
                        .scaleEffect(x: -1)
                        .shadow(color:.green, radius: 7)
                        .offset(y:20)
                }
                VStack(alignment: .leading){
                    // Dino name
                    Text(predator.name)
                    
                    // Current locatoin
                    
                    // Apppears in
                    
                    // Movie moments
                    
                    // Link to webpage
                }
                .frame(width: geo.size.width, alignment: .leading)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PredatorDetail(predator: Predators().apexPredators[2])
//        .preferredColorScheme(.dark)
}
