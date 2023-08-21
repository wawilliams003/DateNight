//
//  BottomSheetViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 1/3/23.
//

import UIKit
import MessageUI


class BottomSheetViewController: UIViewController, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate{
   
    

    var screenshot: UIImage?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func message(_ sender: Any) {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = "From DateNight App"
            guard let image = screenshot, let data = image.pngData() else {return}
            messageVC.addAttachmentData(data, typeIdentifier: "public.data", filename: "image.png")
            self.present(messageVC, animated: true)
        }
        
    }
    
    
    @IBAction func photos(_ sender: Any) {
        
        
    }
    
    @IBAction func options(_ sender: Any) {
    }
    
    
    @IBAction func close(_ sender: Any) {
        
        dismiss(animated: true)
    }
    
}
