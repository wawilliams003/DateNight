//
//  SearchUserTableviewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 9/29/23.
//

import UIKit
import Kingfisher

class SearchUserTableviewCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImage.layer.cornerRadius = 30
    }

    
    var user: [String: String]? {
        didSet {
            guard let user = user else {return}
           // guard let name = user["name"] else {return}
            name.text = user["name"]
            guard let email = user["email"] else {return}
            let path = "images/\(email)_profile_picture.png"
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
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
