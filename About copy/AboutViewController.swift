//
//  AboutViewController.swift
//  MobIos
//
//  Created by  on 18/03/2015.
//  Copyright (c) 2015 michail fragkiskos. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    // The about website tab text
    let ABOUT_TAB_TEXT = "Description"
    // The about url (must be local)
    @IBOutlet weak var AboutView: UIWebView!
     let ABOUT_URL =  "parago_about"
    
    override func viewDidLoad() {
        super.viewDidLoad()
       loadAddressURL()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    func loadAddressURL(){
        let path = NSBundle.mainBundle().bundlePath
        //var baseUrl  =
        NSURL.fileURLWithPath("\(path)/\(self.ABOUT_URL)")
        let bundle = NSBundle.mainBundle()
        let urlpath = bundle.pathForResource("index", ofType: "html")
        let requesturl = NSURL(string: urlpath!)
        let request = NSURLRequest(URL: requesturl!)
        AboutView.loadRequest(request)
    }
       

}
