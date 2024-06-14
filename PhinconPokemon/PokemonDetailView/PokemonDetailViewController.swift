//
//  PokemonDetailViewController.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 12/06/24.
//

import UIKit
import Alamofire
import Kingfisher
import CoreData

class PokemonDetailViewController: UIViewController {

    var urlPokemonString: String = ""
    
    var pokemonReponse: PokemonDetail?
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func catchButtonClicked(_ sender: UIButton) {
        getRandomNumber { randomInt in
            if randomInt < 50 {
                self.showAlert(title: "Catch Pokemon Failed", message: "You need to recatch them again.")
            } else {
                self.setNama()
            }
        }
    }
    
    private func setNama() {
        let alert = UIAlertController(title: "Set Nama", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.pokemonReponse?.name ?? "" // Set nilai awal dari nama yang ingin diubah
        }
        
        let ubahAction = UIAlertAction(title: "Set", style: .default) { (_) in
            if let namaField = alert.textFields?.first, let namaBaru = namaField.text {
                // Kode untuk mengubah nama di Core Data
//                self.updateNamaInCoreData(namaBaru, beforeName: self.pokemons[indexPath.row])
//                self.saveToCoreData(name: namaBaru)
                self.postPokemonData(name: namaBaru, pokemonImageURL: self.pokemonReponse?.sprites.frontDefault ?? "")
                
            }
        }

        let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)

        alert.addAction(ubahAction)
        alert.addAction(batalAction)
        present(alert, animated: true, completion: nil)
    }
    
    func postPokemonData(name: String, pokemonImageURL: String) {
        let url = "\(Global.FIREBASE_URL)/pokemon.json"
        let parameters: [String: Any] = [
            "name": name,
            "imageURL": pokemonImageURL,
            "detailURL": urlPokemonString
        ]
        
        APIHelper.postAPI(url: url, parameters: parameters) {
            print("Data berhasil dipost")
            self.showAlert(title: "Catch Pokemon Succeed", message: "Congrats! Pokemon shows on your Pokemon List")
        } didError: { error in
            print("Error posting data: \(error.localizedDescription)")
        }
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
    
//    @IBOutlet weak var movesLabel: UILabel!
//    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Detail Pokemon"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        callAPI()
    }
    
    private func callAPI() {
        APIHelper.getAPIWithCodable(url: urlPokemonString, type: PokemonDetail.self) { pokemonResponse in
            self.pokemonReponse = pokemonResponse
            DispatchQueue.main.async {
                self.updateUI()
            }
        } didFail: { error in
            print(error.localizedDescription)
        }
    }
    
    private func updateUI() {
        pokemonLabel.text = pokemonReponse?.name ?? ""
        imageView.kf.setImage(with: URL(string: pokemonReponse?.sprites.frontDefault ?? ""))
        
        tableView.reloadData()
    }
    
}
