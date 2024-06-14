//
//  ViewController.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 12/06/24.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    var pokemonReponse: PokemonResponse?

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home"
        addRightBarButton()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        callAPI()
    }
    
    private func addRightBarButton() {
        let rightBarButton = UIBarButtonItem(title: "My List", style: .plain, target: self, action: #selector(rightBarButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightBarButtonTapped() {
        // Lakukan tindakan yang diinginkan saat tombol ditekan
        self.navigationController?.pushViewController(MyListViewController(), animated: true)
    }

    private func callAPI() {
        let url = "https://pokeapi.co/api/v2/pokemon"

        APIHelper.getAPIWithCodable(url: url, type: PokemonResponse.self) { pokemonResponse in
            self.pokemonReponse = pokemonResponse
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } didFail: { error in
            print(error.localizedDescription)
            
        }
    }
}
