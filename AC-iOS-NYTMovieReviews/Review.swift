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
    let image: Image
    
    init(movieTitle: String, rating: String, summary: String, image: Image) {
        self.movieTitle = movieTitle
        self.rating = rating
        self.summary = summary
        self.image = image
    }
    
//    convenience init(<#parameters#>) {
//        <#statements#>
//    }
    
    static func reviews(from data: Data) -> [Review]? {
        var reviewsToReturn: [Review] = []
        
        do {
           let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dict = jsonData as? [String:AnyObject] else { return nil }
            
            print(dict)
        }
        catch let error as NSError{
            print("Error parsing reviews: \(error)")
        }
        
        return reviewsToReturn
    }
}
