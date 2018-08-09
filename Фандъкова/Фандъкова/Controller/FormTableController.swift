//
//  FormTableController.swift
//  Фандъкова
//
//  Created by Boris Angelov on 6.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit
import CoreLocation

class FormTableController: UITableViewController, DescriptionDelegate, AddressDelegate, LocationDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryPicker.delegate = self
        descriptionCell.delegate = self
        locationCell.addressDelegate = self
        
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
    var userAddress: String?
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
        
        //prepare for segue
        //show map
        //set location's controller delegate to self
        //then we can modify the cell  
    }
    
    //delegation updates
    @IBOutlet weak var descriptionCell: DescriptionCell!
    @IBOutlet weak var locationCell: LocationCell!

    func descriptionUpdated(text: String) {
        userDescription = text
    }
    
    func addressUpdated(text: String) {
        userAddress = text
    }
    func setLocation(location: CLLocation){
        userLocation = location
    }
    
    func locationChanged(){
        //TODO: set the image
       // locationCell.newButton?.currentBackgroundImage = UIImage()
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
