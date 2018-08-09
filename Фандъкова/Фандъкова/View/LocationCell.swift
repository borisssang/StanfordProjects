//
//  LocationCell.swift
//  Фандъкова
//
//  Created by Boris Angelov on 6.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

protocol AddressDelegate {
    func addressUpdated(text: String)
}

class LocationCell: UITableViewCell, UITextFieldDelegate{
    //create an image for the button
    @IBOutlet weak var newButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Textfield
    var addressDelegate: AddressDelegate?
    
    @IBOutlet weak var addressTextField: UITextField!{
        didSet{
            self.addressTextField.delegate = self
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let address = self.addressTextField.text{
            addressDelegate?.addressUpdated(text: address)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
