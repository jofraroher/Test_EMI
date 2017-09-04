//
//  HomeViewController.swift
//  Test EMI
//
//  Created by Jose Francisco Rosales Hernandez on 03/09/17.
//  Copyright © 2017 Jose Francisco Rosales Hernandez. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet var firstNameTxt: UITextField!
    @IBOutlet var lastNameTxt: UITextField!
    @IBOutlet var addresTxt: UITextField!
    @IBOutlet var cityTxt: UITextField!
    @IBOutlet var zipCodeTxt: UITextField!
    @IBOutlet var phoneTxt: UITextField!
    
    @IBOutlet var saveBtn: UIButton!
    @IBOutlet var deleteBtn: UIButton!
    
    var selectedfunction : Int = 0
    var userExist : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sortUser()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveData(_ sender: UIButton) {
        
        if(self.firstNameTxt.text != "" && self.lastNameTxt.text != "" && self.addresTxt.text != ""
                && self.cityTxt.text != "" && self.zipCodeTxt.text != "" && self.phoneTxt.text != "")
        {
            switch selectedfunction {
            case 0:
                self.selectedfunction = 1
                self.saveBtn.setTitle("Edit data", for: .normal)
                self.disableTextfields()
                self.deleteBtnAction()
                if userExist
                {
                   self.updateUser(firstName: self.firstNameTxt.text!, lastName: self.lastNameTxt.text!, address: self.addresTxt.text!, city: self.cityTxt.text!, zipCode: self.zipCodeTxt.text!, phone: self.phoneTxt.text!)
                }
                else
                {
                    self.save(firstName: self.firstNameTxt.text!, lastName: self.lastNameTxt.text!, address: self.addresTxt.text!, city: self.cityTxt.text!, zipCode: self.zipCodeTxt.text!, phone: self.phoneTxt.text!)
                }
            case 1:
                self.selectedfunction = 0
                self.deleteBtnAction()
                self.saveBtn.setTitle("Save data", for: .normal)
                self.disableTextfields()
            default:
                print("No selected action")
            }
        }
        else
        {
            let alertController = UIAlertController(title: "Error", message: "Please fill all the fields.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
    }
    @IBAction func deleteData(_ sender: Any) {
        self.resetTextfields()
        self.deleteBtnAction()
        self.selectedfunction = 0
        self.disableTextfields()
        self.saveBtn.setTitle("Save data", for: .normal)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // Managed Context of data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //create a fetch request, telling it about the entity
        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            //go get the results
            let array_people = try managedContext.fetch(fetchRequest)
            
            //You need to convert to NSManagedObject to use 'for' loops
            for user in array_people as [NSManagedObject] {
                //get the Key Value pairs (although there may be a better way to do that...
                managedContext.delete(user)
            }
            //save the context
            
            do {
                try managedContext.save()
                self.userExist = false
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func sortUser()
    {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // Managed Context of data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "email", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Add Predicate
        let userDefaults = UserDefaults.standard
        let valueEmail  = userDefaults.string(forKey: "email")
        let predicate1 = NSPredicate(format: "email = %@",valueEmail!)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate1])
        
        do {
            let records = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for record in records {
                self.selectedfunction = 1
                self.saveBtn.setTitle("Edit data", for: .normal)
                self.disableTextfields()
                self.deleteBtnAction()
                self.firstNameTxt.text = record.value(forKey: "firstName") as? String
                self.lastNameTxt.text = record.value(forKey: "lastName") as? String
                self.addresTxt.text = record.value(forKey: "address") as? String
                self.cityTxt.text = record.value(forKey: "city") as? String
                self.zipCodeTxt.text = record.value(forKey: "zipCode") as? String
                self.phoneTxt.text = record.value(forKey: "phone") as? String
                self.userExist = true
            }
            
        } catch {
            print(error)
        }

    }
    
    func save(firstName: String, lastName: String, address: String, city: String, zipCode: String, phone: String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // Managed Context of data
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Define the entity of the DB
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // Fill the entity
        person.setValue(firstName, forKeyPath: "firstName")
        person.setValue(lastName, forKeyPath: "lastName")
        person.setValue(address, forKeyPath: "address")
        person.setValue(city, forKeyPath: "city")
        person.setValue(zipCode, forKeyPath: "zipCode")
        person.setValue(phone, forKeyPath: "phone")
        let userDefaults = UserDefaults.standard
        let valueEmail  = userDefaults.string(forKey: "email")
        person.setValue(valueEmail, forKeyPath: "email")
        
        // Save data on DB
        do {
            try managedContext.save()
            self.userExist = true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateUser (firstName:String, lastName:String, address:String, city:String, zipCode:String, phone:String) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // Managed Context of data
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Person> = Person.fetchRequest()
        
        do {
            let array_users = try managedContext.fetch(fetchRequest)
            let user = array_users[0]
            
            user.setValue(firstName, forKeyPath: "firstName")
            user.setValue(lastName, forKeyPath: "lastName")
            user.setValue(address, forKeyPath: "address")
            user.setValue(city, forKeyPath: "city")
            user.setValue(zipCode, forKeyPath: "zipCode")
            user.setValue(phone, forKeyPath: "phone")
            
            //save the context
            do {
                try managedContext.save()
                print("saved!")
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            } catch {
                
            }
            
        } catch {
            print("Error with request: \(error)")
        }
    }
    
    func disableTextfields()
    {
        self.firstNameTxt.isEnabled = !self.firstNameTxt.isEnabled
        self.lastNameTxt.isEnabled = !self.lastNameTxt.isEnabled
        self.addresTxt.isEnabled = !self.addresTxt.isEnabled
        self.cityTxt.isEnabled = !self.cityTxt.isEnabled
        self.zipCodeTxt.isEnabled = !self.zipCodeTxt.isEnabled
        self.phoneTxt.isEnabled = !self.phoneTxt.isEnabled
    }
    
    func deleteBtnAction()
    {
        self.deleteBtn.isHidden = !self.deleteBtn.isHidden
    }
    
    func resetTextfields()
    {
        self.firstNameTxt.text = ""
        self.lastNameTxt.text = ""
        self.addresTxt.text = ""
        self.cityTxt.text = ""
        self.zipCodeTxt.text = ""
        self.phoneTxt.text = ""
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
}
