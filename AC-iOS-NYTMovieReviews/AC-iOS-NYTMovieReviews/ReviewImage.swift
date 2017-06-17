//
//  ReviewImage.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

struct ReviewImage {
    let url: URL
    
    init?(from dictionary: [String:AnyObject]) {
        if let url = dictionary["src"] as? String,
            let validURL = URL(string: url) {
            self.url = validURL
        }
        else {
            return nil
        }
    }
}
