//
//  LoginViewController.swift
//  Test EMI
//
//  Created by Jose Francisco Rosales Hernandez on 03/09/17.
//  Copyright © 2017 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let utils : Utils = Utils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Login Action
    @IBAction func loginAction(_ sender: AnyObject) {
        if(utils.checkInternet())
        {
            if self.emailTextField.text == "" || self.passwordTextField.text == "" {
                
                //Alert to tell the user that there was an error because they didn't fill anything in the textfields because they didn't fill anything in
                
                let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                self.present(alertController, animated: true, completion: nil)
                
            } else {
                utils.showLoadingAlert(controller: self)
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                    
                    self.dismiss(animated: false, completion: {
                        if error == nil {
                            
                            //Print into the console if successfully logged in
                            print("You have successfully logged in")
                            
                            //Save email
                            let userDefaults = UserDefaults.standard
                            userDefaults.set(self.emailTextField.text, forKey: "email")
                            
                            //Go to the HomeViewController if the login is sucessful
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                            self.present(vc!, animated: true, completion: nil)
                            
                        } else {
                            //Tells the user that there is an error and then gets firebase to tell them the error
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
