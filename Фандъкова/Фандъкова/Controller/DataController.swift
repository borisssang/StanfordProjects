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
        if userDescription != nil && userAddress != nil && category != nil {
            addressLabel.text = userAddress
            categoryLabel.text = category
            descriptionLabel.text = userDescription
        }
       
    }

    var userAddress: String?
    var userLocation: CLLocation?
    var userDescription: String?
    var category: String?
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
}
