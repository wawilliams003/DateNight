//
//  ShowPaymentOptionsView.swift
//  DateNight
//
//  Created by Wayne Williams on 8/20/23.
//

import UIKit

class ShowPaymentOptionsView: UIView {

    
    var onButtonTapCallback: (()->())?
    
    static func loadNib () -> UIView{
        
        let customView = Bundle.main.loadNibNamed("ShowPaymentOptionsView", owner: self)?.first as! ShowPaymentOptionsView
        return customView
    }
    
    
    
    @IBAction func buttonAction() {
        onButtonTapCallback?()
       // print("tapped")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
