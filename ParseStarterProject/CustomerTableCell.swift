//
//  CustomerTableCell.swift
//  Gurkha's Stamp
//
//  Created by Babu Ram Aryal on 12/22/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class CustomerTableCell: UITableViewCell {

    @IBOutlet weak var customerEmail: UILabel!
    @IBOutlet weak var approveButton: UIButton!
    
    @IBAction func approveButtonPressed(_ sender: UIButton) {
        
        
        let email = customerEmail.text
        
        let query = PFUser.query()
        query!.whereKey("username", equalTo:email!)
        
        do {
            let customers = try query?.findObjects()
            let user = customers?[0]
            
            let getRedeemObjectQuery = PFQuery(className:"Redeem")
            getRedeemObjectQuery.whereKey("user", equalTo:user!)
            getRedeemObjectQuery.findObjectsInBackground{ (objects, error) -> Void in
                var redeem:PFObject
                
                if objects?.count == 0 {
                    redeem = PFObject(className:"Redeem")
                    redeem["user"] = user
                }
                else {
                    redeem = (objects?[0])!
                }
                
                redeem["redeem"] = "N"
                redeem["approved"] = "Y"
                
                redeem.saveInBackground()
                self.approveButton.isHidden = true
                
                //reset stampcount to "0" in Stamp table
               
            }
            
            
            
        }
        catch {
            print("Problem in getting customers.")
        }
    
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
