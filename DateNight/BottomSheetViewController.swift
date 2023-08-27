//
//  BottomSheetViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 1/3/23.
//

import UIKit
import MessageUI


class BottomSheetViewController: UIViewController{
   
    

    var screenshot: UIImage?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let paymentOptionsView = ShowPaymentOptionsView()
//        let customView = ShowPaymentOptionsView.loadNib()
//        customView.frame = self.view.frame
//        self.view.addSubview(customView)
//       // paymentOptionsView.buttonAction()
//        paymentOptionsView.onButtonTapCallback = {
//            print("Tapped")
//
//        }
        // Do any additional setup after loading the view.
    }

    
    @IBAction func showPurchaseOptions(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        present(vc, animated: true)
        
    }
    
    
}
