//
//  MotionCell.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit
import SwiftUI

class MotionCell: UITableViewCell {
    var currentController: UIViewController?
    var motion: Motion? {
        didSet {
            if let motion = motion {
                thumbView.image = UIImage(
                    contentsOfFile: (Helper.motionBundle?.path(forResource: motion.thumb, ofType: nil) ?? "")
                )
                nameLabel.text = motion.name
                typeLabel.text = motion.type
            }
        }
    }

    var isISelected: Bool? {
        didSet {
            if let selected = isISelected {
                if selected {
                    accessoryButton.isEnabled = false
                    accessoryButton.setTitle("", for: .disabled)
                    accessoryButton.setTitleColor(.link, for: .disabled)
                    accessoryButton.setImage(UIImage(systemName: "checkmark"), for: .disabled)
                    backgroundColor = UIColor(red:0.91, green:0.96, blue:1.00, alpha:1.00)
                } else {
                    accessoryButton.isEnabled = true
                    accessoryButton.setTitle("?", for: .normal)
                    accessoryButton.setTitleColor(.link, for: .normal)
                    accessoryButton.setTitleColor(UIColor.link.withAlphaComponent(0.6), for: .highlighted)
                    accessoryButton.setImage(nil, for: .normal)
                    accessoryButton.backgroundColor = UIColor(red:0.91, green:0.96, blue:1.00, alpha:1.00)
                    accessoryButton.layer.cornerRadius = 8
                    backgroundColor = nil
                }
            }
        }
    }

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var accessoryButton: UIButton!

    @IBAction func onTapAccessoryButton(_ sender: Any) {
        if let motion = self.motion {
            let controller = UIHostingController(rootView: MotionDetailView(motion: motion))
            DispatchQueue.global().async {
                controller.rootView.dismiss  = {
                    controller.dismiss(animated: true)
                }
            }
            currentController?.present(controller, animated: true)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(red:0.91, green:0.96, blue:1.00, alpha:1.00)
    }
}
