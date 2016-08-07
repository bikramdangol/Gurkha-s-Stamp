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
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        /*let object:PFObject = PFObject(className: "TestObject")
        object["bar"] = "foo"
        object.saveInBackground { (success, error) in
            if error != nil
            {
                print(error)
            }else{
                
                print("Object Saved!")
            }
        }
        
        let user = PFUser()
        user.username = "b1@mailinator.com"
        user.email = "b1@mailinator.com"
        
        user.password = "b1"
        user.signUpInBackground { (success, error) in
            if(error != nil){
                print(error)
            }else{
                print("User Saved!")
            }
        }*/
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.passwordTextField.text = ""
        self.moveToHomeScreenIfAlreadyLoggedIn()
       
    }
    
    func moveToHomeScreenIfAlreadyLoggedIn()
    {
        if self.isEmailVerified()
        {
            self.checkRoleAndLogin(PFUser.current()!)
            
        }
    }
    
    @available(iOS 8.0, *)
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if usernameTextField.text != nil && isValidEmail(usernameTextField.text!) &&
            passwordTextField.text != nil
        {
            self.signin()
            
        }
        else
        {
            
            let alert = UIAlertController(title: "Error", message: "Please enter a valid email.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler:nil))
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
    }
    
       
    @available(iOS 8.0, *)
    func signin()
    {
        self.message.text = ""
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        var username = usernameTextField.text!
        let userPassword = passwordTextField.text!
        
        // Ensure username is lowercase
        username = username.lowercased()
        
        PFUser.logInWithUsername(inBackground: username, password:userPassword) {
            (user, error) -> Void in
            self.activityIndicator.stopAnimating()
            if user != nil {
                // Do stuff after successful login.
                if self.isEmailVerified()
                {
                    self.checkRoleAndLogin(user!)
                }
                else
                {
                    let alert = UIAlertController(title: "Email address verification", message: "We have sent you an email that contains a link - you must click this link before you can continue.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)

                }
            } else {
                // The login failed. Check error to see why.
                if let error = error as? NSError{
                let errorCode = error.code as NSNumber
                switch errorCode
                {
                case 100:
                    self.message.text = ((error.userInfo as NSDictionary)["error"] as! String) + " Please try again."
                    break
                case 101:
                    let alert = UIAlertController(title: "Invalid username/password", message: "Please enter valid username and password.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break
                default:
                    self.message.text = ((error.userInfo as NSDictionary)["error"] as! String)
                    break
                    
                }
                }
            }
        }
    }
    
    func checkRoleAndLogin(_ user:PFUser) {
        if false && user["role"] as! String == "admin" {
            self.performSegue(withIdentifier: "loginToAdminView", sender: nil)
            print("Your are logged in as Admin!!!")
        }
        else {
            if #available(iOS 8.0, *) {
                //saveStamp()
            } else {
                // Fallback on earlier versions
            }
            self.performSegue(withIdentifier: "loginToHomeSegue", sender: nil)
            print("Your are logged in!!!")
        }

    }
    
    @available(iOS 8.0, *)
    func saveStamp()
    {
        let user = PFUser.current()!
        let getStampQuery = PFQuery(className: "Stamp")
        getStampQuery.whereKey("user", equalTo: user)
        getStampQuery.findObjectsInBackground { (stamps, error) -> Void in
            if(error != nil)
            {
                print("Error findObjects for stamps.")
            }
            else
            {
                var stampCount = 0
                var stamp:PFObject
                if stamps?.count == 1 {
                    stamp = (stamps?[0])!
                    stampCount = stamp["stampcount"] as! Int
                    
                }
                else {
                    stamp = PFObject(className: "Stamp")
                    stamp["user"] = user
                    
                }
                
                stamp["stampcount"] = stampCount + 1
                stamp.saveInBackground {
                    (success, error) -> Void in
                    if (success) {
                        let alert = UIAlertController(title: "Success", message: "Stamped Successfully!!!.", preferredStyle: UIAlertControllerStyle.alert)
                        let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.default) { (action) in
                            //self.goBack()
                            
                        }
                        alert.addAction(confirmAction)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController(title: "Error", message: "Something went wrong. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.alert)
                        let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.default) { (action) in
                            //self.goBack()
                            
                        }
                        alert.addAction(confirmAction)
                        self.present(alert, animated: true, completion: nil)
                        
                        print("Problem in saving stamp")
                    }
                }

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

    func isEmailVerified() ->Bool
    {
        
        let currentUser = PFUser.current()
        if currentUser != nil && currentUser!.username != nil && currentUser!["emailVerified"] as! Bool == true
        {
            return true
        }
        return false
    }
    
    func isValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        
        self.performSegue(withIdentifier: "forgotPasswordViewSegue", sender: nil)
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
