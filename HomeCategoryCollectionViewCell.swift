//
//  HomeCategoryCollectionViewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 9/2/23.
//

import UIKit

class HomeCategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    var color = UIColor.white
    
    var categories: Category? {
        didSet {
            guard let categories = categories else {return}
           // let color = UIColor.init(categories.color, alpha: 1.0)
           // contentView.backgroundColor = color
           // self.color = color
            //imageViewBackgroundView.backgroundColor = UIColor(categories.color, alpha: 0.25)
            //catImageView.tintColor = color
            //catImageView.image = UIImage(named: categories.image)
            categoryLbl.text = categories.title.uppercased()
            categoryLbl.textColor = .link
            self.layer.borderColor = UIColor.link.withAlphaComponent(0.6).cgColor
            self.layer.borderWidth = 1.5
            iconImageView.image = UIImage(named: categories.image)
            iconImageView.tintColor = UIColor.init(categories.color, alpha: 1.0)
            //categoryLbl.textColor = UIColor.black
            
            self.layer.cornerRadius = 05
        }
    }
    
    
    override var isSelected: Bool {
           didSet {
               UIView.animate(withDuration: 0.3) { [weak self] in
                   self?.transform = self!.isSelected ? .init(scaleX: 0.85, y: 0.85) : .identity
                   self?.coverView.backgroundColor = self!.isSelected ? UIColor.white.withAlphaComponent(0.3): UIColor.clear
               } completion: { (done) in
                   if done {
                       UIView.animate(withDuration: 0.1) {
                          // self.transform = .identity
                       }
                   }
                   
               }
               
              
               //self.contentView.backgroundColor = isSelected ? ColorTheme.lightTeal : UIColor.clear
              // self.coverView.layer.borderWidth = isSelected ? 2 : 0 ///0/UIColor.clear
              // self.coverView.layer.borderColor = isSelected ? color.cgColor : UIColor.clear.cgColor //UIColor.label.cgColor
              // self.categoryLbl.textColor = isSelected ? color : UIColor.white
              // self.coverView.backgroundColor = isSelected ? UIColor.white.withAlphaComponent(0.5): UIColor.clear
           }
       }
    
    
}
