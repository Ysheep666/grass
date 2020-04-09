//
//  NavigationController.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.shadowImage = UIImage()
    }
}
