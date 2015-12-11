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
       
        let query = PFQuery(className:"Stamp")
        query.whereKey("user", equalTo: user)
        query.findObjectsInBackgroundWithBlock { (stamps, error) -> Void in
            if error == nil
            {
                print(stamps)
                self.countLabel!.text = String(stamps!.count)
                self.fillStars(stamps!.count);
            }
            else
            {
                print(error)
            }
        }
    }
    
    @IBAction func scanQRCodePressed(sender: UIButton) {
        self.performSegueWithIdentifier("punchCardToQRReaderSegue", sender: self)
    }
    
    @IBAction func logoutBarButtonItemPressed(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func fillStars(count:Int)
    {
        self.fillWithEmptyStars()
        switch count
        {
        case 10: starImage10.image = UIImage(named: "starFilled")
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
