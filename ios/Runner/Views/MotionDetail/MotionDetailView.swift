//
//  MotionDetail.swift
//  Grass
//
//  Created by Yang on 2020/1/27.
//  Copyright © 2020 Yang. All rights reserved.
//

import SwiftUI

struct MotionDetailView: View {
    var motion: Motion
    var dismiss: (() -> Void)?

    var body: some View {
        VStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Text(motion.name)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                Button(action: {
                    if let dismiss = self.dismiss {
                        dismiss()
                    }
                }) {
                    Text("关闭").fontWeight(.medium)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 20)
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if motion.media.range(of: ".mp4") != nil {
                        PlayerView(url: (Helper.motionBundle?.url(forResource: motion.media, withExtension: nil))!)
                            .frame(maxWidth: .infinity, idealHeight: 300, alignment: .center)
                    } else {
                        Image(
                            loadImage((Helper.motionBundle?.url(forResource: motion.media, withExtension: nil))!),
                            scale: 2,
                            label: Text(motion.name)
                        )
                            .resizable()
                            .scaledToFit()
                    }
                    Text("说明").font(.system(size: 24))
                    Text(motion.remarks)
                        .font(.system(size: 15))
                        .foregroundColor(Color(UIColor.label))
                        .lineSpacing(4)
                }.padding(.all, 20)
            }
        }.padding(.top, 20)
    }
}

struct MotionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MotionDetailView(motion: Motion(
            id: 1,
            name: "器械辅助引体向上",
            remarks: """
1. 使用引体向上的辅助器械或是在引体向上的器械上牢固的附加一条重负荷绷带，将它绕在一侧膝盖。这个张力应该足够将小腿拉起，使用反手握法，双手握距的宽度应比肩宽稍宽一些，手臂完全伸展开。这是动作的起始位置\n
2. 保持身体挺直，收缩背阔肌使身体尽可能的向上，使你的肘部向下\n
3. 慢慢的放松使手臂完全伸展开。重复该动作至规定次数，安全的卸掉辅助装备\n
4.重复多次
""",
            initials: "Q",
            type: "背部",
            media: "0CAunsXMZ8/media.mp4",
            thumb: "ocwIUbLzM0/thumb.png",
            content: []
        ))
    }
}
