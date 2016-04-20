//
//  onScanningQRCodeVC.swift
//  CMPiPad
//
//  Created by Akshay's on 4/18/16.
//  Copyright © 2016 Akshay's. All rights reserved.
//

import UIKit

class onScanningQRCodeVC: UIViewController {
    
    var QRString:String!
    var pendingTransactionId: String!
    
    
    @IBOutlet weak var approveMealLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var refreshButtonOutlet: UIButton!
    @IBAction func refreshButtonAction(sender: UIButton) {
        
        
        
    }
    
    
    
    
    
    
    
    
    
    @IBOutlet weak var approveMealButtonOutlet: UIButton!
    
    
    
    override func viewDidLoad() {
        
        print(QRString)
        
        decodeQRString()
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func decodeQRString(){
        
        let userquery = PFQuery(className:"_User")
        userquery.getObjectInBackgroundWithId(QRString) {
            (user: PFObject?, error: NSError?) -> Void in
            if error == nil && user != nil {
                print(user)
                
                self.usernameLabel.text = ""+((user?.objectForKey("fname"))! as! String) + " " + ((user?.objectForKey("lname"))! as! String)
                
                self.approveMealButtonOutlet.hidden = false
                
                
            } else {
                
                self.approveMealLabel.text = "Invalid QRCode: "
                self.usernameLabel.text = self.QRString
                
                print(error!.localizedDescription)
            }
        }
        
        
        
        
    }
    
    @IBAction func approveMealAction(sender: UIButton) {
        
        
        
        
        
        
        
        
        let transaction = PFObject(className:"temptransaction")
        transaction["customerid"] = QRString
        transaction["approved"] = false
        transaction.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                
                
                let userquery = PFQuery(className:"_User")
                userquery.getObjectInBackgroundWithId(self.QRString) {
                    (user: PFObject?, error: NSError?) -> Void in
                    if error == nil && user != nil {
                        
                        let pendingTransactionId = user?.objectForKey("pendingTransactionId")as! String!
                        
//                       self.pendingTransactionId = user?.objectForKey("pendingTransactionId")as! String!
                        
                        
                        let pendingTransactionQuery = PFQuery(className: "pendingTransaction")
                        pendingTransactionQuery.getObjectInBackgroundWithId(pendingTransactionId){
                            (pendingtransaction: PFObject?, error: NSError?) -> Void in
                            if error == nil && pendingtransaction != nil{
                                pendingtransaction?.setValue(transaction.objectId, forKey: "transactionid")
                                pendingtransaction?.saveInBackground()
                            
                            }
                        
                        
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        
                        self.approveMealButtonOutlet.hidden = true
                        
                        self.refreshButtonOutlet.hidden = false
                        
                        let alertController = UIAlertController(title: "Transaction approved", message:"Waiting for confirmation", preferredStyle: UIAlertControllerStyle.Alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
                        
                        self.presentViewController(alertController, animated: true, completion: nil)
                        
                        print("Here Right Now")
                        
                        
                    }
                }
                
                
            }
        }
        //                // The object has been saved.
        //
        //                print(transaction.objectId)
        
        
        //                let userquery = PFQuery(className:"_User")
        //                userquery.getObjectInBackgroundWithId(self.QRString) {
        //                    (user: PFObject?, error: NSError?) -> Void in
        //                    if error == nil && user != nil {
        //                        print(user)
        //
        //
        //
        //
        //
        //                        user?.saveInBackgroundWithBlock({ (succeed, error) -> Void in
        //
        //
        //                            if ((error) != nil) {
        //
        //                                print(error?.localizedDescription)
        //
        //                            }
        //                            }
        //                        )
        //
        //
        //
        //                    } else {
        //
        //
        //                    }
        //                }
        
        //
        //
        //                let transactionquery = PFQuery(className: "pendingTransaction")
        //                transactionquery.
        //                
        //                
        //                
        //            } else {
        //                // There was a problem, check error.description
        //            }
        //        }
        
    }
    
}
