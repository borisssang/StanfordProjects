//
//  FormTableController.swift
//  Фандъкова
//
//  Created by Boris Angelov on 6.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit
import CoreLocation

class FormTableController: UITableViewController, DescriptionDelegate, LocationDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //delegates used for getting the data from the cells
        categoryPicker.delegate = self
        descriptionCell.delegate = self
        
        //gesture to disable the keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: MODEL
    var userImage: UIImage?{
        get {
            if let image = cameraImage.image{
                return image
            }
            return UIImage()
        }
    }
    var userAddress: String?{
        didSet{
            locationCell.addressLabel?.text = self.userAddress!
        }
    }
    var userLocation: CLLocation?
    let categories = ["Улици", "Замърсяване", "Съоръжения", "Сгради и Строежи", "Други"]
    var selectedCategory: String?
    var userDescription: String?
    
    //MARK: Outlets and Properties
    @IBOutlet weak var cameraImage: UIImageView!
    @IBOutlet weak var categoryPicker: UIPickerView!
    @IBAction func showCamera(_ sender: UIButton) {
        setImage()
    }
    
    func setImage(){
        CameraHandler.shared.showActionSheet(vc: self)
        CameraHandler.shared.imagePickedBlock = { (image) in
            let size = CGSize(width: 375, height: 155)
            self.cameraImage.image = image.resizeImage(newSize: size)
        }
    }
    
    @IBAction func showMap(_ sender: UIButton) {
        performSegue(withIdentifier: "showMap", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LocationViewController{
            if segue.identifier == "showMap" {
            destinationVC.delegate = self
            }
        } else if let destinationVC = segue.destination as? DataController {
            destinationVC.userAddress = userAddress!
            destinationVC.category = selectedCategory!
            destinationVC.userDescription = userDescription!
            destinationVC.userLocation = userLocation
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "showData"{
            guard userAddress != nil && userImage != nil &&  userLocation != nil && userDescription != nil else {return false}
            return true
        }
        return true
}
    
    @IBAction func showData(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "showData", sender: self)
    }
    
    
    //delegation updates
    @IBOutlet weak var descriptionCell: DescriptionCell!
    @IBOutlet weak var locationCell: LocationCell!
    
    func descriptionUpdated(text: String) {
        userDescription = text
    }
    
    func setLocation(location: CLLocation, address: String){
        userLocation = location
        userAddress = address
    }
    
    func locationChanged(){
        locationCell.newButton?.setBackgroundImage(UIImage(named: "location2"), for: .normal)
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

extension UIImage {
    func resizeImage(newSize: CGSize) -> UIImage {
        // Guard newSize is different
        guard self.size != newSize else { return self }
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func resizedImageWithinRect(rectSize: CGSize) -> UIImage {
        let widthFactor = size.width / rectSize.width
        let heightFactor = size.height / rectSize.height
        
        var resizeFactor = widthFactor
        if size.height > size.width {
            resizeFactor = heightFactor
        }
        
        let newSize = CGSize(width: size.width/resizeFactor, height: size.height/resizeFactor)
        let resized = resizeImage(newSize: newSize)
        return resized
    }
}
