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
    
    lazy var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode], startScanningAtLoad: true)

    var barCodeString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getBarCodeString()
        self.readQRCode()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getBarCodeString() {
        
        let query = PFQuery(className:"Barcode")
        query.getFirstObjectInBackground {
            (pfObject, error) -> Void in
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
            reader.modalPresentationStyle = .formSheet
            reader.delegate               = self
            
            reader.completionBlock = {(result: String?) in
                print("Completion with result: \(result)")
            }
            
            present(reader, animated: true, completion: nil)
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }

    }
    
    func goBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func showErrorMessage()
    {
            let alert = UIAlertController(title: "Error", message: "Invalid Code. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: UIAlertActionStyle.destructive) { (action) in
                    self.goBack()
            }
            
            let confirmAction = UIAlertAction(
                title: "OK", style: UIAlertActionStyle.default) { (action) in
                    self.readQRCode()
                    
            }
            
            alert.addAction(confirmAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)

       
    }
    
    func saveStamp()
    {
        let user = PFUser.current()!
        let getStampQuery = PFQuery(className: "Stamp")
        getStampQuery.whereKey("user", equalTo: user)
        getStampQuery.findObjectsInBackground { (stamps, error) -> Void in
            
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
            stamp.saveInBackground {
                (success, error) -> Void in
                if (success) {
                    let alert = UIAlertController(title: "Success", message: "Stamped Successfully!!!.", preferredStyle: UIAlertControllerStyle.alert)
                    let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.default) { (action) in
                            self.goBack()
                            
                    }
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Something went wrong. Please scan the QR Code again.", preferredStyle: UIAlertControllerStyle.alert)
                    let confirmAction = UIAlertAction(
                        title: "OK", style: UIAlertActionStyle.default) { (action) in
                            self.goBack()
                            
                    }
                    alert.addAction(confirmAction)
                    self.present(alert, animated: true, completion: nil)
                    
                    print("Problem in saving stamp")
                }
            }
        }
    }
    
    // MARK: - QRCodeReader Delegate Methods
    
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: String) {
        self.dismiss(animated: true, completion: { [unowned self] () -> Void in
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
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        self.dismiss(animated: true, completion: nil)
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
