//
//  QRReaderViewController.swift
//  Gurkha's Stamp
//
//  Created by Bikram Dangol on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class QRReaderViewController: UIViewController {

    @IBOutlet var stampedMessageLabel: UILabel!
    @IBOutlet var stampButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stampButtonPressed(sender: UIButton) {
        if #available(iOS 8.0, *) {
            self.stampIt()
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @available(iOS 8.0, *)
    func stampIt()
    {
        let stamp = PFObject(className:"Stamp")
        stamp["user"] = PFUser.currentUser()
        stamp.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                self.stampButton.enabled = false
                self.stampedMessageLabel.text = "Stamped!!!"
            } else {
                // There was a problem, check error.description
                let alert = UIAlertController(title: "Error", message: "Something went wrong. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))

            }
        }
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
