//
//  CustomizeViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 1/1/23.
//

import UIKit

class CustomizeViewController: UIViewController {

    
    @IBOutlet weak var fontsView: UIView!
    @IBOutlet weak var PhotoFrameView: UIView!
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    func setupView() {
        fontsView.layer.cornerRadius = 10
        fontsView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        fontsView.layer.borderWidth = 1
        
        PhotoFrameView.layer.cornerRadius = 10
        PhotoFrameView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        PhotoFrameView.layer.borderWidth = 1
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
