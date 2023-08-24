//
//  CustomCollectionViewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 3/3/23.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var topicLbl: UILabel!
    @IBOutlet weak var bgkView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
            self.clipsToBounds = true
            self.layer.cornerRadius = 20
            bgkView.layer.cornerRadius = 20
        
    }
    
    var cardModel: CreateCardModel? {
        didSet {
            guard let model = cardModel else {return}
            topicLbl.text = model.categoryTitle
            bgkView.backgroundColor = UIColor.init(model.colorString)
            
        }
    }
    
    override var isSelected: Bool {
           didSet {
               //self.contentView.backgroundColor = isSelected ? ColorTheme.lightTeal : UIColor.clear
               self.bgkView.layer.borderWidth = isSelected ? 2 : 0 ///0/UIColor.clear
               self.bgkView.layer.borderColor = isSelected ? UIColor.label.cgColor : UIColor.clear.cgColor //UIColor.label.cgColor
           }
       }
    
}
