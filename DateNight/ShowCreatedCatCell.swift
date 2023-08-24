//
//  ShowCreatedCatCell.swift
//  DateNight
//
//  Created by Wayne Williams on 4/23/23.
//

import UIKit

class ShowCreatedCatCell: UICollectionViewCell {
    
    
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var categeoryTitle: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var imageViewBackgroundView: UIView!
    @IBOutlet weak var blurView: UIBlurEffect!
    

    
    
    var category: Category? {
        didSet {
            
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
            guard let categories = category else {return}
            let color = UIColor.init(categories.color)
            //imageViewBackgroundView.backgroundColor = UIColor(categories.color, alpha: 0.25)
            catImageView.tintColor = color
            //catImageView.image = UIImage(systemName: categories.image)
            categeoryTitle.text = categories.title
            self.contentView.backgroundColor = color//UIColor(categories.color, alpha: 1)
            //categeoryTitle.textColor = color
            
            switch paymentOption {
            case .basic:
                print("")
            case.premium:
                removeBlurView()
            case .none:
                print("")
            }
        }
    }
    
    func removeBlurView (){
        self.viewWithTag(5)?.removeFromSuperview()
    }
    
    /*
    var categories: [Category]? {
        didSet {
            guard let categories = categories else {return}
            
            for favCat in categories {
                let color = UIColor.init(favCat.color, alpha: 1.0)
                imageViewBackgroundView.backgroundColor = UIColor(favCat.color, alpha: 0.25)
                catImageView.tintColor = color
                catImageView.image = UIImage(systemName: favCat.image)
                categeoryTitle.text = favCat.title
                categeoryTitle.textColor = color
                
                
            }
            print("TITLE\(categories[0].title)")
        }
    }
    */
    
}
