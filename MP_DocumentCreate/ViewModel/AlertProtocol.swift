//
//  AlertProtocol.swift
//  MP_DocumentCreate
//
//  Created by Rıdvan Dikmen on 27.10.2023.
//

import Foundation
import UIKit

protocol AlertProtocol {
    func showAlert(title: String, message: String)
}

extension AlertProtocol where Self: UIViewController {
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }
}
