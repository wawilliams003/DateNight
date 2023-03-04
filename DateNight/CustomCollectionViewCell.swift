//
//  CustomCollectionViewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 3/3/23.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topicLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.clipsToBounds = true
            self.layer.cornerRadius = 20
        
    }
    
    
    override var isSelected: Bool {
           didSet {
               self.contentView.backgroundColor = isSelected ? ColorTheme.lightTeal : UIColor.clear
               
           }
       }
    
}
