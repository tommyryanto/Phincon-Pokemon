//
//  MyListViewController.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 12/06/24.
//

import UIKit
import CoreData

class MyListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var result: [Entity] = []
    var pokemons: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        getCoreData()
    }

    private func getCoreData() {
        pokemons.removeAll()
        result.removeAll()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest()
//        let predicate = NSPredicate()
//        fetchRequest.predicate = predicate
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            
            self.result = results
            for result in results {
                // Akses nilai dari setiap objek hasil
                self.pokemons.append(result.pokemonNickname ?? "")
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Error fetching data: \(error)")
        }

    }
    
}

extension MyListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "DefaultCell"
        let cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        
        cell.selectionStyle = .none
        
        // Konfigurasikan cell
        cell.textLabel?.text = pokemons[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Nama", message: nil, preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.text = self.pokemons[indexPath.row] // Set nilai awal dari nama yang ingin diubah
        }
        
        let ubahAction = UIAlertAction(title: "Ubah", style: .default) { (_) in
            if let namaField = alert.textFields?.first, let namaBaru = namaField.text {
                // Kode untuk mengubah nama di Core Data
                self.updateNamaInCoreData(namaBaru, beforeName: self.pokemons[indexPath.row])
            }
        }

        let batalAction = UIAlertAction(title: "Batal", style: .cancel, handler: nil)

        alert.addAction(ubahAction)
        alert.addAction(batalAction)
        present(alert, animated: true, completion: nil)

    }
    
    func updateNamaInCoreData(_ namaBaru: String, beforeName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Entity> = Entity.fetchRequest() // Ganti Entity dengan nama entitas Anda
        
        // Tambahkan predicate jika diperlukan untuk memfilter entitas yang ingin diubah
         fetchRequest.predicate = NSPredicate(format: "pokemonNickname == %@", beforeName)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let entityToUpdate = results.first { // Mengasumsikan hanya ada satu entitas yang diubah
                entityToUpdate.setValue(namaBaru, forKey: "pokemonNickname") // Ganti namaAtribut dengan nama atribut yang menyimpan nama
                
                try context.save()
                print("Nama berhasil diubah")
                
                DispatchQueue.main.async {
                    self.getCoreData()
                }
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteEntity(self.result[indexPath.row])
        }
    }
    
    func deleteEntity(_ entity: Entity) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(entity)
        
        do {
            try managedContext.save()
            print("Entitas berhasil dihapus")
            DispatchQueue.main.async {
                self.getCoreData()
            }
        } catch let error as NSError {
            print("Tidak dapat menghapus entitas. \(error), \(error.userInfo)")
        }
    }


}
