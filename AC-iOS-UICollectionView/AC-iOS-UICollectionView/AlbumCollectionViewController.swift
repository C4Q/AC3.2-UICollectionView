//
//  ViewController.swift
//  AC-iOS-UICollectionView
//
//  Created by Erica Y Stevens on 6/15/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

fileprivate let reuseIdentifier = "AlbumCell"
fileprivate let itemsPerRow: CGFloat = 3
fileprivate let apiKey = "1ce6fda8a223aa4b7fa0cafe4dc3d3d0"
fileprivate let apiURLRoot = "http://ws.audioscrobbler.com/2.0/"

class AlbumCollectionViewController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var searchAlbumTextField: UITextField!
    
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    var albums: [Album] = []
    let searchTerm = "blue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "No Search Yet"
        searchAlbumTextField.delegate = self
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.albums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        if let acvc = cell as? AlbumCollectionViewCell {
            let album = self.albums[indexPath.row]
            acvc.titleLabel.text = "\(indexPath.row + 1). \(album.name)"
            
            if album.images.count > 1 {
                APIRequestManager.manager.getData(endPoint: album.images[1].url.absoluteString) { (data: Data?) in
                    if let validData = data,
                        let image = UIImage(data: validData) {
                        DispatchQueue.main.async {
                            acvc.imageView.image = image
                            acvc.setNeedsLayout()
                        }
                    }
                }
            }
        }
        return cell
    }
    
    // MARK: - TextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        search(textField.text!)
        textField.text = nil
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Utility
    func search(_ term: String) {
        self.title = term
        let escapedString = term.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        APIRequestManager.manager.getData(endPoint: "\(apiURLRoot)?method=album.search&album=\(escapedString!)&api_key=\(apiKey)&format=json") { (data: Data?) in
            if let validData = data,
                let validAlbums = Album.albums(from: validData) {
                self.albums = validAlbums
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // margin around the whole section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // spacing between rows if vertical / columns if horizontal
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

