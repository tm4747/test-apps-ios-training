//
//  CurrencyIcon.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 9/6/25.
//

import SwiftUI

struct CurrencyIcon: View {
    let currencyImage: ImageResource
    let text: String
    
    var body: some View {
        ZStack(alignment: .bottom){
            //currency image
            Image(currencyImage)
                .resizable()
                .scaledToFit()
            
            //currency name
            Text(text)
                .padding(3)
                .font(.caption)
                .frame(maxWidth: .infinity)
                .background(.brown.opacity(0.75))
        }
        .padding(3)
        .frame(width:100, height:100)
        .background(.brown)
        .clipShape(.rect(cornerRadius:25))
    }
}

#Preview {
    CurrencyIcon(currencyImage: .copperpenny, text: "Copper Penny")
}
