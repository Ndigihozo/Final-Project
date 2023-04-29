//
//  TipsViewController.swift
//  Final Project
//
//  Created by d.igihozo on 4/29/23.
//

import UIKit
import WebKit

class TipsViewController: UIViewController {

    // Connecting the Outlet for the web view
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //making sure the webView outlet is not nil before trying to load a request
        if let webView = webView, let myURL = URL(string: "https://www.cnbc.com/currencies/") {
            // Creating a URL request and load it in the webView
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        } else {
            print("Invalid URL or webView is nil")
        }
    }
    
    // Action method for the button to open the website in Safari
    @IBAction func openSite(_ sender: Any) {
        
        // Checking if the URL is valid and open it in Safari
        if let url = URL(string: "https://www.cnbc.com/currencies/"){
            UIApplication.shared.open(url, options:[:])
        }
    }
    
    // Handling any memory warnings
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        }
    
}
