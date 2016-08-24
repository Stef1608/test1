//
//  SetingsTableViewController.swift
//  MobIos
//
//  Created by  on 13/03/2015.
//  Copyright (c) 2015 michail fragkiskos. All rights reserved.
//

import UIKit

class SetingsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UITextFieldDelegate {
    var versionLB:String="1.0"
    
    @IBOutlet weak var HostTxT: UITextField!
    @IBOutlet weak var ServiceTxT: UITextField!
    @IBOutlet weak var PingLable: UILabel!
    @IBOutlet weak var connectionImg: UIImageView!
    var oldHostname:AnyObject = ""
    var oldService:AnyObject = ""
    
    override func viewDidLoad() {
        self.title="Settings"
        super.viewDidLoad()
        self.tableView.rowHeight = setingsUrl.getRowHeight()
        self.tableView.separatorStyle.rawValue
        
        self.GetcurrentData()
         self.HostTxT.delegate = self
        self.ServiceTxT.delegate = self
        self.HostTxT.adjustsFontSizeToFitWidth = true
         self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: StaticFileds.log_in_msg, style: UIBarButtonItemStyle.Done, target: self, action: "goback")
    }
    
    func goback(){
        if (!self.oldHostname.isEqual(self.HostTxT.text) || !self.oldService.isEqual(self.ServiceTxT.text)) {
             showAlert()
        }else{
             self.navigationController?.popViewControllerAnimated(true)
        }
        
       
        
    }
    
    func showAlert(){
        let backAlert = UIAlertController(title: StaticFileds.parago_alert_mobile_msg, message: StaticFileds.unsaved_changes_msg, preferredStyle: .Alert)
        
        backAlert.addAction(UIAlertAction(title:StaticFileds.save_msg, style: .Default, handler: { (action: UIAlertAction!) in
              self.updateSettings()
              self.navigationController?.popViewControllerAnimated(true)
        }))
        
        backAlert.addAction(UIAlertAction(title: StaticFileds.cancel_msg, style: .Default, handler: nil))
            
        backAlert.addAction(UIAlertAction(title: StaticFileds.log_in_msg, style: .Default, handler: {
            (action: UIAlertAction!) in
            self.navigationController?.popViewControllerAnimated(true)
        }))

        
        self.presentViewController(backAlert, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    /*
    **
    **
    **
    */
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if  section == 0 {
            return 15.0
        }  else{
            return 6.0
        }
    }
    
    /*
    *
    */
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if  section == 0 {
            return setingsUrl.getRowHeight()
        }else if section == 1{
            return setingsUrl.getRowHeight()
        }else{
            return 10.0
        }
    }
    
    override  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : UILabel = UILabel(frame: CGRectMake(setingsUrl.getRowWight(), setingsUrl.getRowHeight()/4, 250, setingsUrl.getRowHeight()/2))
        if section == 0 {
         //   let txt = UILabel()
            let imageView = UIImageView(frame: CGRectMake(10, 15, 35, 35))
            imageView.backgroundColor = UIColor.clearColor()
            imageView.clipsToBounds = true
            imageView.image =  UIImage(named: "server-7.png")
            label.addSubview(imageView)
            label.textColor = UIColor.grayColor()
            label.font = UIFont(name: mainVars.font, size: mainVars.Headfontsize)
            label.text = "           Server"
            return label
        }else if section == 1 {
        //    let txt = UILabel()
            let imageView = UIImageView(frame: CGRectMake(10, 15, 35, 35))
            imageView.backgroundColor = UIColor.clearColor()
            imageView.clipsToBounds = true
            imageView.image =  UIImage(named: "mobile-7.png")
            label.addSubview(imageView)
            label.textColor = UIColor.grayColor()
            label.font = UIFont(name: mainVars.font, size: mainVars.Headfontsize)
            label.text = "           Version \(self.versionLB)"
            return label
            
        }
        else{
            label.text = ""
            return label
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 2  {
            self.ResetSetings()
        }else if indexPath.section == 1 && indexPath.row == 0  {
            self.Testconnect()
        }else if indexPath.section == 2 && indexPath.row == 0  {
            self.ClearAccount()
        }else if indexPath.section == 2 && indexPath.row == 1  {
            self.ErraseCashe()
        }
    }
    
    // Hide keyboard sos ios 9
    func touchesBegan(touches: Set<NSObject>, event: UIEvent) {
        self.updateSettings()
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.updateSettings()
        textField.resignFirstResponder()
        return false
    }
    
    /*
    *
    * Update Setings by the
    * Users insert
    *
    */
    func updateSettings(){
        if let host = HostTxT.text {
            if host !=  setingsUrl.getDefaulthttpsHostname  {
                Settings.SetData("hostname", Value: String(host))
                self.HostTxT.text=String(host)
            }else{
                Settings.SetData("hostname",Value:String(host))
            }
            self.oldHostname =  String(host)
        }
        if let service = ServiceTxT.text {
            Settings.SetData("service",Value:String(service))
            self.oldService = String(service)
        }
    }
    
    
    /*
    * Get the Current info
    * and present into the user
    *
    */
    
    func GetcurrentData(){
        //First get the nsObject by defining as an optional anyObject
        let version = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String
        
        let dbdata=setingsUrl.getSetings()
        if dbdata.count > 0 {
            self.HostTxT.text = (dbdata["hostname"] as? String)!
            self.oldHostname = (dbdata["hostname"] as? String)!
            self.oldService = (dbdata["service"] as? String)!
            self.ServiceTxT.text = (dbdata["service"] as? String)!
            self.versionLB = " v\(version)"
        }else{
            self.HostTxT.text=setingsUrl.getDefaultHostname
            self.ServiceTxT.text=setingsUrl.getDefaultService
            self.oldHostname = setingsUrl.getDefaultHostname
            self.oldService = setingsUrl.getDefaultService
            self.versionLB=" v\(version)"
        }
        
    }
    
    
    
    func ClearAccount() {
        let clearAlert = UIAlertController(title: "Clear Account", message: "This action will clear all uncommited data", preferredStyle: .ActionSheet)
        
        clearAlert.addAction(UIAlertAction(title: "Clear Account", style: .Default, handler: {
            (action: UIAlertAction!) in
             SetingsTableViewController.dropImgs()
             Settings.dropCase()
            self.startLoad()
            setingsUrl.Startdelay(seconds: 3.0, completion: {
                self.stopload()
                self.ResetAlert("Your account has been cleared.")
            })
                  }))
        
        clearAlert.addAction(UIAlertAction(title: StaticFileds.cancel_msg, style: .Default, handler: { (action: UIAlertAction!) in
        }))
        if (clearAlert.popoverPresentationController != nil) {
            let popover = clearAlert.popoverPresentationController
            popover!.delegate = self
            popover!.sourceView = self.view
            popover!.permittedArrowDirections = UIPopoverArrowDirection()
            popover!.sourceRect =  CGRectMake(view.bounds.midX, view.bounds.maxY ,0,0)
        }
        self.presentViewController(clearAlert, animated: true, completion: nil)
        
        
    }
    /*
    * Test the connection
    * With the Server
    */
    
    func Testconnect() {
        self.PingLable.text = StaticFileds.please_wait_msg
        let post = postRequest()
            post.appendXmlValue(1)
        let  data = post.sendPost("parago.mobile.test.ping")
        if(data != ""){
            let pingdata = ParagoXml.parse(data as String)
            let ping = pingdata["methodResponse"]["params"]["param"]["value"]
            dispatch_after(setingsUrl.Dellay(),  dispatch_get_main_queue(), {
                if let auth1 = ping["string"].element?.text {
                    if auth1 != "" || !auth1.isEmpty {
                        self.connectionImg.image = UIImage(named: "041.png")
                        self.PingLable.text = "Connection Success"
                    }else{
                        self.connectionImg.image = UIImage(named: "038.png")
                        self.PingLable.text = "Connection Error"
                    }
                }
            })
        }else{
            self.connectionImg.image = UIImage(named: "038.png")
            self.PingLable.adjustsFontSizeToFitWidth = true
            self.PingLable.text = "\(mainVars.connectionErrorMsg[mainVars.connectionErrorCode]!)"
            
        }
         dispatch_after(setingsUrl.Dellay(3.0), dispatch_get_main_queue()) {
            self.PingLable.text = "Test Connection"
        }
               
    }
    
    /*
    * Reset the settings
    * to the default
    */
    
    func ResetSetings() {
        
        let refreshAlert = UIAlertController(title: "Reset Settings", message: "This action will reset the host and service settings", preferredStyle: .ActionSheet)
        
        refreshAlert.addAction(UIAlertAction(title: "Default Settings", style: .Default, handler: { (action: UIAlertAction!) in
            self.HostTxT.text=setingsUrl.getDefaultHostname
            self.ServiceTxT.text=setingsUrl.getDefaultService
            Settings.SetData("hostname",Value:"\(setingsUrl.getDefaultHostname)")
            Settings.SetData("service",Value:"\(setingsUrl.getDefaultService)")
        }))
        refreshAlert.addAction(UIAlertAction(title: "Alternate Settings", style: .Default, handler: { (action: UIAlertAction!) in
            self.HostTxT.text=setingsUrl.getDefaulthttpsHostname
            self.ServiceTxT.text=setingsUrl.getDefaultService
            Settings.SetData("hostname",Value:"\(setingsUrl.getDefaulthttpsHostname)")
            Settings.SetData("service",Value:"\(setingsUrl.getDefaultService)")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: StaticFileds.cancel_msg, style: .Default, handler: nil))
        if (refreshAlert.popoverPresentationController != nil) {
            let popover = refreshAlert.popoverPresentationController
            popover!.delegate = self
            popover!.sourceView = self.view
            popover!.permittedArrowDirections = UIPopoverArrowDirection()
            popover!.sourceRect =  CGRectMake(view.bounds.midX, view.bounds.maxY ,0,0)
            
        }
        self.presentViewController(refreshAlert, animated: true, completion: nil)
    }
    /*
    * Cashe Errase
    */
    
    func ErraseCashe() {
        let refreshAlert = UIAlertController(title: "Erase  Cache", message: "This action will delete all the cache data", preferredStyle: .ActionSheet)
        refreshAlert.addAction(UIAlertAction(title: "Erase Cache", style: .Default, handler: { (action: UIAlertAction!) in
            self.startLoad()
            SetingsTableViewController.dropImgs(1)
            _ = account(drop : true)
            _ = assets(drop : true)
            _ = audits(drop : true)
            _ = categories(drop : true)
            _ = images(drop : true)
            _ = kbp(drop : true)
            _ = metatags(drop : true)
            _ = selectionGroup(drop : true)
            _ = setings(drop : true)
            self.stopload()
            self.startLoad()
            setingsUrl.Startdelay(seconds: 2.0, completion: {
            self.stopload()
            Settings.SetData("hostname", Value: String(self.HostTxT.text!))
            Settings.SetData("service", Value: String(self.ServiceTxT!.text!))
            self.ResetAlert("Your cache has been erased.")
            })
        }))
        
        refreshAlert.addAction(UIAlertAction(title: StaticFileds.cancel_msg, style: .Default, handler: nil))
        
        if (refreshAlert.popoverPresentationController != nil) {
            let popover = refreshAlert.popoverPresentationController
            popover!.delegate = self
            popover!.sourceView = self.view
            popover!.permittedArrowDirections = UIPopoverArrowDirection()
            popover!.sourceRect =  CGRectMake(view.bounds.midX, view.bounds.maxY ,0,0)
            
        }
        
        self.presentViewController(refreshAlert, animated: true, completion: nil)
        
    }
    
    
    
   class func dropImgs(all:Int = 0){
 var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
    let documentsDirectory: AnyObject = paths[0]
        
    let filePath = documentsDirectory.stringByAppendingPathComponent("costumImg")
    let filePathAsset = documentsDirectory.stringByAppendingPathComponent("costumAssetImg")
    let fileIcons = setingsUrl.FilePath
        if(all == 1){
                   SetingsTableViewController.deleteSubDirectory(filePath)
                   SetingsTableViewController.deleteSubDirectory(filePathAsset)
                   SetingsTableViewController.deleteSubDirectory(fileIcons)
          
        }else{
            SetingsTableViewController.deleteSubDirectory(filePath)
            SetingsTableViewController.deleteSubDirectory(filePathAsset)
         }
        
}
    
    
   class func deleteSubDirectory(directory:String) -> Bool
    {
          let subDir = SetingsTableViewController.stripSlashIfNeeded(directory)
          let deletePath =  subDir + "/"
        var dir:ObjCBool = true
        let dirExists = NSFileManager.defaultManager().fileExistsAtPath(deletePath, isDirectory:&dir)
        if dir.boolValue == false {
            return false
        }
        if dirExists == false {
            return false
        }
        do{
          try NSFileManager.defaultManager().removeItemAtPath(deletePath)
        return true
        } catch {
        return false
        }
        
    }
    
    
    class private func stripSlashIfNeeded(stringWithPossibleSlash:String) -> String {
        var stringWithoutSlash:String = stringWithPossibleSlash
         if stringWithPossibleSlash.hasPrefix("/") {
            stringWithoutSlash = String(stringWithoutSlash.characters.dropFirst())
                //stringWithPossibleSlash.substringFromIndex(stringWithoutSlash.advanced(startIndex),1)
        }
         return stringWithoutSlash
    }

    
    func startLoad(){
          alerts.shared.showProgress(self.view)
    }
    
    func stopload(){
        alerts.shared.hideProgressView()
    }
    
    /*
    * Reset the settings
    * to the default
    */
    
    func ResetAlert(msg:String) {
        
        let resetAlert = UIAlertController(title: StaticFileds.parago_mobile_msg, message: "\(msg)", preferredStyle: .Alert)
        
        resetAlert.addAction(UIAlertAction(title: StaticFileds.ok_msg, style: .Default, handler: { (action: UIAlertAction!) in
                     }))
        
                self.presentViewController(resetAlert, animated: true, completion: nil)
    }

    
}
