//
//  MotionCell.swift
//  Runner
//
//  Created by Yang on 2020/4/9.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

import UIKit

class MotionCell: UITableViewCell {
    var motion: Motion? {
        didSet {
            if let motion = motion {
                thumbView.image = UIImage(
                    named: FlutterDartProject.lookupKey(forAsset: "assets/resources/\(motion.thumb)"),
                    in: Bundle.main,
                    compatibleWith: nil
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
                    accessoryType = .checkmark
                    backgroundColor = UIColor(named: "solitude")
                } else {
                    accessoryType = .none
                    backgroundColor = nil
                }
            }
        }
    }

    @IBOutlet weak var thumbView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectedBackgroundView = UIView()
        selectedBackgroundView?.backgroundColor = UIColor(named: "solitude")
    }
}
