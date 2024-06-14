//
//  MyListViewController.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 12/06/24.
//

import UIKit
import Alamofire

class MyListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
//    var result: [Entity] = []
    var result: [MyListModel] = []
    var pokemons: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "My Pokemon List"
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "MyListTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        getMyList()
    }
    
    private func getMyList() {
        result.removeAll()
        pokemons.removeAll()
        
        let url = "\(Global.FIREBASE_URL)/pokemon.json"

        APIHelper.getAPI(url: url) { value in
            if let jsonData = value as? [String: Any] {
                // Akses data JSON di sini
                print(jsonData)
                for (key, value) in jsonData {
                    let valueDict = value as? [String: String]
                    self.pokemons.append(valueDict?["name"] ?? "")
                    self.result.append(MyListModel(key: key, pokemon: valueDict?["name"] ?? "", imageURL: valueDict?["imageURL"] ?? "", detailURL: valueDict?["detailURL"] ?? ""))
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } didFail: { error in
            print("Error: \(error.localizedDescription)")
        }

    }
    
    func editPokemon(row: Int, name: String) {
        let key = result[row].key
        let url = "\(Global.FIREBASE_URL)/pokemon/\(key).json"
        
        let imageURL = result[row].imageURL
        let parameters: [String: Any] = [
            "name": name,
            "imageURL": imageURL
        ]
        
        APIHelper.putAPI(url: url, parameters: parameters) {
            print("Data berhasil diupdate")
            DispatchQueue.main.async {
                self.getMyList()
            }
        } didError: { error in
            print("Error updating data: \(error.localizedDescription)")
        }
    }
    
    func deletePokemon(row: Int) {
        let key = result[row].key
        let url = "\(Global.FIREBASE_URL)/pokemon/\(key).json"
        
        APIHelper.deleteAPI(url: url) {
            print("Data berhasil dihapus")
            DispatchQueue.main.async {
                self.getMyList()
            }
        } didError: { error in
            print("Error deleting data: \(error.localizedDescription)")
        }
    }
    
}
