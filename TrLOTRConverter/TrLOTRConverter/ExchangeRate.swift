//
//  ExchangeRate.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 9/6/25.
//

import SwiftUI

struct ExchangeRate: View {
    let leftImage: ImageResource
    let rightImage: ImageResource
    let text: String
    
    var body: some View {
        HStack {
            //left currency image
            Image(leftImage)
                .resizable()
                .scaledToFit()
                .frame(height:33)
            //exchange text
            Text(text)
            //right currency image
            Image(rightImage)
                .resizable()
                .scaledToFit()
                .frame(height:33)
        }
    }
}

#Preview {
    ExchangeRate(leftImage: .silverpiece, rightImage: .silverpenny, text: "1 Silver Piece = 4 Silver Pennie")
}
