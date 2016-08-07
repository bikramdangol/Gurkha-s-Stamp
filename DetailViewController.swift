//
//  DetailViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Bikram Dangol on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var detailLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setDetailLabel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDetailLabel()
    {
        let htmlText = "<b>Locations</b><br/><b>Gurkhas On The Hill</b><p><a href=\"https://maps.google.com?saddr=Current+Location&daddr=40.0071601868,-105.2759399414\" target=\"_blank\">1310 College Ave Ste 230</a><br />Boulder CO 80302<br /><a href=\"tel:303-443-1355\">303-443-1355</a></p><b>Hours</b><p class=\"fs14\">Monday: 11:00am to 10:00pm<br />Tuesday: 11:00am to 9:00pm<br />Wednesday: 11:00am to 9:00pm<br />Thursday: 11:00am to 9:00pm<br />Friday: 11:00am to 9:00pm<br />Saturday: 11:00am to 9:00pm<br />Sunday: 11:00am to 9:00pm<br /></p>"
        let attributedString = try! NSAttributedString(
            data: htmlText.data(using: String.Encoding.unicode, allowLossyConversion: true)!,
            options: [ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
            documentAttributes: nil)
        detailLabel.attributedText = attributedString
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
