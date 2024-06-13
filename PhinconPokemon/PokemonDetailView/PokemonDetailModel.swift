//
//  PokemonDetailModel.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 12/06/24.
//

import Foundation

struct PokemonDetail: Codable {
    let abilities: [Ability]
    let moves: [Move]
    let types: [Types]
    let sprites: Sprite
    var name: String

    enum CodingKeys: String, CodingKey {
        case abilities, name, moves, sprites, types
    }
}

struct Data: Codable {
    var name: String
    var url: String
    
    enum CodingKeys: String, CodingKey {
        case name, url
    }
}

struct Types: Codable {
    let type: Data
    
    enum CodingKeys: String, CodingKey {
        case type
    }
}


struct Ability: Codable {
    let ability: Data
    
    enum CodingKeys: String, CodingKey {
        case ability
    }
}

struct Move: Codable {
    let move: Data
    
    enum CodingKeys: String, CodingKey {
        case move
    }
}

struct Sprite: Codable {
    var frontDefault: String
    
    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
