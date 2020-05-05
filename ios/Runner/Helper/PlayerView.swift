//
//  Player.swift
//  Grass
//
//  Created by Yang on 2020/1/28.
//  Copyright © 2020 Yang. All rights reserved.
//

import AVKit
import UIKit
import SwiftUI

private class _PlayerView: UIView {
    var player: AVQueuePlayer?
    var playerLooper: AVPlayerLooper?
    var playerLayer: AVPlayerLayer?

    init(url: URL) {
        super.init(frame: .zero)
        let playerItem = AVPlayerItem(url: url)
        player = AVQueuePlayer(items: [playerItem])
        playerLooper = AVPlayerLooper(player: player!, templateItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        playerLayer?.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer!)
        player?.play()
    }
}

struct PlayerView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> UIView {
        return _PlayerView(url: url)
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PlayerView(url: (Helper.motionBundle?.url(forResource: "0CAunsXMZ8/media.mp4", withExtension: nil))!)
                .frame(maxWidth: .infinity, maxHeight: 300, alignment: .center)
        }
    }
}
