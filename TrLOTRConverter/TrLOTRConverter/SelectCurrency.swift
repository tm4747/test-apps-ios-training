//
//  SelectCurrency.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 9/6/25.
//

import SwiftUI

struct SelectCurrency: View {
    @Environment(\.dismiss) var dismiss
       
    var body: some View {
        ZStack {
            // parchment backgorund img
            Image(.parchment)
                .resizable()
                .ignoresSafeArea()
                .background(.brown)
            VStack {
                // Text
                Text("Select the currency you are starting with:")
                    .fontWeight(.bold)
                                    
                // currency icons
                LazyVGrid(columns: [
                    GridItem(),
                    GridItem(),
                    GridItem()
                ]){
                    ForEach(Currency.allCases){currency in
                        CurrencyIcon(currencyImage: currency.image, text: currency.name)
                    }
                }
                
                
                // text
                Text("Select the currency you would like to convert to:")
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                //currency icons
                
                //done button
                Button("Done") {
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(.brown.mix(with: .black, by: 0.1))
                .font(.largeTitle)
                .padding()
                .foregroundStyle(.white)
                
            }
            .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    SelectCurrency()
}
