//
//  CameraViewController.swift
//  VideoPosts
//
//  Created by Jorge Alvarez on 3/11/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

import UIKit
import AVFoundation

// 1
protocol VideoPostDelegate {
    func didCreatePost(title: String)
}

class CameraViewController: UIViewController {
    
    // 2
    var videoPostDelegate: VideoPostDelegate!

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var cameraView: CameraPreviewView!
    
    @IBAction func recordTapped(_ sender: UIButton) {
        print("recordTapped")
        // completion should display alert that asks for post title?
        present(alertController, animated: true)
        
        //dismiss(animated: true, completion: nil)
    }
    
    fileprivate lazy var alertController: UIAlertController = {
        let ac = UIAlertController(title: "Add Video Post Title", message: "Enter a title for this video post", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            guard let postTitle = self.tf?.text else { return }
            print(postTitle)
            //print(self.tf?.text ?? "")
            // 3
            self.videoPostDelegate.didCreatePost(title: postTitle)
            //self.saveCalorieIntake()
            self.tf?.text = ""
            self.dismiss(animated: true, completion: nil)
            // ring bell
            //NotificationCenter.default.post(name: .updateViews, object: self)
        }))
        
        ac.addTextField { textField in
            self.tf = textField
        }
        return ac
    }()
    
    fileprivate var tf: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Resize camera preview to fill the entire screen
        cameraView.videoPlayerView.videoGravity = .resizeAspectFill
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
