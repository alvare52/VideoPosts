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
// MARK: - Model

// NEW (used to be a struct)
class Post: NSObject, MKAnnotation {
    
    // NEW
    var title: String?
    var timestamp: Date
    var url: URL
    
    // NEW
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: 36.1, longitude: 115.1)
    }
    
    // NEW
    var subtitle: String? {
        return "Date: "
    }
    
    // NEW
    init(title: String, timestamp: Date, url: URL) {
        self.title = title
        self.timestamp = timestamp
        self.url = url
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
    }
}

// 5
extension AudioPostsTableViewController: VideoPostDelegate {
    func didCreatePost(post: Post) {
        print("received a new post: \(post)")
        // do something...
        postController.posts.append(post)
        tableView.reloadData()
    }
}
