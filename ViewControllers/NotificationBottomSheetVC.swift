//
//  NotificationBottomSheetVC.swift
//  DateNight
//
//  Created by Wayne Williams on 12/14/23.
//

import UIKit
import Kingfisher

class NotificationBottomSheetVC: UIViewController {

    @IBOutlet  var BackgroundViews: [UIView]!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var connectBtnOutlet: UIButton!
    
    var notification: Notification?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        fetchUserImage()
        
        print("NOTIFICATION\(notification)")
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func connectBtn() {
        guard let notification = notification else {return}
        createSession(notification: notification)
        
    }
    
    
    @IBAction func removeBtn() {
        
        
    }
    
    func setupViews(){
        BackgroundViews.forEach { view in
            view.layer.cornerRadius = 20
            imageView.layer.cornerRadius = 50
        }
        
        guard let notification = notification else {return}
        
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(string: "Connect with \(notification.senderName)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)]))
        
        let attributedStringBtn = NSMutableAttributedString(attributedString: NSAttributedString(string: "Connect with \(notification.senderName)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)]))
        
        connectBtnOutlet.setAttributedTitle(attributedStringBtn, for: .normal)
      //  connectBtnOutlet. = "Connect  \(notification.senderName)"
        
        attributedString.append(NSMutableAttributedString(attributedString: NSAttributedString(string: "\(notification.senderName)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .medium)])))
        
        attributedString.append(NSMutableAttributedString(attributedString: NSAttributedString(string: " to share cards wirelessly", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14, weight: .regular)])))
        titleLabel.attributedText = attributedString
        
        
    }
    
    func fetchUserImage(){
        guard let notification = notification else {return}
        let path = "images/\(notification.senderEmail)_profile_picture.png"
        StorageManager.shared.downloadURL(file: path) { [weak self] result in
            switch result {
            case .success(let url):
                DispatchQueue.main.async {
                    self?.imageView.kf.setImage(with: url)
                }
            case . failure(let error):
                print("Failed to Get URL\(error)")
            }
        }
        
    }
    
    func createConnection(notification: Notification) {
        
        
        
        
        
    }
    
    func sendAcceptedNotification(notification: Notification){
        
        guard let email =  UserDefaults.standard.value(forKey: "email") as? String,
              let senderName = UserDefaults.standard.value(forKey: "name") as? String else {return}
              let otherUserEmail = notification.senderEmail //else {return}
        let creationDate = Int(Date().timeIntervalSince1970)
        let currentUserEmail = DatabaseManager.safeEmail(email: email)
        
        let notificationRef = DatabaseManager.notificationRef.child(otherUserEmail).childByAutoId()
        
        
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "senderEmail":currentUserEmail,
                      "senderName": senderName,
                      "id": notificationRef.key ?? "",
                      "type": 1,
                      "receiverEmail": otherUserEmail] as [String : Any]
        
        notificationRef.setValue(values) { error, ref in
            guard error == nil else {
                print("Notification Failed")
                return
            }
            
            print("Notification Success")
        }
    }
    
    
    private func createMessageID() -> String {
        return UUID().uuidString
    }
    
    
    private func createSession(notification: Notification) {
        
         let otherUserName = notification.senderName //result["name"],
        let otherUserEmail = notification.senderEmail//notification.receiverEmail//result["email"] else {return}
        
        guard let currentUserEmail =  UserDefaults.standard.value(forKey: "email") as? String,
              let name = UserDefaults.standard.value(forKey: "name") as? String      else {return }
         let sender =  Sender(photoURL: "", senderId: currentUserEmail,
                              displayName: name)
        
        let usersCard = UsersCard(sender: sender, cardId: createMessageID(), sentDate: Date(), text: "First Card")
        
        DatabaseManager.shared.createConnection(with: otherUserEmail, withCard: usersCard, name: otherUserName ) { [weak self] success in
            if success {
                print("Session Created Notification Sent")
                self?.sendAcceptedNotification(notification: notification)
                
            } else {
                print("Failed to send")
            }
        }
       // navigationItem.title = name
        
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
