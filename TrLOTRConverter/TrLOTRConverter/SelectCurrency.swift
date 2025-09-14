//
//  SelectCurrency.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 9/6/25.
//

import SwiftUI

struct SelectCurrency: View {
    @Environment(\.dismiss) var dismiss
    @Binding var topCurrency: Currency
    @Binding var bottomCurrency: Currency
       
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
                IconGrid(selectedCurrency: $topCurrency)
                
                
                // text
                Text("Select the currency you would like to convert to:")
                    .fontWeight(.bold)
                    .padding(.top)
                //currency icons
                IconGrid(selectedCurrency: $bottomCurrency)
                
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
            .padding()
            .foregroundStyle(.black)
        }
    }
}

#Preview {
    @Previewable @State var topCurrency = Currency.silverPenny
    @Previewable @State var bottomCurrency = Currency.goldPenny
    SelectCurrency(topCurrency: $topCurrency, bottomCurrency: $bottomCurrency)
}
