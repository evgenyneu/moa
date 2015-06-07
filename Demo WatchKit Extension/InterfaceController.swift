//
//  InterfaceController.swift
//  Demo WatchKit Extension
//
//  Created by Evgenii on 7/06/2015.
//  Copyright (c) 2015 Evgenii Neumerzhitckii. All rights reserved.
//

import WatchKit
import Foundation
import moa

class InterfaceController: WKInterfaceController {

  @IBOutlet weak var image: WKInterfaceImage!
  @IBOutlet weak var button: WKInterfaceButton!
  
  let randomImageUrl = RandomImageUrl()
  
  
  override func awakeWithContext(context: AnyObject?) {
    super.awakeWithContext(context)
    
    let another = WKInterfaceImage()
    another.moa.url = "hello"
    onAnoherOneTapped()
  }
  
  override func willActivate() {
    // This method is called when watch view controller is about to be visible to user
    super.willActivate()
  }
  
  override func didDeactivate() {
    // This method is called when watch view controller is no longer visible
    super.didDeactivate()
  }

  @IBAction func onAnoherOneTapped() {
    image.moa.url = randomImageUrl.url
  }
}
