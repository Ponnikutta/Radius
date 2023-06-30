//
//  FacilityTypeCell.swift
//  RadiusAgent
//
//  Created by NFC User on 30/06/23.
//

import UIKit

class FacilityTypeCell: UITableViewCell {
    
    @IBOutlet weak var facilityImage: UIImageView!
    @IBOutlet weak var facilityName: UILabel!
    @IBOutlet weak var facilitySelect: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            facilitySelect.setImage(UIImage(named: "tickbox"), for: .normal)
           } else {
               facilitySelect.setImage(UIImage(named: "untickbox"), for: .normal)
           }
    }

}
