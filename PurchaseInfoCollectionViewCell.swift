//
//  PurchaseInfoCollectionViewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 8/26/23.
//

import UIKit

class PurchaseInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var purchaseTypeLabel: UILabel!
    @IBOutlet weak var Basiclabel: UILabel!
    
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    
    var model: PaymentInfoModel? {
        didSet{
            guard let model = model else {return}
            label1.text = model.labe1
            label2.text = model.label2
            label3.text = model.label3
            label4.text = model.label4
            purchaseTypeLabel.text = model.purchaseType
            self.dropShadow()
        }
    }
    
}
