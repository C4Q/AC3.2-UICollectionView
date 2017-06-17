//
//  APIRequestManager.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(with endpoint: String, callback: @escaping (Data?) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        
        getData(with: url, callback: callback)
    }
    
    func getData(with endpoint: URL, callback: @escaping (Data?) -> Void) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: endpoint) { (data, response, error) in
            if error != nil {
                print("Error during session: \(String(describing: error))")
            }
            guard let validData = data else {
                callback(nil)
                return
            }
            callback(validData)
        }.resume()
    }
}
