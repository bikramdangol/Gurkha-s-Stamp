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
        query!.whereKey("role", equalTo:"")
        do {
            let customers = try query?.findObjects()
            customerList = customers!
        }
        catch {
            print("Problem in getting customers.")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customerList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customerCell", forIndexPath: indexPath) as! CustomerTableCell
        
        let row = indexPath.row
        let user = customerList[row]
        let isRedeemReady = user["redeem"] as! Bool
        cell.customerEmail.text = user["username"] as? String
        cell.approveButton.hidden = !isRedeemReady
        return cell
    }
    
    // MARK:  UITableViewDelegate Methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
        print(customerList[row])
    }
    
    
    
    
    
    
    
    
    
    @IBAction func logoutButtonPressed(sender: UIButton) {
        self.processSignOut()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
