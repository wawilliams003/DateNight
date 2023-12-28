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
            layer.cornerRadius = 6
            layer.borderColor = UIColor.link.cgColor
            layer.borderWidth = 1
          //  iconImageView.image = UIImage(named: category.image)
        }
    }
    
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override var isSelected: Bool {
           didSet {
               UIView.animate(withDuration: 0.3) { [weak self] in
                   self?.transform = self!.isSelected ? .init(scaleX: 0.85, y: 0.85) : .identity
                   //self?.coverView.backgroundColor = self!.isSelected ? UIColor.white.withAlphaComponent(0.3): UIColor.clear
               } completion: { (done) in
                   if done {
                       UIView.animate(withDuration: 0.1) {
                          // self.transform = .identity
                       }
                   }
                   
               }
           }
       }
    
    
}
