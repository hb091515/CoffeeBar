//
//  FavoriteTableViewCell.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/24.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var shopName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
