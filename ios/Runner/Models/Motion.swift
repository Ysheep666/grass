//
//  Motion.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

struct Motion: Codable, Equatable {
    static func == (lhs: Motion, rhs: Motion) -> Bool {
        return lhs.id == rhs.id
    }

    var id: Int
    var name: String
    var remarks: String
    var initials: String
    var type: String
    var media: String
    var thumb: String
    var content: [MotionContent]
}

struct MotionContent: Codable {
    var category: String
}
