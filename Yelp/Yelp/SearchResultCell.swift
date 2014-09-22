//
//  SearchResultCell.swift
//  Yelp
//
//  Created by sanket patel on 9/21/14.
//  Copyright (c) 2014 sanket patel. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    @IBOutlet weak var businessImage: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var starsImage: UIImageView!
    
    @IBOutlet weak var reviewsLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var distanceLable: UILabel!
    
    @IBOutlet weak var categoriesLabel: UILabel!
    
    @IBOutlet weak var priceRatingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    func populate(searchResult: SearchResult) {
        
        businessImage.setImageWithURL(NSURL(string: searchResult.imageUrl))
        businessImage.clipsToBounds = true
        nameLabel.text = searchResult.name
        distanceLable.text = "\(randomDistance()) mi"
        starsImage.setImageWithURL(NSURL(string: searchResult.stars))
        priceRatingLabel.text = randomPriceRange()
        reviewsLabel.text = "\(searchResult.numOfReviews) Reviews"
        //addressLabel.text = "\(searchResult.address), \(searchResult.neighborhood)"
        addressLabel.text = "\(searchResult.address)"
        categoriesLabel.text = searchResult.categoryStr
    }
    
    func randomPriceRange() -> String {
        
        var priceRanges = ["$", "$$", "$$$", "$$$$"]
        var randomNumber : Int = Int(rand()) % (priceRanges.count - 1)
        return priceRanges[randomNumber]
    }
    
    func randomDistance() -> String {
        
        var distances = ["0.07", "0.4", "0.6", "1.2", "4.4"]
        var randomNumber : Int = Int(rand()) % (distances.count - 1)
        return distances[randomNumber]
    }

}
