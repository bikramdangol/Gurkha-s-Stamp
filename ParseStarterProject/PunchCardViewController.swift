//
//  PunchCardViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Bikram Dangol on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class PunchCardViewController: UIViewController {

    @IBOutlet weak var scanButton: UIButton!

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var starImage1: UIImageView!
    @IBOutlet var starImage2: UIImageView!
    @IBOutlet var starImage3: UIImageView!
    @IBOutlet var starImage4: UIImageView!
    @IBOutlet var starImage5: UIImageView!
    @IBOutlet var starImage6: UIImageView!
    @IBOutlet var starImage7: UIImageView!
    @IBOutlet var starImage8: UIImageView!
    @IBOutlet var starImage9: UIImageView!
    @IBOutlet var starImage10: UIImageView!
    @IBOutlet weak var redeemButton: UIButton!
    
    @IBAction func reddemButtonPressed(sender: UIButton) {
        self.redeemStamp()
    }
    
    func redeemStamp()
    {
        let user = PFUser.currentUser()!
        
        let getRedeemObjectQuery = PFQuery(className:"Redeem")
        getRedeemObjectQuery.whereKey("user", equalTo:user)
        getRedeemObjectQuery.findObjectsInBackgroundWithBlock{ (objects:[PFObject]?, error:NSError?) -> Void in
            var redeem:PFObject
            
            if objects?.count == 0 {
                redeem = PFObject(className:"Redeem")
                redeem["user"] = user
            }
            else {
                redeem = (objects?[0])!
            }
            
            redeem["redeem"] = "Y"
            redeem["approved"] = "N"
            
            redeem.saveInBackground()
        }
        
        
        
            
//            let alert = UIAlertController(title: "Success", message: "Stamped Successfully!!!.", preferredStyle: UIAlertControllerStyle.Alert)
//            let confirmAction = UIAlertAction(
//                title: "OK", style: UIAlertActionStyle.Default) { (action) in
//                    self.goBack()
//                    
//            }
//            alert.addAction(confirmAction)
//            self.presentViewController(alert, animated: true, completion: nil)
       
            
//            let alert = UIAlertController(title: "Error", message: "Something went wrong. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.Alert)
//            let confirmAction = UIAlertAction(
//                title: "OK", style: UIAlertActionStyle.Default) { (action) in
//                    self.goBack()
//                    
//            }
//            alert.addAction(confirmAction)
//            self.presentViewController(alert, animated: true, completion: nil)
            
            //print("Problem in saving")
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleLabel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.fillStampsForTheUser()
    }
    
    func fillStampsForTheUser()
    {
        let user = PFUser.currentUser()!
        let getStampQuery = PFQuery(className: "Stamp")
        getStampQuery.whereKey("user", equalTo: user)
        getStampQuery.findObjectsInBackgroundWithBlock { (stamps:[PFObject]?, error:NSError?) -> Void in
            
            var stampCount = 0
            if error == nil && stamps?.count == 1 {
                let stamp = stamps?[0]
                stampCount = stamp?["stampcount"] as! Int
            }
            else {
                print("Problem on getting stamp")
            }
            self.fillStars(stampCount);
            self.countLabel!.text = String(stampCount)
            
            if stampCount == 10 {
                self.scanButton.enabled = false
                self.redeemButton.hidden = false
            }
            else {
                self.scanButton.enabled = true
                self.redeemButton.hidden = true
            }
        }
        
    }
    
    @IBAction func scanQRCodePressed(sender: UIButton) {
        self.performSegueWithIdentifier("punchCardToQRReaderSegue", sender: self)
    }
    
    @IBAction func logoutBarButtonItemPressed(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func fillStars(var count:Int)
    {
        self.fillWithEmptyStars()
        let tens = count/10
        count = count%10
        switch count
        {
        case 0:
            if tens == 0
            {
                break;
            }
            starImage10.image = UIImage(named: "starFilled")
            fallthrough
        case 9: starImage9.image = UIImage(named: "starFilled")
            fallthrough
        case 8: starImage8.image = UIImage(named: "starFilled")
            fallthrough
        case 7: starImage7.image = UIImage(named: "starFilled")
            fallthrough
        case 6: starImage6.image = UIImage(named: "starFilled")
            fallthrough
        case 5: starImage5.image = UIImage(named: "starFilled")
            fallthrough
        case 4: starImage4.image = UIImage(named: "starFilled")
            fallthrough
        case 3: starImage3.image = UIImage(named: "starFilled")
            fallthrough
        case 2: starImage2.image = UIImage(named: "starFilled")
            fallthrough
        case 1: starImage1.image = UIImage(named: "starFilled")
        default: break
        }
    }
    
    func fillWithEmptyStars()
    {
        starImage1.image = UIImage(named: "starEmpty")
        starImage2.image = UIImage(named: "starEmpty")
        starImage3.image = UIImage(named: "starEmpty")
        starImage4.image = UIImage(named: "starEmpty")
        starImage5.image = UIImage(named: "starEmpty")
        starImage6.image = UIImage(named: "starEmpty")
        starImage7.image = UIImage(named: "starEmpty")
        starImage8.image = UIImage(named: "starEmpty")
        starImage9.image = UIImage(named: "starEmpty")
        starImage10.image = UIImage(named: "starEmpty")
    }
    
    func setTitleLabel()
    {
        let htmlText = "<b>Gurkhas On The Hill</b><br/><a href=\"https://maps.google.com?saddr=Current+Location&daddr=40.0071601868,-105.2759399414\" target=\"_blank\">1310 College Ave Ste 230</a><br/>Boulder CO 80302<br/><a href=\"tel:303-443-1355\">303-443-1355</a></p>"
        let attributedString = try! NSAttributedString(
            data: htmlText.dataUsingEncoding(NSUnicodeStringEncoding, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        titleLabel.attributedText = attributedString
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
