//
//  DataController.swift
//  Фандъкова
//
//  Created by Boris Angelov on 10.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit
import CoreLocation
class DataController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        popUpVIew.layer.cornerRadius = 10
        popUpVIew.layer.masksToBounds = true
        
//        if userDescription != nil && userAddress != nil && category != nil {
//            addressLabel.text = userAddress
//            categoryLabel.text = category
//            descriptionLabel.text = userDescription
//        }
    }

    @IBOutlet weak var popUpVIew: UIView!
    var userAddress: String?
    var userLocation: CLLocation?
    var userDescription: String?
    var category: String?
    
    @IBAction func closePopUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}
