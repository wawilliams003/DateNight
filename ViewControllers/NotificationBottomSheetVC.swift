//
//  NotificationBottomSheetVC.swift
//  DateNight
//
//  Created by Wayne Williams on 12/14/23.
//

import UIKit

class NotificationBottomSheetVC: UIViewController {

    @IBOutlet  var BackgroundViews: [UIView]!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func connectBtn() {
        
        
    }
    
    
    @IBAction func removeBtn() {
        
        
    }
    
    func setupViews(){
        BackgroundViews.forEach { view in
            view.layer.cornerRadius = 20
        }
        
        
        
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
