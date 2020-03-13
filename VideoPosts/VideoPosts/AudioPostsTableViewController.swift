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
import MapKit
import Foundation
// MARK: - Model

// NEW (used to be a struct)
class Post: NSObject {
    
   
    var timestamp: Date
    var url: URL
    var comment: String
    
//    // NEW
//    @objc dynamic var coordinate: CLLocationCoordinate2D {
//        return currentLocation
//    }
    
    // NEW
    init(comment: String, timestamp: Date, url: URL) {
        //self.title = title
        self.comment = comment
        self.timestamp = timestamp
        self.url = url
        
        super.init()
    }
}



// MARK: - Model Controller

class PostController {
    // NEW
    var userLocation: CLLocationCoordinate2D?
    var posts: [Post] = []
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
        performSegue(withIdentifier: "ShowMapSegue", sender: self)
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
            print("ShowPostSegue")
            if let detailVC = segue.destination as? DetailPostViewController, let indexPath = tableView.indexPathForSelectedRow {
                // 4
                detailVC.post = postController.posts[indexPath.row]
            }
        }
        
        if segue.identifier == "ShowMapSegue" {
            print("ShowMapSegue")
            if let mapVC = segue.destination as? MapViewController {
                mapVC.postController = self.postController
            }
        }
    }
}

// 5
extension AudioPostsTableViewController: VideoPostDelegate {
    func didCreatePost(post: Post) {
        print("received a new post: \(post)")
        // do something...
        postController.posts.append(post)
        print(post.coordinate)
        tableView.reloadData()
    }
}
