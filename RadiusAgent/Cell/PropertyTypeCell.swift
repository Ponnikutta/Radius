//
//  PropertyTypeCell.swift
//  RadiusAgent
//
//  Created by NFC User on 29/06/23.
//

import UIKit

class PropertyTypeCell: UITableViewCell {
    
    @IBOutlet weak var pImage: UIImageView!
    @IBOutlet weak var pLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            selectButton.setImage(UIImage(named: "tickbox"), for: .normal)
           } else {
               selectButton.setImage(UIImage(named: "untickbox"), for: .normal)
           }
    }

}
