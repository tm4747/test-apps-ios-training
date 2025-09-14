//
//  IconGrid.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 9/6/25.
//

import SwiftUI

struct IconGrid: View {
    @Binding var selectedCurrency: Currency
       
    var body: some View {
        // currency icons
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]){
            ForEach(Currency.allCases){currency in
                if(currency == self.selectedCurrency){
                    CurrencyIcon(currencyImage: currency.image, text: currency.name)
                        .shadow(color:.black, radius: 10)
                        .overlay{
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(lineWidth: 3)
                                .opacity(0.5)
                        }
                } else {
                    CurrencyIcon(currencyImage: currency.image, text: currency.name)
                        .onTapGesture{
                            self.selectedCurrency = currency
                        }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedCurrency = Currency.silverPiece
    IconGrid(selectedCurrency: $selectedCurrency)
}
