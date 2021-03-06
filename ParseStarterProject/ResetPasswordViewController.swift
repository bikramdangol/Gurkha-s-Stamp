//
//  ResetPasswordViewController.swift
//  Gurkha's Stamp
//
//  Created by Babu Ram Aryal on 12/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class ResetPasswordViewController: UIViewController {

    @available(iOS 8.0, *)
    @IBAction func submitEmailButtonPressed(_ sender: UIButton) {
        let email = userEmail.text!
        
        if self.isValidEmail(email) {
            let query = PFUser.query()
            query!.whereKey("email", equalTo:email)
            var user:[PFObject] = []
            do {
               user = try query!.findObjects()
            }
            catch {
                self.displayErrorMessage("Something went wrong, Please try again later.")
            }
            
            if user.count > 0 {
                PFUser.requestPasswordResetForEmail(inBackground: userEmail.text!)
                
                let alertController = UIAlertController(title: "Reset Password", message: "We have sent you an email that contains a link to reset your password.", preferredStyle: UIAlertControllerStyle.alert)
                
                alertController.addAction(UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.default,
                    handler: { alertController in self.processSignOut()})
                )
                // Display alert
                self.present(alertController, animated: true, completion: nil)
                
                print("Password reset lik has been sent to \(email)")
            }
            else {
                self.displayErrorMessage("This email is not registered, please check the email you entered.")
            }
        }
        else {
            self.displayErrorMessage("Please enter valid email.")
        }
    }
    @IBOutlet weak var userEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isValidEmail(_ emailString:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: emailString)
    }
    
    
    // Sign the current user out of the app
    func processSignOut() {
        
        // // Sign out
        PFUser.logOut()
        
        // Display sign in / up view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.present(vc, animated: true, completion: nil)
    }

    @available(iOS 8.0, *)
    func displayErrorMessage(_ message:String) {
    
        let alertController = UIAlertController(title: "Reset Password",
                            message: message,
                            preferredStyle: UIAlertControllerStyle.alert
                            )
        alertController.addAction(UIAlertAction(title: "OK",
                                style: UIAlertActionStyle.default,
                                handler: nil)
                                )
        // Display alert
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
