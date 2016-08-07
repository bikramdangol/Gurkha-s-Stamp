//
//  RegisterUserViewController.swift
//  Gurkha's Stamp
//
//  Created by Babu Ram Aryal on 12/20/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class RegisterUserViewController: UIViewController {

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

    @IBOutlet weak var userEmail: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var retypePassword: UITextField!
    
    
    @available(iOS 8.0, *)
    @IBAction func userRegisterButtonClicked(_ sender: UIButton){
        if !isValidEmail(userEmail.text!) {
            let alertController = UIAlertController(title: "Registration",
                message: "Please enter valid email.",
                preferredStyle: UIAlertControllerStyle.alert
            )
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.default,
                handler: nil)
            )
            // Display alert
            self.present(alertController, animated: true, completion: nil)
            return
        }
        
        if password.text == retypePassword.text {
             self.signup()
        }
        else {
            let alertController = UIAlertController(title: "Registration",
                message: "The password typed is not matching.",
                preferredStyle: UIAlertControllerStyle.alert
            )
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.default,
                handler: nil)
            )
            // Display alert
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @available(iOS 8.0, *)
    func signup()
    {
        var username = userEmail.text
        
        let userPassword = password.text
        
        // Ensure username is lowercase
        username = username!.lowercased()
        
       
        
        if self.isValidEmail(username!) {
            let query = PFUser.query()
            query!.whereKey("email", equalTo:username!)
            var user:[PFObject] = []
            do {
                user = try query!.findObjects()
            }
            catch {
                print("Something went wrong, Please try again later.")
                //self.displayErrorMessage("Something went wrong, Please try again later.")
            }
            
            if user.count > 1 {
                return
            }
        }
        
        let user = PFUser()
        user.username = username
        user.password = userPassword
        user.email = username
        user["emailVerified"] = true
        user["role"] = "customer"
        user["redeem"] = false
       
        
        user.signUpInBackground {
            (succeeded, error) -> Void in
            //self.activityIndicator.stopAnimating()
            if let error = error as? NSError {
                let errorString = error.userInfo["error"] as? NSString
                print(errorString)
                // Show the errorString somewhere and let the user try again.
                //self.activityIndicator.stopAnimating()
                
                // if let message: AnyObject = error!.userInfo!["error"] {
                //self.message.text = "\(errorString)"
                // }
            } else {
                // Hooray! Let them use the app now.
                // User needs to verify email address before continuing
                let alertController = UIAlertController(title: "Email address verification",
                    message: "We have sent you an email that contains a link - you must click this link before you can continue.",
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alertController.addAction(UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.default,
                    handler: { alertController in self.processSignOut()})
                )
                // Display alert
                self.present(alertController, animated: true, completion: nil)
            }
        }
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
