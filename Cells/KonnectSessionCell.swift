//
//  KonnectSessionCell.swift
//  DateNight
//
//  Created by Wayne Williams on 10/20/23.
//

import UIKit

class KonnectSessionCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    
    var category: Category? {
        didSet {
            guard let category = category else {return }
            titleLbl.text = category.title
            iconImageView.image = UIImage(named: category.image)
        }
    }
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    
}
