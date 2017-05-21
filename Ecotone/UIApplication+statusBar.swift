//  UIApplication+statusBar.swift
//  Created by Yong Bakos on 5/21/17.
//  Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import UIKit

extension UIApplication {
    var statusBarView: UIView? {
        return value(forKey: "statusBar") as? UIView
    }
}
