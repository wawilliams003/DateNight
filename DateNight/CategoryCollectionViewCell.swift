//
//  CategoryCollectionViewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 12/13/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var catButton: UIButton!
    @IBOutlet weak var categeoryTitle: UILabel!
    @IBOutlet weak var likesCount: UILabel!


    var categories: Category? {
        didSet {
            guard let categories = categories else {return}
            let color = UIColor.init(categories.color, alpha: 1.0)
            catButton.tintColor = color
            catButton.setImage(UIImage(systemName: categories.image), for: .normal)
            categeoryTitle.text = categories.title
            categeoryTitle.textColor = color
        }
    }
}
