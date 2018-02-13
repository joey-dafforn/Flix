//
//  Movie.swift
//  Flix
//
//  Created by Joey Dafforn on 2/7/18.
//  Copyright © 2018 Joey Dafforn. All rights reserved.
//

import Foundation


class Movie {
    var title: String
    var posterUrl: URL?
    var rating: Double
    var overview: String
    var popularity: Double
    var posterPathString: String
    var backdropPathString: String
    var movieID: Int
    var releaseDate: String
    //var movies: [Movie]
    //var key: String
    
    init(dictionary: [String: Any]) {
        title = dictionary["title"] as? String ?? "No title"
        rating = dictionary["vote_average"] as! Double
        overview = dictionary["overview"] as! String
        popularity = round(dictionary["popularity"] as! Double)
        posterPathString = dictionary["poster_path"] as! String
        backdropPathString = dictionary["backdrop_path"] as! String
        movieID = dictionary["id"] as! Int
        releaseDate = dictionary["release_date"] as! String
        // Set the rest of the properties
    }
    class func movies(dictionaries: [[String: Any]]) -> [Movie] {
        var movies: [Movie] = []
        for dictionary in dictionaries {
            let movie = Movie(dictionary: dictionary)
            movies.append(movie)
        }
        
        return movies
    }
}
