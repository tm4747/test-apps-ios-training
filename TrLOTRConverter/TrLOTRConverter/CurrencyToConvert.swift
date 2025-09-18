//
//  ContentView.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 8/29/25.
//

import SwiftUI
import TipKit

struct CurrencyToConvert: View {
    
    enum Side { case left, right}
  
    let side: Side
    let currencyTip = CurrencyTip()
    @Binding var currency: Currency
    @Binding var showSelectCurrency: Bool
    @Binding var amount: String
//    @Binding var focusedField: Field?

    var body: some View {
        VStack {
            // currency
            HStack {
                if(side == .right){
                    // currency text
                    Text(currency.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
                // currency image
                Image(currency.image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 33)
                if(side == .left){
                    // currency text
                    Text(currency.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                }
            }
            .padding(.bottom, -5)
            .onTapGesture {
                showSelectCurrency.toggle()
//                currencyTip.invalidate(reason: .actionPerformed)
            }
            .popoverTip(currencyTip, arrowEdge: .bottom)
            
            // Left text field
            TextField("Amount", text: $amount)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
//                .focused($focusedField, equals: .left)
        }
    }
}

#Preview {
//    @FocusState private var focusedField: Field?
    @Previewable @State var currency: Currency = .silverPiece
    @Previewable @State var showPicker: Bool = false
    @Previewable @State var amount: String = "0.0"
    CurrencyToConvert(side: .left, currency: $currency, showSelectCurrency: $showPicker, amount: $amount)
        .task { try? Tips.configure() }
            .padding()
            .background(Color.black)
}
