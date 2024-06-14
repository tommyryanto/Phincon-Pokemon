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
