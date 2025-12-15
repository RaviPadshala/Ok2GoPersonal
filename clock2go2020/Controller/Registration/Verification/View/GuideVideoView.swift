//
//  GuideVideoView.swift
//  clock2go2020
//
//  Created by MacBookPro on 5/6/20.
//

import UIKit
import youtube_ios_player_helper

class GuideVideoView: UIViewController, YTPlayerViewDelegate {

    @IBOutlet weak var playerView: YTPlayerView!
    var shouldPushToDashboard: Bool = false

    var duration: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        playerView.delegate = self

        let playerVars = ["playsinline": 0, "autoplay": 1, "autohide": 0, "controls": 1, "showinfo": 1, "modestbranding": 1, "rel": 0]
        playerView.load(withVideoId: "RazcQNYMlSk", playerVars: playerVars)
        playerView.isOpaque = false

//        playerView.duration { ( duration, error) in
//            self.duration = duration
//        }
    }

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        self.playerView.playVideo()
    }

    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {

        guard let duration = self.duration else { return }

        if playTime >= Float(duration - 1) {
            print("STOP")
            if shouldPushToDashboard {
                pushToDashboard()
            }
        }

    }
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .clear
    }

    @IBAction func pushToNextVC(_ sender: UIButton) {
        if shouldPushToDashboard {
            pushToDashboard()
        } else {
            _ = NavigationController.shared?.popViewController(animated: true)
        }
    }

    func pushToDashboard() {
        let vc = ViewSource.dashboardScreen()
        NavigationController.shared?.pushViewController(vc, animated: true)
    }
}
