//
//  Review.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class Review {
    let movieTitle: String
    let rating: String
    let summary: String
    let image: ReviewImage?
    let fullArticleURL: URL
    
    init(movieTitle: String, rating: String, summary: String, fullArticleURL: URL, image: ReviewImage?) {
        self.movieTitle = movieTitle
        self.rating = rating
        self.summary = summary
        self.fullArticleURL = fullArticleURL
        self.image = image
    }
    
    convenience init?(from dict: [String:AnyObject]) throws {
        if let title = dict["display_title"] as? String,
            let rating = dict["mpaa_rating"] as? String,
            let summary = dict["summary_short"] as? String,
            let fullArticleInfo = dict["link"] as? [String:AnyObject],
            let articleURLString = fullArticleInfo["url"] as? String,
            let articleURL = URL(string: articleURLString) {
            
            
            
            if let multimediaInfo = dict["multimedia"] as? [String:AnyObject]
                 {
                
                
                let image = ReviewImage(from: multimediaInfo)
                self.init(movieTitle: title, rating: rating, summary: summary, fullArticleURL: articleURL, image: image ?? nil)
            }
            
            
            
            
            else {
                self.init(movieTitle: title, rating: rating, summary: summary, fullArticleURL: articleURL, image: nil)
            }
        } else {
            return nil
        }
    }

    static func reviews(from data: Data) -> [Review]? {
        var reviewsToReturn: [Review] = []
        
        do {
           let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [String:AnyObject],
            let results = response["results"] as? [[String:AnyObject]] else { return nil }
            
            for result in results {
                if let review = try Review(from: result) {
                    reviewsToReturn.append(review)
                }
            }
        }
        catch let error as NSError{
            print("Error parsing reviews: \(error)")
        }
        
        return reviewsToReturn
    }
}
