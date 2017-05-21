// PhotoViewController.swift
// Created by Nathan Struhs on 5/20/17.
// Copyright © 2017 Nathan Struhs, Yong Bakos. All rights reserved.

import UIKit

class PhotoViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!

    var photo: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let photo = self.photo {
            imageView.image = photo
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
