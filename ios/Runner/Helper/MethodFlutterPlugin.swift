//
//  MethodFlutterPlugin.swift
//  Runner
//
//  Created by Yang on 2020/3/25.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation

// 提供一些基础方法
@objc class MethodFlutterPlugin: NSObject, FlutterPlugin {
    static func register(with registrar: FlutterPluginRegistrar) {
        let pluginRegistrar: FlutterPluginRegistrar? = registrar
        if (pluginRegistrar != nil) {
            let channel = FlutterMethodChannel(name: "com.penta.Grass/native_method", binaryMessenger: registrar.messenger())
            let instance = MethodFlutterPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method as String
        switch method {
        case "notificationFeedback":
            let type = call.arguments as? Int
            notificationFeedback(UINotificationFeedbackGenerator.FeedbackType(rawValue: type ?? 0)!)
            result(nil)
            break
        case "getMotionsByIds":
            result(getMotionsByIds(call.arguments as! [Int]))
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    private func getMotionsByIds(_ arguments: [Int]) -> String {
        let motions = Helper.motions.filter({ arguments.contains($0.id) })
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(motions)
            return String(data: data, encoding: .utf8) ?? ""
        } catch {
            fatalError("Couldn't stringify \(motions) :\n\(error)")
        }
    }
}
