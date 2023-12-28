//
//  NotificationsTableViewCell.swift
//  DateNight
//
//  Created by Wayne Williams on 12/11/23.
//

import UIKit
import Kingfisher

class NotificationsTableViewCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var connectBtn: UIButton!
    
    var notification: Notification? {
        didSet{
            guard let notification = notification else {return}
            
            if notification.type == 0 {
                attributedText(name: notification.senderName + " ",
                               text: "wants to connect with you. ", date: "\(getNotificationTimeStamo()!)")
            } else {
                attributedText(name: "",
                               text: "You have been connected with \(notification.senderName). "
                               , date: "\(getNotificationTimeStamo() ?? "")")
            }
            
            //name.text = connection.name
            let path = "images/\(notification.senderEmail)_profile_picture.png"
            StorageManager.shared.downloadURL(file: path) { [weak self] result in
                switch result {
                case .success(let url):
                    DispatchQueue.main.async {
                        self?.profileImageView.kf.setImage(with: url)
                    }
                case . failure(let error):
                    print("Failed to Get URL\(error)")
                }
            }
            
        } 
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        connectBtn.layer.cornerRadius = 5
        connectBtn.clipsToBounds = true
        profileImageView.layer.cornerRadius = 25
       
    }
    
    func attributedText(name: String, text: String, date: String) {
        
        let attributedText = NSMutableAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedText.append(NSMutableAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]))
        
        attributedText.append(NSMutableAttributedString(string: date, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        infoLabel.attributedText = attributedText
        
        
        
    }
    
    func getNotificationTimeStamo() -> String? {
        guard let notification = notification else {return nil }
            let dateFormatter = DateComponentsFormatter()
            dateFormatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
            dateFormatter.maximumUnitCount = 1
            dateFormatter.unitsStyle = .abbreviated
            return dateFormatter.string(from: notification.creationDate, to: Date())
         
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    
    
    @IBAction func connectBtnAction() {
        connectBtn.isEnabled = false
        connectBtn.backgroundColor = UIColor.lightGray
        //connectBtn.setTitleColor(UIColor.white, for: .disabled)
        
        
        
        
        
        
    }

}
