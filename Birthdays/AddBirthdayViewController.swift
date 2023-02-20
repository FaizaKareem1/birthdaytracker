//
//  ViewController.swift
//  BirthdayTracker
//
//  Created by Faiza Kareem on 19/02/2023.
//

import UIKit
import CoreData
import UserNotifications

/*protocol AddBirthdayViewControllerDelegate{
    func addBirthdayViewController(_ addBirthdayViewController: AddBirthdayViewController, didAddBirthday birthday: Birthday)
}*/ //Not needed anymore - Cleanup

class AddBirthdayViewController: UIViewController {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var birthdatePicker: UIDatePicker!
    
    //var delegate: AddBirthdayViewControllerDelegate? //CLEANUP

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        birthdatePicker.maximumDate = Date()
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem){
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let birthdate = birthdatePicker.date
        //let newBirthday = Birthday(firstName: firstName, lastName: lastName, birthdate: birthdate)
        //delegate?.addBirthdayViewController(self, didAddBirthday: newBirthday)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newBirthday = Birthday(context: context)
        newBirthday.firstName = firstName
        newBirthday.lastName = lastName
        newBirthday.birthdate = birthdate 
        newBirthday.birthdayId = UUID().uuidString
        
        if let uniqueId = newBirthday.birthdayId{
            print("The birthday ID is \(uniqueId)")
        }
        
        do{
            try context.save()
            let message = "Wish \(firstName) \(lastName) a Happy Birthday today!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            
            var dateComponents = Calendar.current.dateComponents([.month,.day], from: birthdate)
            dateComponents.hour = 8
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            if let identifier = newBirthday.birthdayId{
                
                let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
        } catch let error{
            print("Could not save because of \(error)")
        }
        
        dismiss(animated: true,completion: nil)
        
        /*print("Created a Birthday!")
        print("First name: \(newBirthday.firstName)")
        print("Last name: \(newBirthday.lastName)")
        print("Birthdate: \(newBirthday.birthdate)")*/
        
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)//competition is an optional closure
        //A closure is a block of code that can be passed into the function. The completion closure can be used for any code you want to run after the view controller is dismissed.
    }
    
    


}

