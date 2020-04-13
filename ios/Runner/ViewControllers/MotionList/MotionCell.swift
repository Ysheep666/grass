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
                    accessoryType = .checkmark
                    backgroundColor = UIColor(red:0.91, green:0.96, blue:1.00, alpha:1.00)
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
        selectedBackgroundView?.backgroundColor = UIColor(red:0.91, green:0.96, blue:1.00, alpha:1.00)
    }
}
