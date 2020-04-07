//
//  WidgetFlutterPlugin.swift
//  Runner
//
//  Created by Yang on 2020/4/7.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import Foundation
import Toast_Swift

// 原生 UI 调用
@objc class WidgetFlutterPlugin: NSObject, FlutterPlugin {
    let toastPositionEnumList = [
        ToastPosition.top,
        ToastPosition.center,
        ToastPosition.bottom
    ]

    static func register(with registrar: FlutterPluginRegistrar) {
        let pluginRegistrar: FlutterPluginRegistrar? = registrar
        if (pluginRegistrar != nil) {
            let channel = FlutterMethodChannel(name: "com.penta.Grass/native_widget", binaryMessenger: registrar.messenger())
            let instance = WidgetFlutterPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method as String
        switch method {
        case "toast":
            makeToast(call.arguments as! [String : Any])
            result(nil)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    private func makeToast(_ arguments: [String: Any]) {
        if let topController = getTopViewController() {
            topController.view.makeToast(
                arguments["message"] as? String,
                duration: arguments["duration"] as? Double ?? 0,
                position: toastPositionEnumList[arguments["position"] as? Int ?? 0]
            );
        }
    }

    private func getTopViewController() -> UIViewController? {
        if var topController = UIApplication.shared.windows[0].rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
}
