//
//  ViewControllerHelper.swift
//  PhinconPokemon
//
//  Created by Tommy Ryanto on 14/06/24.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
}
