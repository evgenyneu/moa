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
    if #available(OSX 10.10, *) {
        super.viewDidLoad()
    } else {
        // Fallback on earlier versions
    }
    
    // Log to console
    
    Moa.logger = MoaConsoleLogger
  }

  @IBAction func didTapLoadButton(_ sender: AnyObject) {
    imageView.moa.url = randomImageUrl.url
  }
}

