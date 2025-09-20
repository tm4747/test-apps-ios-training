//
//  ContentView.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 8/29/25.
//

import SwiftUI

enum Side: Hashable {
    case left, right
}

struct ContentView: View {
    @State var showExchangeInfo = false
    @State var showSelectCurrency = false

    @AppStorage("leftAmount")  var leftAmount: String = ""
    @AppStorage("rightAmount") var rightAmount: String = ""

    // both of the following work with different syntax
    @State var leftCurrency = Currency.load(forKey: "leftCurrency", default: .silverPiece)
    @State var rightCurrency = Currency.load(forKey: "rightCurrency", default: .goldPiece)

    
    @FocusState private var focusedField: Side?
        
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
                
                // Conversion Section
                HStack {
                    // left conversion section
                    CurrencyToConvert(
                        side: .left,
                        currency: $leftCurrency,
                        showSelectCurrency: $showSelectCurrency,
                        amount: sanitized($leftAmount),
                        focusedField: $focusedField
                    )
                    
                    // = sign
                    Image(systemName: "equal")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .symbolEffect(.pulse)
                    
                    // right conversion section
                    CurrencyToConvert(
                        side: .right,
                        currency: $rightCurrency,
                        showSelectCurrency: $showSelectCurrency,
                        amount: sanitized($rightAmount),
                        focusedField: $focusedField
                    )
                }
                .padding()
                .background(.black.opacity(0.5))
                .clipShape(.capsule)
                .keyboardType(.decimalPad)
        
                Spacer()
                HStack {
                    Spacer()
                    
                    // Info Button
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
        .onChange(of: leftAmount){ _, newVal in
            if focusedField == .left {
                rightAmount = leftCurrency.convert(newVal, to: rightCurrency)
            }
        }
        .onChange(of: rightAmount){ _, newVal in
            if focusedField == .right {
                leftAmount = rightCurrency.convert( newVal, to: leftCurrency)
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

private func sanitized(_ source: Binding<String>) -> Binding<String> {
    Binding(
        get: { source.wrappedValue },
        set: { source.wrappedValue = sanitizeNumber($0) }
    )
}


func sanitizeNumber(_ input: String) -> String {
    var result = ""
    var seenDot = false
    
    for ch in input {
        if ch.isNumber {
            result.append(ch)
        } else if ch == "." {
            if !seenDot {
                seenDot = true
                result.append(ch)
            }
            // ignore additional dots
        }
        // ignore everything else
    }
    
    return result
}
