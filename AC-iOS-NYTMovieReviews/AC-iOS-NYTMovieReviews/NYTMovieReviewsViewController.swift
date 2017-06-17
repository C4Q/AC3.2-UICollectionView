//
//  NYTMovieReviewsViewController.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

fileprivate let apiURLRoot = "http://api.nytimes.com/svc/movies/v2/"
fileprivate let apiKeyQueryValue = "f41fed57c4b04ef5aed4b09b0bbc56b9"
fileprivate let apiKeyQueryKey = "api-key"
fileprivate let tableViewCellReuseIdentifier = "CriticTVCell"
fileprivate let collectionViewCellReuseIdentifier = "ReviewCVCell"

class NYTMovieReviewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Stored Properties
    
    var critics: [Critic] = []
    var reviews: [Review] = []
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    // MARK: - Outlets
    
    @IBOutlet weak var criticsTableView: UITableView!
    @IBOutlet weak var reviewsByCriticCollectionView: UICollectionView!
    
    //MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegatesAndDataSources()
        loadCritics()
    }
    
    // MARK: - Helper Methods
    
    func setDelegatesAndDataSources() {
        criticsTableView.delegate = self
        criticsTableView.dataSource = self
        reviewsByCriticCollectionView.delegate = self
        reviewsByCriticCollectionView.dataSource = self
    }
    
    func loadCritics() {
        guard let url = getCriticsFromURLWithComponents() else {
            print("ERROR BUILDING URL COMPONENTS")
            return
        }
        print("URL: \(url.absoluteString)")
        APIRequestManager.manager.getData(with: url) { (data: Data?) in
            if let validData = data,
                let critics = Critic.critics(from: validData) {
                self.critics = critics
                DispatchQueue.main.async {
                    self.criticsTableView.reloadData()
                }
            }
        }
    }
    
    func getCriticsFromURLWithComponents() -> URL? {
        let getAllCriticsURL = "\(apiURLRoot)critics/all.json"
        guard var urlComponents = URLComponents(string: getAllCriticsURL) else { return nil }
        
        let apiKeyQuery = URLQueryItem(name: apiKeyQueryKey, value: apiKeyQueryValue)
        urlComponents.queryItems = [apiKeyQuery]
        
        return urlComponents.url
    }
    
    func getMovieReviewsByCritic(_ criticName: String) -> URL? {
        let getMovieReviewsByCriticURL = "\(apiURLRoot)reviews.search.json"
        guard var urlComponents = URLComponents(string: getMovieReviewsByCriticURL) else { return nil }
        
        let apiKeyQuery = URLQueryItem(name: apiKeyQueryKey, value: apiKeyQueryValue)
        let reviewerQuery = URLQueryItem(name: "reviewer", value: criticName)
        urlComponents.queryItems = [apiKeyQuery, reviewerQuery]
        
        return urlComponents.url
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.critics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellReuseIdentifier, for: indexPath) as! CriticTableViewCell
        
        cell.criticHeadshotImageView.layer.cornerRadius = 32
        cell.criticHeadshotImageView.layer.masksToBounds = true
        
        let critic = self.critics[indexPath.row]
        
        cell.criticNameLabel.text = critic.name
        
        if let criticImage = critic.image {
            APIRequestManager.manager.getData(with: criticImage.url.absoluteString) { (data: Data?) in
                if let validData = data,
                    let image = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        cell.criticHeadshotImageView.image = image
                        self.criticsTableView.reloadData()
                    }
                }
            }
        } else {
            cell.criticHeadshotImageView.image = nil
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\n\n----\n\n")
        print("Tapped row at index: \(indexPath.row)")
        let critic = self.critics[indexPath.row]
        
        guard let url = getMovieReviewsByCritic(critic.name) else { return }
        
//        APIRequestManager.manager.getData(with: url) { (data: Data?) in
//            if let validData = data {
//                if let allReviews = Review.reviews(from: validData) {
//                    self.reviews = allReviews
//                    DispatchQueue.main.async {
//                        self.reviewsByCriticCollectionView.reloadData()
//                    }
//                }
//            }
//        }
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellReuseIdentifier, for: indexPath) as! MovieReviewCollectionViewCell

        
        return item
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
