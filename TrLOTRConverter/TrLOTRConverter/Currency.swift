//
//  Currency.swift
//  TrLOTRConverter
//
//  Created by Tom Molinaro on 9/7/25.
//

import SwiftUI

enum Currency: Double, CaseIterable, Identifiable {
    
    case marble = 64000
    case copperPenny = 6400
    case silverPenny = 64
    case silverPiece = 16
    case goldPenny = 4
    case goldPiece = 1
    
    var id: Currency { self }
    
    var image: ImageResource {
        switch self {
        case .marble:
                .amarble
        case .copperPenny:
                .copperpenny
        case .silverPenny:
                .silverpenny
        case .silverPiece:
                .silverpiece
        case .goldPenny:
                .goldpenny
        case .goldPiece:
                .goldpiece
        }
    }
    
    var name: String {
        switch self {
        case .marble:
            "Marble"
        case .copperPenny:
            "Copper Penny"
        case .silverPenny:
            "Silver Penny"
        case .silverPiece:
            "Silver Piece"
        case .goldPenny:
            "Gold Penny"
        case .goldPiece:
            "Gold Piece"
        }
    }
    
    func convert(_ amountString: String, to currency: Currency) -> String{
        guard let doubleAmount = Double(amountString) else {
            return ""
        }
        
        let convertedAmount = (doubleAmount / self.rawValue) * currency.rawValue
        
        return String(format: "%.2f", convertedAmount)
        
    }
    
    // MARK: - Persistence Helpers
      
      /// Load a saved Currency from UserDefaults by key, falling back to a default
      static func load(forKey key: String, default defaultValue: Currency) -> Currency {
          let saved = UserDefaults.standard.string(forKey: key)
          return Self.allCases.first(where: { $0.name == saved }) ?? defaultValue
      }
      
      /// Save this Currency's name to UserDefaults
      func save(forKey key: String) {
          UserDefaults.standard.set(self.name, forKey: key)
      }
}
