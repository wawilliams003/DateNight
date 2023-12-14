//
//  TableHeader.swift
//  DateNight
//
//  Created by Wayne Williams on 9/27/23.
//

import UIKit
import Kingfisher

class TableHeader: UIView {

    static let identifier = "tableHeader"

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var ConnectCountLbl: UILabel!
    
    func configure() {
        profileImage.layer.cornerRadius = 40
        guard let email = UserDefaults.standard.value(forKey: "email") as? String,
         let name = UserDefaults.standard.value(forKey: "name") as? String  else {return}
        self.name.text = name
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        //let url = URL(string: path)
        StorageManager.shared.downloadURL(file: path) { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.profileImage.kf.setImage(with: url)
                }
            case . failure(let error):
                print("Failed to Get URL\(error)")
            }
        }
        
    }
    
    
    
}
