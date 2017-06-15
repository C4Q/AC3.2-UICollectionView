//
//  Album.swift
//  AC-iOS-UICollectionView
//
//  Created by Erica Y Stevens on 6/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import Foundation

enum AlbumModelParseError: Error {
    case results(json: Any)
    case image(image: Any)
}

class Album {
    let name: String
    let images: [Image]
    let artist: String
    
    init(name: String, artist: String, images: [Image]) {
        self.name = name
        self.images = images
        self.artist = artist
    }
    
    convenience init?(from dictionary: [String:AnyObject]) throws {
        if let name = dictionary["name"] as? String,
            let artist = dictionary["artist"] as? String,
            let images = dictionary["image"] as? [[String:AnyObject]] {
            var imageArr = [Image]()
            for im in images {
                if let imageObj = Image(from: im) {
                    imageArr.append(imageObj)
                }
                else {
                    throw AlbumModelParseError.image(image: im)
                }
            }
            self.init(name: name, artist: artist, images: imageArr)
        }
        else {
            return nil
        }
    }
    
    static func albums(from data: Data) -> [Album]? {
        var albumsToReturn: [Album]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String : AnyObject] = jsonData as? [String : AnyObject],
                let results = response["results"] as? [String: AnyObject],
                let matches = results["albummatches"] as? [String: AnyObject],
                let albums = matches["album"] as? [[String: AnyObject]] else {
                    throw AlbumModelParseError.results(json: jsonData)
            }
            
            for albumDict in albums {
                if let album = try Album(from: albumDict) {
                    albumsToReturn?.append(album)
                }
            }
        }
        catch let AlbumModelParseError.results(json: json)  {
            print("Error encountered with parsing 'album' or 'items' key for object: \(json)")
        }
        catch let AlbumModelParseError.image(image: im)  {
            print("Error encountered with parsing 'image': \(im)")
        }
        catch {
            print("Unknown parsing error")
        }
        return albumsToReturn
    }
}
