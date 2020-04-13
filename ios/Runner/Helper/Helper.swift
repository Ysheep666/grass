//
//  Global.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class Helper {
    static let motions: [Motion] = loadJson("motions.json")
    static let motionBundle = Bundle(url: Bundle.main.url(forResource: "motions", withExtension: "bundle")!)
}
