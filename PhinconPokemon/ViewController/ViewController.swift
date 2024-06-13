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

        AF.request(url, method: .get).responseDecodable(of: PokemonResponse.self) { response in
            switch response.result {
            case .success(let pokemonResponse):
                self.pokemonReponse = pokemonResponse
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
