//
//  AudioPostsTableViewController.swift
//  VideoPosts
//
//  Created by Jorge Alvarez on 3/11/20.
//  Copyright © 2020 Jorge Alvarez. All rights reserved.
//

// ShowPostSegue
// AddPostSegue
import UIKit

// MARK: - Model

struct Post {
    var title: String
    var timestamp: Date
    //var url: URL
}

// MARK: - Model Controller

class PostController {
    var posts: [Post] = [Post(title: "Test Title", timestamp: Date())]
}

// MARK: - View Controller

class AudioPostsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    private var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }
    
    var postController = PostController()

    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        print("cameraButtonTapped")
    }
    // MARK: - View Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postController.posts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let post = postController.posts[indexPath.row]
        cell.textLabel?.text = post.title
        cell.detailTextLabel?.text = dateFormatter.string(from: post.timestamp)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // ADD
        if segue.identifier == "AddPostSegue" {
            print("AddPostSegue")
            if let cameraVC = segue.destination as? CameraViewController {
                // 4
                cameraVC.videoPostDelegate = self
            }
        }
        
        // SHOW
        if segue.identifier == "ShowPostSegue" {
            
        }
    }
}

// 5
extension AudioPostsTableViewController: VideoPostDelegate {
    func didCreatePost(title: String) {
        print("received a new post: \(title)")
        // do something...
        tableView.reloadData()
    }
}
