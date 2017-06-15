//
//  Image.swift
//  AC-iOS-UICollectionView
//
//  Created by Erica Y Stevens on 6/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

struct Image {
    let url: URL
    
    init?(from dictionary: [String:AnyObject]) {
        if let url = dictionary["#text"] as? String,
            let validURL = URL(string: url) {
            self.url = validURL
        }
        else {
            return nil
        }
    }
}
