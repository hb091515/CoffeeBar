//
//  CoffeeBarInfoCell.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/8.
//

import UIKit

class CoffeeBarInfoCell: UITableViewCell {

    @IBOutlet weak var iconImage: UIImageView!{
        didSet{
            iconImage.layer.cornerRadius = 5
            iconImage.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var showTextLabel: UILabel!{
        didSet{
            showTextLabel.numberOfLines = 0
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
