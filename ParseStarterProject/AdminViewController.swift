//
//  AdminViewController.swift
//  Gurkha's Stamp
//
//  Created by Babu Ram Aryal on 12/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class AdminViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var customerTableView: UITableView!
    
    var customerList = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customerTableView.delegate = self
        customerTableView.dataSource = self
        self.getCustomers()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCustomers() {
        let query = PFUser.query()
        query!.whereKey("role", equalTo:"customer")
        do {
            let customers = try query?.findObjects()
            customerList = customers!
        }
        catch {
            print("Problem in getting customers.")
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customerCell", for: indexPath) as! CustomerTableCell
        
        let row = (indexPath as NSIndexPath).row
        if let user = customerList[row] as? PFUser
        {
            let isRedeemReady = user["redeem"] as! Bool == true
            cell.customerEmail.text = user["username"] as? String
            cell.approveButton.isHidden = !isRedeemReady
        }
        
        
        
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let row = (indexPath as NSIndexPath).row
        print(customerList[row])
    }
    
    
    
    
    
    
    
    
    
    @IBAction func logoutButtonPressed(_ sender: UIButton) {
        self.processSignOut()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
