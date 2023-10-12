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
    
    func configure() {
        profileImage.layer.cornerRadius = 40
        name.text = "ME"
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return }
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
