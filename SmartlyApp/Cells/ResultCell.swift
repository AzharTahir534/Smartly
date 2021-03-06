//
//  ResultCell.swift
//  SmartlyApp
//
//  Created by Azhar on 06/03/2021.
//

import UIKit

class ResultCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateCell(title: String, score: String) {
        titleLabel.text = title
        scoreLabel.text = score
    }
}
