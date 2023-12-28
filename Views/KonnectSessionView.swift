//
//  KonnectSessionView.swift
//  DateNight
//
//  Created by Wayne Williams on 9/30/23.
//

import UIKit

class KonnectSessionView: UIView {

    @IBOutlet weak var frameImageView: UIImageView!
    @IBOutlet weak var cardLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var category: Category? {
        didSet{
            guard let category = category else {return}
           // countLabel.layer.cornerRadius = 20
           // print("ITEMS\(category.items)")
            category.items.forEach { [weak self] text in
              //  self?.cardLabel.text = text
            }
            
        }
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
