//
//  iiRandom.swift
//  WalkToCircle
//
//  Created by Evgenii Neumerzhitckii on 28/12/2014.
//  Copyright (c) 2014 Evgenii Neumerzhitckii. All rights reserved.
//

import Foundation

public struct iiRandom {
  public static var randomBetween0And1: Double {
    return Double(arc4random()) / Double(UINT32_MAX)
  }

  public static func random<T>(_ array: [T]) -> T? {
    if array.isEmpty { return nil }
    let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
    return array[randomIndex]
  }
}
