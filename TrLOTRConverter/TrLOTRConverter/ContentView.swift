//
//  ContentView.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 8/29/25.
//

import SwiftUI
import TipKit

struct ContentView: View {
    @State var showExchangeInfo = false
    @State var showSelectCurrency = false

    @AppStorage("leftAmount")  var leftAmount: String = ""
    @AppStorage("rightAmount") var rightAmount: String = ""

    // both of the following work with different syntax
    @State var leftCurrency = Currency.load(forKey: "leftCurrency", default: .silverPiece)
    @State var rightCurrency = Currency.load(forKey: "rightCurrency", default: .goldPiece)

    
    @FocusState private var focusedField: Field?
    
    let currencyTip = CurrencyTip()
    
    enum Field {
        case left, right
    }
    
    var body: some View {
        ZStack {
            // Background image
            Image(.background)
                .resizable()
                .ignoresSafeArea()
            VStack {
                // Prancing pony image view
                Image(.prancingpony)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                // Currency Exchange text
                Text("Currency Exchange")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                
                // conversion section
                HStack {
                    // left conversion section
//                    CurrencyToConvert(side: .right, currency: $rightCurrency, showSelectCurrency: $showSelectCurrency, amount: $rightAmount)
                    VStack {
                        // currency
                        HStack {
                            // currency image
                            Image(leftCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                            // currency text
                            Text(leftCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                        .padding(.bottom, -5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
//                            currencyTip.invalidate(reason: .actionPerformed)
                        }
                        .popoverTip(currencyTip, arrowEdge: .bottom)
                        
                        // Left text field
                        TextField("Amount", text: $leftAmount)
                            .textFieldStyle(.roundedBorder)
                            .focused($focusedField, equals: .left)
                    }
                    // = sign
                    Image(systemName: "equal")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)
                    
                    // right conversion section
                    VStack {
                        // currency
                        HStack {
                            // currency text
                            Text(rightCurrency.name)
                                .font(.headline)
                                .foregroundStyle(.white)
                            // currency image
                            Image(rightCurrency.image)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 33)
                        }
                        .padding(.bottom, -5)
                        .onTapGesture {
                            showSelectCurrency.toggle()
//                            currencyTip.invalidate(reason: .actionPerformed)
                        }
                        
                        // Right text field
                        TextField("Amount", text: $rightAmount)
                            .textFieldStyle(.roundedBorder)
                            .multilineTextAlignment(.trailing)
                            .focused($focusedField, equals: .right)
                    }
                }
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(.capsule)
                .keyboardType(.decimalPad)
                
                Spacer()
                HStack {
                    Spacer()
                    // info button
                    Button {
                        showExchangeInfo.toggle()
                        print("showExInfo val:  \(showExchangeInfo)")
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                            .padding(.trailing)
                    }
                    .padding(.trailing)
                }
            }
        }
        .onTapGesture {
            focusedField = nil    // clears focus, hides keyboard
        }
        .task {
            try? Tips.configure()
        }
        .onChange(of: leftAmount){
            if focusedField == .left {
                rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
            }
        }
        .onChange(of: rightAmount){
            if focusedField == .right {
                leftAmount = rightCurrency.convert( rightAmount, to: leftCurrency)
            }
        }
        .onChange(of: leftCurrency){
            leftAmount = rightCurrency.convert( rightAmount, to: leftCurrency)
            leftCurrency.save(forKey: "leftCurrency")
        }
        .onChange(of: rightCurrency){
            rightAmount = leftCurrency.convert(leftAmount, to: rightCurrency)
            rightCurrency.save(forKey: "rightCurrency")
        }
        .sheet(isPresented: $showExchangeInfo){
            ExchangeInfo()
        }
        .sheet(isPresented: $showSelectCurrency){
            SelectCurrency(topCurrency: $leftCurrency, bottomCurrency: $rightCurrency)
        }
    }
}

#Preview {
    ContentView()
}
