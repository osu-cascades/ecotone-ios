// WebAppViewController.swift
// Created by Nathan Struhs on 5/8/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import UIKit
import WebKit

class WebAppViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    let homeURL = "http://ecotone.osucascades.edu"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: homeURL) {
            webView.loadRequest(URLRequest(url: url))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func loadURL(_ url: String) {
        if let requestURL = URL(string: url) {
            webView.loadRequest(URLRequest(url: requestURL))
        }
    }
    
}
