//
//  MyListViewController+UITableView.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 13/06/24.
//

import UIKit

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyListTableViewCell
        
        cell.selectionStyle = .none
        
        // Konfigurasikan cell
        cell.pokemonLabel?.text = pokemons[indexPath.row]
        cell.pokemonImage.kf.setImage(with: URL(string: result[indexPath.row].imageURL))
        
        cell.editAction = {
            let alert = UIAlertController(title: "Edit Nama", message: nil, preferredStyle: .alert)

            alert.addTextField { (textField) in
                var pokemon  = self.pokemons[indexPath.row]
                if let number = Int(pokemon[pokemon.count-1]) {
                    pokemon = String(pokemon.dropLast())
                    pokemon += "\(number+1)"
                } else {
                    pokemon += "-0"
                }
                textField.text = pokemon
            }
            
            let ubahAction = UIAlertAction(title: "Ubah", style: .default) { (_) in
                if let namaField = alert.textFields?.first, let namaBaru = namaField.text {
                    // Kode untuk mengubah nama di Core Data
                    self.editPokemon(row: indexPath.row, name: namaBaru)
                }
            }

            let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)

            alert.addAction(ubahAction)
            alert.addAction(batalAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        cell.deleteAction = {
            self.getRandomNumber { number in
                if number.isPrimeNumber() {
                    self.deletePokemon(row: indexPath.row)
                } else {
                    self.showAlert(title: "Release Failed", message: "Release Pokemon Failed!")
                }
            }
        }
        
        return cell
    }
    
    private func getRandomNumber(completion: ((Int) -> Void)?) {
        let url = "\(Global.RANDOM_NUMBER_URL)?min=0&max=100&count=1"

        
        APIHelper.getAPI(url: url) { value in
            if let jsonArray = value as? [Int] {
                print("Angka acak: \(jsonArray.first ?? 0)")
                completion?(jsonArray.first ?? 0)
            }
        } didFail: { error in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = PokemonDetailViewController()
        detailVC.urlPokemonString = self.result[indexPath.row].detailURL
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

}
