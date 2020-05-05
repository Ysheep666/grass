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

func decodeModel<T: Decodable>(_ data: Data) -> T {
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(data) as \(T.self):\n\(error)")
    }
}

func loadJson<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil) else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func loadImage(_ path: URL) -> CGImage {
    guard let imageSource = CGImageSourceCreateWithURL(path as NSURL, nil),
        let image = CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
        else {
            fatalError("Couldn't load image \(path.lastPathComponent).jpg from main bundle.")
        }
    return image
}

