//
//  IntegerHelper.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 14/06/24.
//

import Foundation

extension Int {
    func isPrimeNumber() -> Bool {
        guard self >= 2 else { return false }

        for i in 2..<self {
            if self % i == 0 {
                return false
            }
        }

        return true
    }
}
