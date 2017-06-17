//
//  Image.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

struct Image {
    let url: URL
    
    init?(from dictionary: [String:AnyObject]) {
        guard let resource = dictionary["resource"] as? [String:AnyObject] else { return nil }
        
        if let url = resource["src"] as? String,
            let validURL = URL(string: url) {
            self.url = validURL
        }
        else {
            return nil
        }
    }
}
