//
//  QRReaderViewController.swift
//  Gurkha's Stamp
//
//  Created by Bikram Dangol on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import AVFoundation

class QRReaderViewController: UIViewController, QRCodeReaderViewControllerDelegate  {
    lazy var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])

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
        if QRCodeReader.supportsMetadataObjectTypes() {
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = { (result: String?) in
                print("Completion with result: \(result)")
                self.stampedMessageLabel.text = result
                if result == "Bikram is learning iOS."
                {
                    self.saveStamp()
                }
            }
            
            presentViewController(reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }

    }
    func saveStamp()
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
                if #available(iOS 8.0, *) {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                } else {
                    // Fallback on earlier versions
                }
                
                
            }
        }

    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        self.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
            if #available(iOS 8.0, *) {
                let alert = UIAlertController(title: "QRCodeReader", message: result, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                // Fallback on earlier versions
            }
            
            })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
