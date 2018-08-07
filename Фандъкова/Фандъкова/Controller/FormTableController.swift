//
//  FormTableController.swift
//  Фандъкова
//
//  Created by Boris Angelov on 6.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit
import CoreLocation

class FormTableController: UITableViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        addressTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    //MARK: Outlets and Properties
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBOutlet weak var cameraImage: UIImageView!
    
    @IBAction func showCamera(_ sender: UIButton) {
        setImage()
    }
    let categories = ["Tyrion", "LASAGNA", "LOVE", "ZEN"]
    var selectedCategory: String?
    var address: String?
    var delegate: LocationDelegate?
    var userLocation: CLLocation{
        get{
            return (delegate?.getLocation())!
        } }
    
    func setImage(){
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            self.cameraImage.image = image
        }
    }
    
}




//PickerView Extension /methods/
extension FormTableController: UIPickerViewDataSource, UIPickerViewDelegate{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
}

extension FormTableController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
