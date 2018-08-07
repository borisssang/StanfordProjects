//
//  LocationCell.swift
//  Фандъкова
//
//  Created by Boris Angelov on 6.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell{

    override func awakeFromNib() {
        super.awakeFromNib()
        manageButtonAppearance()
    }

     var delegate: LocationDelegate?
    
    @IBOutlet weak var oldButton: UIButton?{
        willSet{
            manageButtonAppearance()
        }
    }
    @IBOutlet weak var newButton: UIButton?{
        willSet{
            manageButtonAppearance()
        }
    }
    
    func manageButtonAppearance(){
        if let _ = delegate?.locationChanged{
            self.oldButton?.isHidden = true
            self.newButton?.isHidden = false
            }
             else {
            self.oldButton?.isHidden = false
            self.newButton?.isHidden = true
            }
        }
}
