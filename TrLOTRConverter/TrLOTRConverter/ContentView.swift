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
    /**
    @State is a SwiftUI property wrapper that tells SwiftUI to store the value in special view-owned storage.
     When the value changes, SwiftUI invalidates the view’s body and recomputes it. This is what gives you “reactive” UI updates.
     */
    @State var showExchangeInfo = false
    @State var showSelectCurrency = false

    /**
     @AppStorage - is basically a @State variable which saves to UserDefaults, which is a persistent key-value storage provided by Ios, and is therefore persistent between app loads. 
     */
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
                    /**
                     When variables are binding, a dollar side needs to preceed variable name.  This will allow the child component to modify it.  To just pass the value, just use variable name.
                     */
                    CurrencyToConvert(
                        side: .left,
                        currency: $leftCurrency,
                        showSelectCurrency: $showSelectCurrency,
                        amount: $leftAmount,
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
                        amount: $rightAmount,
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
            let sanitizedAmount = sanitizeNumber(newVal)
            leftAmount = sanitizedAmount
            if focusedField == .left {
                rightAmount = leftCurrency.convert(sanitizedAmount, to: rightCurrency)
            }
        }
        .onChange(of: rightAmount){ _, newVal in
            let sanitizedAmount = sanitizeNumber(newVal)
            rightAmount = sanitizedAmount
            if focusedField == .right {
                leftAmount = rightCurrency.convert( sanitizedAmount, to: leftCurrency)
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

/** removes non-numeric characters and allows for one dot at most */
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
        }
    }
    return result
}
