//
//  Utils.swift
//  Runner
//
//  Created by Yang on 2020/4/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

func impactFeedback(_ feedbackStyle: UIImpactFeedbackGenerator.FeedbackStyle) {
    let haptics = UIImpactFeedbackGenerator(style: feedbackStyle)
    haptics.impactOccurred()
}

func notificationFeedback(_ feedbackStyle: UINotificationFeedbackGenerator.FeedbackType) {
    let haptics = UINotificationFeedbackGenerator()
    haptics.notificationOccurred(feedbackStyle)
}

