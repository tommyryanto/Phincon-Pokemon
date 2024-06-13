//
//  PokemonModel.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 12/06/24.
//

import Foundation
struct PokemonResponse: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Pokemon]
    
    enum CodingKeys: String, CodingKey {
        case count
        case next
        case previous
        case results
    }
}

struct Pokemon: Codable {
    let name: String
    let url: String
    
    func getId() -> String {
        return "\(url[url.count-2])"
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case url
    }
}

extension String {

    var length: Int {
        return count
    }

    subscript (i: Int) -> String {
        return self[i ..< i + 1]
    }

    func substring(fromIndex: Int) -> String {
        return self[min(fromIndex, length) ..< length]
    }

    func substring(toIndex: Int) -> String {
        return self[0 ..< max(0, toIndex)]
    }

    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start ..< end])
    }
}
