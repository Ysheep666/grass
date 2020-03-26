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
        let method = FlutterMethodChannel(
            name: "com.penta.Grass/native_method",
            binaryMessenger: registrar.messenger()
        )

        method.setMethodCallHandler({ (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            let method = call.method as String
            switch method {
            default:
                result(FlutterMethodNotImplemented)
                break
            }
        })
    }
}
