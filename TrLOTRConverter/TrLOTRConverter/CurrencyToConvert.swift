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

//#Preview {
////    @FocusState private var focusedField: Field?
//    @Previewable @State var side: Side = .left
//    @Previewable @State var currency = Currency.silverPiece
//    @Previewable @State var showPicker: Bool = false
//    @Previewable @State var amount: String = "0.0"
//    @Previewable @FocusState var focusedField: Side?   // <- lives in a View
//
//    
//    CurrencyToConvert(
//        side: $side,
//        currency: $currency,
//        showSelectCurrency: $showPicker,
//        amount: $amount,
//        focusedField: $focusedField
//    )
//        .task { try? Tips.configure() }
//            .padding()
//            .background(Color.black)
//}

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
