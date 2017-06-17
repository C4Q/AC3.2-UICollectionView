//
//  CriticTableViewCell.swift
//  AC-iOS-NYTMovieReviews
//
//  Created by Erica Y Stevens on 6/16/17.
//  Copyright © 2017 C4Q. All rights reserved.
//

import UIKit

class CriticTableViewCell: UITableViewCell {
    
    @IBOutlet weak var criticNameLabel: UILabel!
    @IBOutlet weak var criticHeadshotImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
