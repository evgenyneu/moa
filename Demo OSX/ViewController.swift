//
//  ViewController.swift
//  Demo OSX
//
//  Created by Evgenii on 7/06/2015.
//  Copyright (c) 2015 Evgenii Neumerzhitckii. All rights reserved.
//

import Cocoa
import moa

class ViewController: NSViewController {
  @IBOutlet weak var imageView: NSImageView!
  
  let randomImageUrl = RandomImageUrl()

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override var representedObject: AnyObject? {
    didSet {
    // Update the view, if already loaded.
    }
  }

  @IBAction func onLoadButtonTapped(sender: AnyObject) {
    imageView.moa.url = randomImageUrl.url
  }
}

