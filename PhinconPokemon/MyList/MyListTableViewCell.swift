//
//  MyListTableViewCell.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 13/06/24.
//

import UIKit

class MyListTableViewCell: UITableViewCell {

    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    
    @IBAction func editButtonTapped(_ sender: Any) {
        self.editAction?()
    }
    @IBAction func deleteButtonTapped(_ sender: Any) {
        self.deleteAction?()
    }
    @IBOutlet weak var pokemonImage: UIImageView!
    @IBOutlet weak var pokemonLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
