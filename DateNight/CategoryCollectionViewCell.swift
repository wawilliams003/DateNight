//
//  CategoryCollectionViewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 12/13/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var categeoryTitle: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var imageViewBackgroundView: UIView!


    var categories: Category? {
        didSet {
            guard let categories = categories else {return}
            let color = UIColor.init(categories.color, alpha: 1.0)
            contentView.backgroundColor = color
            //imageViewBackgroundView.backgroundColor = UIColor(categories.color, alpha: 0.25)
            catImageView.tintColor = color
            catImageView.image = UIImage(named: categories.image)
            categeoryTitle.text = categories.title
            categeoryTitle.textColor = UIColor.white
        }
    }
    
    /*
    var favoritesCategories: [Category]? {
        didSet {
            guard let categories = favoritesCategories else {return}
            for favCat in categories {
                let color = UIColor.init(favCat.color, alpha: 1.0)
                contentView.backgroundColor = color
                //imageViewBackgroundView.backgroundColor = UIColor(favCat.color, alpha: 0.25)
                //catImageView.tintColor = color
                catImageView.image = UIImage(systemName: favCat.image)
                categeoryTitle.text = favCat.title
                categeoryTitle.textColor = UIColor.white
            }
        }
    }
     */
}
