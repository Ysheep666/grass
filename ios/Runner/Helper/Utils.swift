//
//  Utils.swift
//  Runner
//
//  Created by Yang on 2020/3/25.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

func impactFeedback(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
    let haptics = UIImpactFeedbackGenerator(style: feedbackStyle)
    haptics.impactOccurred()
}

func notificationFeedback(_ feedbackStyle: UINotificationFeedbackGenerator.FeedbackType) {
    let haptics = UINotificationFeedbackGenerator()
    haptics.notificationOccurred(feedbackStyle)
}

