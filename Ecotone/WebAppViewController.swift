// WebAppViewController.swift
// Created by Nathan Struhs on 5/8/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import UIKit
import WebKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}

class WebAppViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!

    let url = URL(string: "http://ecotone.osucascades.edu")!

    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: url))
        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
