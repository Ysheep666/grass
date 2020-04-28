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
    static func register(with registrar: FlutterPluginRegistrar) {
        let pluginRegistrar: FlutterPluginRegistrar? = registrar
        if (pluginRegistrar != nil) {
            let channel = FlutterMethodChannel(name: "com.penta.Grass/native_widget", binaryMessenger: registrar.messenger())
            let instance = WidgetFlutterPlugin()
            registrar.addMethodCallDelegate(instance, channel: channel)
        }
    }

    let toastPositionEnumList = [
        ToastPosition.top,
        ToastPosition.center,
        ToastPosition.bottom
    ]

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let method = call.method as String
        switch method {
        case "toast":
            toast(call.arguments as! [String : Any])
            result(nil)
            break
        case "alert":
            alert(call.arguments as! [String : Any], result: result)
            break
        case "motionPicker":
            motionPicker(call.arguments as! [String : Any], result: result)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }

    private func toast(_ arguments: [String: Any]) {
        if let topController = getTopViewController() {
            topController.view.makeToast(
                arguments["message"] as? String,
                duration: arguments["duration"] as? Double ?? 0,
                position: toastPositionEnumList[arguments["position"] as? Int ?? 0]
            );
        }
    }

    private func alert(_ arguments: [String: Any], result: @escaping FlutterResult) {
        if let topController = getTopViewController() {
            let controller = UIAlertController(
                title: arguments["title"] as? String,
                message: arguments["message"] as? String,
                preferredStyle: UIAlertController.Style(rawValue: arguments["preferredStyle"] as! Int) ?? .alert
            )
            let actions = arguments["actions"] as? [ [String : Any]] ?? []
            for action in actions {
                controller.addAction(UIAlertAction(
                    title: action["title"] as? String,
                    style: UIAlertAction.Style(rawValue: action["style"] as! Int) ?? .default,
                    handler: { _ in
                        result(action["value"])
                    }
                ))
            }
            topController.present(controller, animated: true)
        }
    }

    private func motionPicker(_ arguments: [String: Any], result: @escaping FlutterResult) {
        if let topController = getTopViewController() {
            let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MotionList") as! MotionListViewController
            controller.completion = { motions in
                result(motions.map { $0.id })
            }
            let navigationController = UINavigationController(rootViewController: controller)
            navigationController.navigationBar.shadowImage = UIImage()
            topController.present(navigationController, animated: true)
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

