//
//  NowPlayingViewController.swift
//  Flix
//
//  Created by Joey Dafforn on 1/9/18.
//  Copyright © 2018 Joey Dafforn. All rights reserved.
//

import UIKit
import AlamofireImage
import Foundation

class NowPlayingViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var popularityFilter: UIButton!
    @IBOutlet weak var ratingFilter: UIButton!
    @IBOutlet weak var titleFilter: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var filteredMovies: [[String: Any]]!
    var movies: [[String: Any]] = []
    var j = 0
    var k = 0
    var l = 0
    var i = 1 // Used to ensure the 'Try again' text is only added to the alert once
    var refreshControl: UIRefreshControl!
    let alertController = UIAlertController(title: "Cannot get movies", message: "The internet connection appears to be offline", preferredStyle: .alert)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(NowPlayingViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        tableView.dataSource = self
        searchBar.delegate = self
        filteredMovies = movies
        fetchMovies()
    }
    
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchMovies()
    }
    
    @IBAction func filterByPopularity(_ sender: Any) {
        if k == 1 {
            filteredMovies = filteredMovies.sorted {
                ($0["popularity"] as! Double) > ($1["popularity"] as! Double)
            }
            tableView.reloadData()
            k = 0
        }
        else {
            filteredMovies = filteredMovies.sorted { ($0["popularity"] as! Double) < ($1["popularity"] as! Double) }
            tableView.reloadData()
            k = 1
        }
    }
    @IBAction func filterByRating(_ sender: Any) {
        if l == 1 {
            filteredMovies = filteredMovies.sorted { ($0["vote_average"] as! Double) > ($1["vote_average"] as! Double) }
            tableView.reloadData()
            l = 0
        }
        else {
            filteredMovies = filteredMovies.sorted { ($0["vote_average"] as! Double) < ($1["vote_average"] as! Double) }
            tableView.reloadData()
            l = 1
        }
    }
    
    @IBAction func filterByTitle(_ sender: Any) {
        if j == 1 {
            filteredMovies = filteredMovies.sorted { ($0["title"] as! String) > ($1["title"] as! String) }
            tableView.reloadData()
            j = 0
        }
        else {
            filteredMovies = filteredMovies.sorted { ($0["title"] as! String) < ($1["title"] as! String) }
            tableView.reloadData()
            j = 1
        }
    }
    func fetchMovies() {
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=ab481370ef24f79f957c363148cc19e3")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            //This will run when the network request returns
            if let error = error {
                // Create action to let user try again
                let tryAgainAction = UIAlertAction(title: "Try again", style: .default) { (action) in
                    self.fetchMovies()
                }
                if self.i == 1 {
                    // add the try again action to the alert controller
                    self.alertController.addAction(tryAgainAction)
                    self.i = self.i + 1
                }
                self.present(self.alertController, animated: true) {
                    // optional code for what happens after the alert controller has finished presenting
                }
            }
            else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //Force unwraps the json, otherwise crashes
                let movies = dataDictionary["results"] as! [[String: Any]]
                self.movies = movies
                self.filteredMovies = movies
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        cell.ratingLabel.settings.fillMode = .precise
        let movie = filteredMovies[indexPath.row]
        let title = movie["title"] as! String
        var rating = movie["vote_average"] as! Double
        rating = rating / 2.0
        let overview = movie["overview"] as! String
        let popularity = Int(round(movie["popularity"] as! Double))
        cell.heartImage.image = #imageLiteral(resourceName: "Heart")
        cell.popularityLabel.text = String(popularity)
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        cell.ratingLabel.rating = rating
        let posterPathString = movie["poster_path"] as! String
        let baseURLString = "https://image.tmdb.org/t/p/w500"
        let posterURL = URL(string: baseURLString + posterPathString)!
        cell.posterImageView.af_setImage(withURL: posterURL)
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.darkText.withAlphaComponent(0.8)
        cell.titleLabel?.highlightedTextColor = UIColor.white
        cell.overviewLabel?.highlightedTextColor = UIColor.white
        cell.popularityLabel?.highlightedTextColor = UIColor.white
        cell.selectedBackgroundView = backgroundView
        return cell
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)  {
        searchBar.resignFirstResponder()
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        filteredMovies = searchText.isEmpty ? movies : movies.filter { (item: [String: Any]) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return (item["title"] as! String).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        tableView.reloadData()
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
