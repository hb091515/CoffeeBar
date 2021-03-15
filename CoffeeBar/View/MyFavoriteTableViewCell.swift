//
//  MyFavoriteTableViewCell.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/11.
//

import UIKit

class MyFavoriteTableViewCell: UITableViewCell {

    @IBOutlet weak var likeNameLabel: UILabel!
    @IBOutlet weak var likeCityLabel: UILabel!
    @IBOutlet weak var likeLocationLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
