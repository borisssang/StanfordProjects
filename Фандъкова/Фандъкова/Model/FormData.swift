//
//  FormData.swift
//  Фандъкова
//
//  Created by Boris Angelov on 14.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class FormData {
    private var firstName: String?
    private var lastName: String?
    private var userEmail: String?
    private var userPhone: String?
    private var formImage: UIImage?
    private var formAddress: String?
    private var formLocation: CLLocation?
    private var formCategory: String?
    private var formDescription: String?
    
    func setForm(image: UIImage, addres address: String, location: CLLocation, category: String, description: String) {
        formImage = image
        formAddress = address
        formLocation = location
        formCategory = category
        formDescription = description
    }
    
    init(first: String, last: String, email: String, phone: String){
        firstName = first
        lastName = last
        userEmail = email
        userPhone = phone
    }
}
