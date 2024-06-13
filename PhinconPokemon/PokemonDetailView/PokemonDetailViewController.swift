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
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PhinconPokemon")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    @IBAction func catchButtonClicked(_ sender: UIButton) {
        let randomInt = Int.random(in: 0...1)
        if randomInt == 0 {
            self.showAlert(title: "Catch Pokemon Failed", message: "You need to recatch them again.")
        } else {
            setNama()
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
                self.saveToCoreData(name: namaBaru)
            }
        }

        let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)

        alert.addAction(ubahAction)
        alert.addAction(batalAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func saveToCoreData(name: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)
        let newEntity = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        newEntity.setValue(name, forKey: "pokemonNickname")
        
        do {
            try managedContext.save()
            self.showAlert(title: "Catch Pokemon Succeed", message: "Congrats! Pokemon shows on your Pokemon List")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var typesLabel: UILabel!
    @IBOutlet weak var pokemonLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        callAPI()
    }
    
    private func callAPI() {
        AF.request(urlPokemonString, method: .get).responseDecodable(of: PokemonDetail.self) { response in
            switch response.result {
            case .success(let pokemonResponse):
                self.pokemonReponse = pokemonResponse
                DispatchQueue.main.async {
                    self.updateUI()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func updateUI() {
        var movesString = "Moves: "
        var endIndex = (pokemonReponse?.moves ?? []).count
        if (pokemonReponse?.moves ?? []).count > 50 {
            endIndex = 50
        }
        for index in 0..<endIndex {
            movesString.append("\((pokemonReponse?.moves ?? [])[index].move.name),")
        }
        movesLabel.text = movesString
        
        var typesString = "Types: "
        endIndex = (pokemonReponse?.types ?? []).count
        if (pokemonReponse?.types ?? []).count > 50 {
            endIndex = 50
        }
        for index in 0..<endIndex {
            typesString.append("\((pokemonReponse?.types ?? [])[index].type.name),")
        }
        typesLabel.text = typesString
        
        pokemonLabel.text = pokemonReponse?.name ?? ""
        imageView.kf.setImage(with: URL(string: pokemonReponse?.sprites.frontDefault ?? ""))
    }
    
}
