//
//  ContactTableViewController.swift
//  MobIos
//
//  Created by  on 13/03/2015.
//  Copyright (c) 2015 michail fragkiskos. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

class ContactTableViewController: UITableViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate{
    @IBOutlet weak var nameTxT: UITextField!
    @IBOutlet weak var emailTxT: UITextField!
    @IBOutlet weak var SubjectTxT: UITextField!
    @IBOutlet weak var messageTxT: UITextView!
    @IBOutlet weak var sendLabel: UILabel!
    
    
 var mail: MFMailComposeViewController!
    override func viewDidLoad() {
         self.title="Contact Us"
         super.viewDidLoad()
         self.nameTxT.text=""
         self.emailTxT.text=""
         self.SubjectTxT.text=""
         self.messageTxT.text=""
         self.nameTxT.delegate = self;
         self.emailTxT.delegate = self;
         self.SubjectTxT.delegate = self;
         self.messageTxT.delegate = self;
        self.tableView.rowHeight = setingsUrl.getRowHeight()
        self.tableView.separatorStyle.rawValue

        sendLabel.layer.borderWidth = 1
        sendLabel.layer.cornerRadius = 5
        sendLabel.layer.masksToBounds = true
        sendLabel.layer.borderColor = UIColor.grayColor().CGColor
        sendLabel.layer.backgroundColor =   UIColor.greenColor().CGColor //AppDelegate.colorWithHexString("#BFDFC1") // as! CGColor
         self.view.endEditing(true)
          self.clearsSelectionOnViewWillAppear = true
    }

    func SendForm() {
        if(MFMailComposeViewController.canSendMail()){
            mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setSubject(self.SubjectTxT.text!)
            mail.setToRecipients(["support@parago.co.uk"])
            mail.setBccRecipients(["mike@fragkiskos.org"])
            mail.setMessageBody(self.messageTxT.text, isHTML: false)
            
            presentViewController(mail, animated: true, completion: nil)
        }else{
            ErrorAlert()
             
        }
        
    }
    func mailComposeController(controller: MFMailComposeViewController,
        didFinishWithResult result: MFMailComposeResult,
        error: NSError?){
            
            switch(result.rawValue){
            case MFMailComposeResultSent.rawValue:
                print("Email sent")
                
            default:
                print(error)
            }
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
    }
    
    
    func  ErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**/
    // Hide keyboard
 func touchesBegan(touches: Set<NSObject>,  event: UIEvent) {
    self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    /*
    *
    */
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 0 {
            return 60.0
        } else{
            return 10.0
        }
    }
    
    override  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let size = CGRect()
        let label : UILabel = UILabel(frame: CGRectMake(size.midX,size.midY ,size.width, size.height))
        if section == 0 {
         //   let txt = UILabel()
            let imageView = UIImageView(frame: CGRectMake(10, 15, 35, 35))
            imageView.backgroundColor = UIColor.clearColor()
            imageView.clipsToBounds = true
            imageView.image =  UIImage(named: "072.png")
            label.addSubview(imageView)
            label.textColor = UIColor.grayColor()
            label.font = UIFont(name: mainVars.font, size: mainVars.Headfontsize)
            label.text = "           Contact Us"
            return label
        }
        else{
            label.text = ""
            return label
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  indexPath.row == 4  {
            self.SendForm() 
         
        }
    }
    
}
