//
//  Critic.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation


class Critic {
    let name: String
    let image: Image?
    
    init(name: String, image: Image?) {
        self.name = name
        self.image = image
    }
    
    convenience init?(from dict: [String:AnyObject]) throws {
        if let criticName = dict["display_name"] as? String {
            if let multimediaInfo = dict["multimedia"] as? [String:AnyObject] {
                self.init(name: criticName, image: Image(from: multimediaInfo) ?? nil)
            } else {
                self.init(name: criticName, image: nil)
            }
        } else {
            return nil
        }
    }
    
    static func critics(from data: Data) -> [Critic]? {
        var criticsToReturn: [Critic]? = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String:AnyObject] = jsonData as? [String: AnyObject],
            let results = response["results"] as? [[String:Any]] else {
                return nil
            }
            
            for result in results {
                if let critic = try Critic(from: result as [String : AnyObject]) {
                    criticsToReturn?.append(critic)
                }
            }
        }
        catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        return criticsToReturn
    }
}
