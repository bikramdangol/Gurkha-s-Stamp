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

@available(iOS 8.0, *)
class QRReaderViewController: UIViewController, QRCodeReaderViewControllerDelegate  {
    lazy var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode])

    var barCodeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.getBarCodeString()
        self.readQRCode()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBarCodeString() {
        
        let query = PFQuery(className:"Barcode")
        query.getFirstObjectInBackgroundWithBlock {
            (pfObject: PFObject?, error: NSError?) -> Void in
            if error == nil || pfObject != nil {
                self.barCodeString = pfObject?["barcode"] as! String
            }
            else {
                 print("Problem in getting Barcode")
            }
        }
    }
   
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
    
    func saveStamp()
    {
        let user = PFUser.currentUser()!
        let getStampQuery = PFQuery(className: "Stamp")
        getStampQuery.whereKey("user", equalTo: user)
        getStampQuery.findObjectsInBackgroundWithBlock { (stamps:[PFObject]?, error:NSError?) -> Void in
            
            var stampCount = 0
            var stamp:PFObject
            if stamps?.count == 1 {
                stamp = (stamps?[0])!
                stampCount = stamp["stampcount"] as! Int
                
            }
            else {
                stamp = PFObject(className: "Stamp")
                stamp["user"] = user

            }
            
            stamp["stampcount"] = stampCount + 1
            stamp.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    let alert = UIAlertController(title: "Success", message: "Stamped Successfully!!!.", preferredStyle: UIAlertControllerStyle.Alert)
                    let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.Default) { (action) in
                            self.goBack()
                            
                    }
                    alert.addAction(confirmAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.Alert)
                    let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.Default) { (action) in
                            self.goBack()
                            
                    }
                    alert.addAction(confirmAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                    print("Problem in saving stamp")
                }
            }
        }
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        self.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
            if result == self.barCodeString
            {
                self.saveStamp()
            }
            else
            {
                self.showErrorMessage()
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
