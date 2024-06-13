//
//  ViewController+UITableView.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 12/06/24.
//

import Foundation
import UIKit
import Kingfisher

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemonReponse?.results.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PokemonTableViewCell
        
        cell.selectionStyle = .none
        
        let pokemon = pokemonReponse?.results[indexPath.row]
        // Mengambil URL gambar dari data model Anda
        let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemon?.getId() ?? "0").png")
        
        // Memanggil fungsi untuk mengunduh gambar
        cell.pokemonImageView?.kf.setImage(with: imageURL)
        
        // Konfigurasikan cell lainnya
        cell.label?.text = pokemon?.name ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 134
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PokemonDetailViewController()
        vc.urlPokemonString = pokemonReponse?.results[indexPath.row].url ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
