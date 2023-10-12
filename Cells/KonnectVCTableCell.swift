//
//  KonnectVCTableCell.swift
//  DateNight
//
//  Created by Wayne Williams on 10/11/23.
//

import UIKit
import Kingfisher


class KonnectVCTableCell: UITableViewCell {

    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.profileImage.layer.cornerRadius = 30
        
        // Initialization code
    }

    var connection: Connection? {
        didSet {
            guard let connection = connection else {return}
            name.text = connection.name
            let path = "images/\(connection.otherUserEmail)_profile_picture.png"
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
