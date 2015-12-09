//
//  PunchCardViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Bikram Dangol on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class PunchCardViewController: UIViewController {


    @IBOutlet var titleLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setTitleLabel()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
