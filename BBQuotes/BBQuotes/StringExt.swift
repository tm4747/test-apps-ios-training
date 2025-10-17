//
//  StringExt.swift
//  BBQuotes
//
//  Created by Tom Molinaro on 10/17/25.
//

extension String {
    /*
     IN swift, if you only have 1 line in your function, it automatically returns that
     */
    func removeSpaces() -> String {
        self.replacingOccurrences(of: " ", with: "") // equivalent to:  return self.replacingOccurrences(of: " ", with: "")
    }
    
    func removeCaseAndSpace() -> String {
        self.removeSpaces().lowercased()
    }
}
