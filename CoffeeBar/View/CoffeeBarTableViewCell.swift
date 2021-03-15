//
//  CoffeeBarTableViewCell.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/5.
//

import UIKit

class CoffeeBarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var coffeeBarName: UILabel!
    @IBOutlet weak var coffeeBarCity: UILabel!
    @IBOutlet weak var coffeeBarAddress: UILabel!{
        didSet {
            coffeeBarAddress.numberOfLines = 0
        }
    }
    @IBOutlet weak var likeImage: UIImageView!{
        didSet {
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
