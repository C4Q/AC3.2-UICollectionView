//
//  ReviewDetailsViewController.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/17/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class ReviewDetailsViewController: UIViewController {
    
    // MARK: Stored Properties
    
    var movieTitle: String?
    var rating: String?
    var summary: String?
    var movieImage: UIImage?
    
    // MARK: Outlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var movieSummaryLabel: UILabel!
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = self.movieTitle,
            let rating = self.rating,
            let summary = self.summary {
            self.movieTitleLabel.text = title
            self.movieRatingLabel.text = "Rating: \(rating)"
            self.movieSummaryLabel.text = summary
        }
        
        if let image = self.movieImage {
            self.movieImageView.image = image
        }
        
        movieImageView.layer.cornerRadius = 5
        movieImageView.layer.masksToBounds = true
    }
}
