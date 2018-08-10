//
//  LocationCell.swift
//  Фандъкова
//
//  Created by Boris Angelov on 6.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell, UITextFieldDelegate{
    
    @IBOutlet weak var newButton: UIButton?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newButton?.setBackgroundImage(UIImage(named: "location1"), for: .normal)
    }
    
    @IBOutlet weak var addressLabel: UILabel?
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
