//
//  TopicTVCell.swift
//  BoardApp
//
//  Created by Rodrigo Chousal on 8/28/18.
//  Copyright © 2018 Rodrigo Chousal. All rights reserved.
//

import UIKit

class TopicTVCell: UITableViewCell {

    @IBOutlet weak var colorBarView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var objectiveLabel: UILabel!
    @IBOutlet weak var responsibleLabel: UILabel!
    @IBOutlet weak var attachmentCountLabel: UILabel!
    @IBOutlet weak var attachmentImageView: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var durationImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
