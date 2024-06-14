//
//  PokemonDetailViewController+UITableView.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 14/06/24.
//

import UIKit

extension PokemonDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return pokemonReponse?.moves.count ?? 0
        } else if section == 1 {
            return pokemonReponse?.types.count ?? 0
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Moves"
        } else if section == 1 {
            return "Types"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.textLabel?.text = pokemonReponse?.moves[indexPath.row].move.name
        } else if indexPath.section == 1 {
            cell.textLabel?.text = pokemonReponse?.types[indexPath.row].type.name
        }
        
        return cell
    }
}
