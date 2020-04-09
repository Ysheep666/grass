//
//  Motion.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

struct Motion: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var remarks: String
    var initials: String
    var type: String
    var media: String
    var thumb: String
}
