//
//  MyFavoriteTableViewCell.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/11.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var descTextfield: UITextView!{
        didSet{
            descTextfield.isEditable = false
        }
    }
    @IBOutlet weak var commentImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
