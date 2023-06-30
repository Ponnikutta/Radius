//
//  RoomTypeCell.swift
//  RadiusAgent
//
//  Created by NFC User on 30/06/23.
//

import UIKit

class RoomTypeCell: UITableViewCell {
    
    @IBOutlet weak var roomImage: UIImageView!
    @IBOutlet weak var roomTitle: UILabel!
    @IBOutlet weak var roomSelect: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            roomSelect.setImage(UIImage(named: "tickbox"), for: .normal)
           } else {
               roomSelect.setImage(UIImage(named: "untickbox"), for: .normal)
           }
    }

}
