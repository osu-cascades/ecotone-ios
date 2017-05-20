//
//  ViewController.swift
//  Ecotone
//
//  Created by Nathan Struhs on 5/8/17.
//  Copyright © 2017 OSU Cascades. All rights reserved.
//

import UIKit
import WebKit
class WebAppViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myURL = URL(string: "https://osu-ecotone.herokuapp.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }}

