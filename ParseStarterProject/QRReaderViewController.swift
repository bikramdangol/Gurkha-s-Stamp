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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 8.0, *)
        {
            self.readQRCode()
        }
        else
        {
            // Fallback on earlier versions
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @available(iOS 8.0, *)
    func readQRCode()
    {
        if QRCodeReader.supportsMetadataObjectTypes()
        {
            reader.modalPresentationStyle = .FormSheet
            reader.delegate               = self
            
            reader.completionBlock = {(result: String?) in
                print("Completion with result: \(result)")
            }
            
            presentViewController(reader, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }

    }
    
    func goBack()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showErrorMessage()
    {
        if #available(iOS 8.0, *)
        {
            let alert = UIAlertController(title: "Error", message: "Invalid Code. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.Alert)
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.Destructive) { (action) in
                    self.goBack()
            }
            
            let confirmAction = UIAlertAction(
                title: "OK", style: UIAlertActionStyle.Default) { (action) in
                    self.readQRCode()
                    
            }
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.presentViewController(alert, animated: true, completion: nil)

        }
        else
        {
            // Fallback on earlier versions
        }
    }
    
    func saveStamp()
    {
        let stamp = PFObject(className:"Stamp")
        stamp["user"] = PFUser.currentUser()
        stamp.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success)
            {
                // The object has been saved.
                if #available(iOS 8.0, *)
                {
                    let alert = UIAlertController(title: "Success", message: "Stamped Successfully!!!.", preferredStyle: UIAlertControllerStyle.Alert)
                    let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.Default) { (action) in
                            self.goBack()
                            
                    }
                    alert.addAction(confirmAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    // Fallback on earlier versions
                }

            } else
            {
                // There was a problem, check error.description
                if #available(iOS 8.0, *)
                {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.Alert)
                    let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.Default) { (action) in
                            self.goBack()
                            
                    }
                    alert.addAction(confirmAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
                else
                {
                    // Fallback on earlier versions
                }
            }
        }

    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        self.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
            if #available(iOS 8.0, *)
            {
                if result == "Bikram is learning iOS."
                {
                    self.saveStamp()
                }
                else
                {
                    self.showErrorMessage()
                }
            }
            else
            {
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
