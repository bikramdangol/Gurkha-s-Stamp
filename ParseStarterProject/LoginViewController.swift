//
//  LoginViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Bikram Dangol on 12/8/15.
//  Copyright © 2015 Parse. All rights  reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var registerLabel: UILabel!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var signupButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var message: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.passwordTextField.text = ""
        self.moveToHomeScreenIfAlreadyLoggedIn()
       
    }
    
    func moveToHomeScreenIfAlreadyLoggedIn()
    {
        if self.isEmailVerified()
        {
            
            self.checkRoleAndLogin(PFUser.currentUser()!)
            
        }
    }
    
    @available(iOS 8.0, *)
    @IBAction func loginButtonPressed(sender: UIButton) {
        if usernameTextField.text != nil && isValidEmail(usernameTextField.text!) &&
            passwordTextField.text != nil
        {
            self.signin()
            
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
       
    @available(iOS 8.0, *)
    func signin()
    {
        self.message.text = ""
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var username = usernameTextField.text!
        let userPassword = passwordTextField.text!
        
        // Ensure username is lowercase
        username = username.lowercaseString
        
        PFUser.logInWithUsernameInBackground(username, password:userPassword) {
            (user: PFUser?, error: NSError?) -> Void in
            self.activityIndicator.stopAnimating()
            if user != nil {
                // Do stuff after successful login.
                if self.isEmailVerified()
                {
                    self.checkRoleAndLogin(user!)
                }
                else
                {
                    let alert = UIAlertController(title: "Email address verification", message: "We have sent you an email that contains a link - you must click this link before you can continue.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                }
            } else {
                // The login failed. Check error to see why.
                let errorCode = error!.code as NSNumber
                switch errorCode
                {
                case 100:
                    self.message.text = ((error!.userInfo as NSDictionary)["error"] as! String) + " Please try again."
                    break
                case 101:
                    let alert = UIAlertController(title: "Invalid username/password", message: "Please enter valid username and password.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    break
                default:
                    self.message.text = ((error!.userInfo as NSDictionary)["error"] as! String)
                    break
                    
                }
            }
        }
    }
    
    func checkRoleAndLogin(user:PFUser) {
        if user["role"] as! String == "admin" {
            self.performSegueWithIdentifier("loginToAdminView", sender: nil)
            print("Your are logged in as Admin!!!")
        }
        else {
            self.performSegueWithIdentifier("loginToHomeSegue", sender: nil)
            print("Your are logged in!!!")
        }

    }
    
    // Sign the current user out of the app
    func processSignOut() {
        
        // // Sign out
        PFUser.logOut()
        
        // Display sign in / up view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") 
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func isEmailVerified() ->Bool
    {
        let currentUser = PFUser.currentUser()
        if currentUser != nil && currentUser!.username != nil && currentUser!["emailVerified"] as! Bool
        {
            return true
        }
        return false
    }
    
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
    }
    
    @IBAction func forgotPasswordButtonPressed(sender: UIButton) {
        
        self.performSegueWithIdentifier("forgotPasswordViewSegue", sender: nil)
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
