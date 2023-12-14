//
//  NotificationsViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 12/11/23.
//

import UIKit
import FirebaseDatabase
import Foundation
import Kingfisher

class NotificationsViewController: UIViewController {
    
    
    @IBOutlet weak var tableview: UITableView!
    
    var notifications = [Notification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchNotifications { [weak self] result in
            switch result {
                
            case .success(let notifications):
                DispatchQueue.main.async {
                    self?.notifications = notifications
                    self?.tableview.reloadData()
                }
 
            case .failure(let error):
                print("FAILED TO FECT NOTIFICATIONS \(error.localizedDescription)")
            }
        }
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    func fetchNotifications(completion: @escaping (Swift.Result<[Notification], Error>) -> Void) {
        guard let email = Constants().currentUserEmail else {return}
        let safeEmail = DatabaseManager.safeEmail(email: email)
        var notifications = [Notification]()
        var date = Date()
        DatabaseManager.notificationRef.child(safeEmail).observe(.value, with: { snapshot in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {
                completion(.failure(DatabaseManager.DatabaseErrors.failedToFetch))
                return }
            dictionary.values.forEach { value in
                guard let id = value["id"] as? String,
                        let dateDboule = value["creationDate"] as? Double,
                      let receiverEmail = value["receiverEmail"] as? String,
                      let senderName = value["senderName"] as? String,
                      let senderEmail = value["senderEmail"] as? String else {return}
                
                date = Date(timeIntervalSince1970: dateDboule)
                let notification = Notification(id: id, creationDate: date, receiverEmail: receiverEmail, senderEmail: senderEmail, senderName: senderName)
                notifications.append(notification)
                
            }
            
            completion(.success(notifications))
        })
        
    }
    
    
    func showBottomSheetVC(){
        let bottomSheetVC = storyboard!.instantiateViewController(withIdentifier: "NotificationBottomSheetVC") as! NotificationBottomSheetVC
        
        guard let sheet = bottomSheetVC.presentationController as? UISheetPresentationController
        else {return}
        
        if #available(iOS 16.0, *) {
            sheet.detents = [.custom {_ in
                320
            }]
        } else {
            // Fallback on earlier versions
        }
        sheet.preferredCornerRadius = 24
        sheet.prefersGrabberVisible = false
        sheet.largestUndimmedDetentIdentifier = .none
        // sheet.largestUndimmedDetentIdentifier = .medium
        //let image = currentCarouselView?.screenshot()
        //bottomSheetVC.screenshot = image
        present(bottomSheetVC, animated: true)
    }
    

    
    
}

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! NotificationsTableViewCell
        
        cell.notification = notifications[indexPath.row]
        //cell.imageView?.kf.setImage(with: url)
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}



extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        showBottomSheetVC()
        
        
    }
    
}


