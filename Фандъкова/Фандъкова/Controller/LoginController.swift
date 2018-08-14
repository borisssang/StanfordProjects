//
//  LoginController.swift
//  Фандъкова
//
//  Created by Boris Angelov on 14.08.18.
//  Copyright © 2018 Melon. All rights reserved.
//

import UIKit

class LoginController: UIViewController, UITextFieldDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        phoneTextField.delegate = self
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        setUpTextFieldsAndButtons()
    }
    
    var dataForm: FormData?
    
    //Outlets
       @IBOutlet var firstNameTextField: UITextField!
       @IBOutlet var lastNameTextField: UITextField!
       @IBOutlet var emailTextField: UITextField!
       @IBOutlet var phoneTextField: UITextField!
    @IBOutlet weak var loginOutlet: UIButton!
    @IBOutlet weak var registerOutlet: UIButton!
    
    @IBAction func LoginButton(_ sender: Any) {

    }
    
    @IBAction func RegisterButton(_ sender: Any) {
        performSegue(withIdentifier: "showForm", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier, identifier == "showForm" {
            if let navVC = segue.destination as? UINavigationController{
                if let vc = navVC.topViewController as? FormTableController {
                      let newTemplate = FormData(first: firstNameTextField.text!, last: lastNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!)
                    vc.formData = newTemplate
                }
            }
        }
    }
    
    //MARK: TEXTshit
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func setUpTextFieldsAndButtons(){
        firstNameTextField.layer.borderWidth = 1
        firstNameTextField.layer.borderColor = UIColor.white.cgColor
        firstNameTextField.layer.cornerRadius = 20
        firstNameTextField.clipsToBounds = true
        
        lastNameTextField.layer.borderWidth = 1
        lastNameTextField.layer.borderColor = UIColor.white.cgColor
        lastNameTextField.layer.cornerRadius = 20
        lastNameTextField.clipsToBounds = true
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.cornerRadius = 20
        emailTextField.clipsToBounds = true
        
        phoneTextField.layer.borderWidth = 1
        phoneTextField.layer.borderColor = UIColor.white.cgColor
        phoneTextField.layer.cornerRadius = 20
        phoneTextField.clipsToBounds = true
        
        loginOutlet.layer.cornerRadius = 20
        loginOutlet.clipsToBounds = true
        
        registerOutlet.layer.cornerRadius = 20
        registerOutlet.clipsToBounds = true
        
    }
    
}
