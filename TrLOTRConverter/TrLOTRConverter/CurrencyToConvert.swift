//
//  ContentView.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 8/29/25.
//

import SwiftUI
import TipKit

struct CurrencyToConvert: View {
    
    let side: Side
    let currencyTip = CurrencyTip()
    @Binding var currency: Currency
    @Binding var showSelectCurrency: Bool
    @Binding var amount: String
    
    var focusedField: FocusState<Side?>.Binding

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
            .if(side == .right) { view in     // <— custom conditional modifier
                view.popoverTip(currencyTip, arrowEdge: .bottom)
            }
            
            // Left text field
            TextField("Amount", text: $amount)
                .textFieldStyle(.roundedBorder)
                .keyboardType(.decimalPad)
                .focused(focusedField, equals: side)
        }
        .task {
            try? Tips.configure()
        }
    }
}


#Preview {
    @Previewable @State var currency = Currency.silverPiece
    @Previewable @State var showSelectCurrency = false
    @Previewable @State var amount = "0.0"
    CurrencyToConvert(
        side: .left,
        currency: $currency,
        showSelectCurrency: $showSelectCurrency,
        amount: $amount,
        focusedField: FocusState<Side?>().projectedValue
    )
    .padding()
    .background(.black)
    .environment(\.colorScheme, .dark) 
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool,
                             transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
