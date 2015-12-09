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
    
    var signupMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        self.moveToHomeScreenIfAlreadyLoggedIn()
       
    }
    
    func moveToHomeScreenIfAlreadyLoggedIn()
    {
        if self.isEmailVerified()
        {
            self.performSegueWithIdentifier("loginToHomeSegue", sender: nil)
        }
    }
    
    @available(iOS 8.0, *)
    @IBAction func loginButtonPressed(sender: UIButton) {
        if usernameTextField.text != nil && isValidEmail(usernameTextField.text!) &&
            passwordTextField.text != nil
        {
            if signupMode
            {
                self.signup()
            }
            else
            {
                
                self.signin()
                
            }
            
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
    @IBAction func signupButtonPressed(sender: UIButton) {
        if signupMode
        {
            signupMode = false;
            loginButton.setTitle("Login", forState: .Normal)
            signupButton.setTitle("Sign up", forState: .Normal)
            registerLabel.text = "Not Registered Yet?"
            
            
        }
        else
        {
            signupMode = true;
            loginButton.setTitle("Sign up", forState: .Normal)
            signupButton.setTitle("Login", forState: .Normal)
            registerLabel.text = "Already Registered?"
            
        }
        
    }
    
    func signup()
    {
        let user = PFUser()
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = usernameTextField.text
        //user.emailVerified = false;
        // other fields can be set just like with PFObject
        //user["phone"] = "415-392-0202"
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
            } else {
                // Hooray! Let them use the app now.
            }
        }
    }
    
    @available(iOS 8.0, *)
    func signin()
    {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password:passwordTextField.text!) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                if self.isEmailVerified()
                {
                    self.performSegueWithIdentifier("loginToHomeSegue", sender: nil)
                    print("Your are logged in!!!")
                }
                else
                {
                    let alert = UIAlertController(title: "Error", message: "Please verify your email.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)

                }
            } else {
                // The login failed. Check error to see why.
                print("Error Log in!!!")
            }
        }
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
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(testStr)
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
