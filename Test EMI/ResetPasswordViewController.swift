//
//  ResetPasswordViewController.swift
//  Test EMI
//
//  Created by Jose Francisco Rosales Hernandez on 03/09/17.
//  Copyright © 2017 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var emailTextField: UITextField!
    
    let utils : Utils = Utils()
    
    // Reset Password Action
    @IBAction func submitAction(_ sender: AnyObject) {
        
        if(utils.checkInternet())
        {
            if self.emailTextField.text == "" {
                let alertController = UIAlertController(title: "Oops!", message: "Please enter an email.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                
            } else {
                utils.showLoadingAlert(controller: self)
                Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                    
                    self.dismiss(animated: false, completion: {
                        var title = ""
                        var message = ""
                        
                        if error != nil {
                            title = "Error!"
                            message = (error?.localizedDescription)!
                        } else {
                            title = "Success!"
                            message = "Password reset email sent."
                            self.emailTextField.text = ""
                        }
                        
                        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    })
                })
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
