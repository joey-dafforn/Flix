//
//  DetailViewController.swift
//  Flix
//
//  Created by Joey Dafforn on 1/15/18.
//  Copyright © 2018 Joey Dafforn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var webViewPlayer: UIWebView!
    @IBOutlet weak var scrollyView: UIScrollView!
    
    var movie: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollyView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
        if let movie = movie {
            titleLabel.text = movie["title"] as? String
            releaseDateLabel.text = movie["release_date"] as? String
            overviewLabel.text = movie["overview"] as? String
            let backdropPathString = movie["backdrop_path"] as! String
            let movieID = movie["id"] as! Int
            fetchMovieVideo(ID: movieID)
            let posterPathString = movie["poster_path"] as! String
            let baseURLString = "https://image.tmdb.org/t/p/w500"
            let backdropURL = URL(string: baseURLString + backdropPathString)!
            backDropImageView.af_setImage(withURL: backdropURL)
            let posterPathURL = URL(string: baseURLString + posterPathString)!
            posterImageView.af_setImage(withURL: posterPathURL)
        }
        // Do any additional setup after loading the view.
    }

    func loadYoutube(videoID:String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        webViewPlayer.loadRequest( URLRequest(url: youtubeURL) )
    }
    
    func fetchMovieVideo(ID:Int) {
        let url = URL(string: "https://api.themoviedb.org/3/movie/" + String(ID) + "/videos?api_key=ab481370ef24f79f957c363148cc19e3")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns
            if let error = error {
                // Do nothing
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //Force unwraps the json, otherwise crashes
                let movies = dataDictionary["results"] as! [[String: Any]]
                let movie = movies[0]
                let movieKey = movie["key"] as! String
                self.loadYoutube(videoID: movieKey)
            }
        }
        task.resume()
    }
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        print("Selected cell number: \(indexPath.row)")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
