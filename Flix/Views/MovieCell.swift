//
//  MovieCell.swift
//  Flix
//
//  Created by Joey Dafforn on 1/9/18.
//  Copyright © 2018 Joey Dafforn. All rights reserved.
//

import UIKit
import Cosmos

class MovieCell: UITableViewCell {

    
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var ratingLabel: CosmosView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var overviewLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
