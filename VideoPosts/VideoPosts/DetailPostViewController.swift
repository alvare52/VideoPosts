//
//  DetailPostViewController.swift
//  VideoPosts
//
//  Created by Jorge Alvarez on 3/11/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import AVFoundation

class DetailPostViewController: UIViewController {
    
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var screenView: UIView!
    
    var player: AVPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        view.addGestureRecognizer(tapGesture)
        guard let post = post else {return}
        playMovie(url: post.url)
    }
    
    func updateViews() {
        guard isViewLoaded else { return }
        print(post ?? Post(title: "empty post", timestamp: Date(), url: URL(fileURLWithPath: "shit")))
        title = post?.title ?? "Post"
    }
    
    @objc func handleTapGesture(_ tapGesture: UITapGestureRecognizer) {
        print("tap")
        guard let post = post else { return }
        switch(tapGesture.state) {
        case .ended:
        replayMovie()
        default:
            print("Handled other states: \(tapGesture.state)")
        }
    }
    
    func playMovie(url: URL) {
        player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        var topRect = view.bounds
        topRect.size.height = topRect.height // / 4
        topRect.size.width = topRect.width  // / 4 ///
        topRect.origin.y = view.layoutMargins.top
        //playerLayer.frame = topRect
        playerLayer.frame = screenView.frame
        view.layer.addSublayer(playerLayer) // this is stacking layers (BAD)
        player.play()
    }
    
    func replayMovie() {
        guard let player = player else { return }
        
        // Go back to beginning
        player.seek(to: CMTime.zero)
        //CMTime(seconds: 2, preferredTimescale: 30) // 30 Frames per second (FPS)
        player.play()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
