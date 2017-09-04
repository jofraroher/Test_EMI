//
//  SignUpViewController.swift
//  Test EMI
//
//  Created by Jose Francisco Rosales Hernandez on 03/09/17.
//  Copyright © 2017 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let utils : Utils = Utils()
    
    //Sign Up Action for email
    @IBAction func createAccountAction(_ sender: AnyObject) {
        if(utils.checkInternet())
        {
            if self.emailTextField.text == "" || self.passwordTextField.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                
            } else {
                utils.showLoadingAlert(controller: self)
                Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    
                    self.dismiss(animated: false, completion: {
                        if error == nil {
                            print("You have successfully signed up")
                            //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                            
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                            self.present(vc!, animated: true, completion: nil)
                            
                        } else {
                            let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                            
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            
                            self.present(alertController, animated: true, completion: nil)
                        }
                    })
                }
            }
        }
        else
        {
            //Tells the user that there is no internet conexion
            let alertController = UIAlertController(title: "Error", message: "No internet conexion", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    
}
