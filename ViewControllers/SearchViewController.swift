//
//  SearchViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/29/23.
//

import UIKit
import ProgressHUD
import Kingfisher

class SearchViewController: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    
    public var completion: (([String: String]) -> ())?
    
    private var users = [[String:String]]()
    private var hasFetched = false
    private var results = [[String:String]]()
    
    private let searchBar: UISearchBar  = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search for Users...."
       
        return searchBar
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .red
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .blue
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        
        view.addSubview(noResultLabel)
        noResultLabel.frame = CGRect(x: 40, y: -200, width: tableview.frame.size.width/2 - 20, height: 100)
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(searchCancelButton))
//        searchBar.becomeFirstResponder()
        
        print("RESULT\(results.first)")
    }
    
    @objc func searchCancelButton() {
        dismiss(animated: true)
        
    }
    
    func celltappedAlert() {
        let alert = UIAlertController(title: "Select Option", message: "Send a connect request", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Connect with Wayne", style: .default, handler: { [weak self] _ in
            
            guard let storyboard = self?.storyboard, let vc = storyboard.instantiateViewController(withIdentifier: "KonnectSessionViewController") as? KonnectSessionViewController else {return}
            vc.modalPresentationStyle = .fullScreen
            self?.present(vc, animated: true)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
        
    }
    
    private func createMessageID() -> String {
        return UUID().uuidString
    }
    
    
    private func createSession(result: [String: String]) {
        guard let otherUserName = result["name"],
              let otherUserEmail = result["email"] else {return}
        
        guard let currentUserEmail =  UserDefaults.standard.value(forKey: "email") as? String,
              let name = UserDefaults.standard.value(forKey: "name") as? String      else {return }
         let sender =  Sender(photoURL: "", senderId: currentUserEmail,
                              displayName: name)
        
        let usersCard = UsersCard(sender: sender, cardId: createMessageID(), sentDate: Date(), text: "First Card")
        
        DatabaseManager.shared.createConnection(with: otherUserEmail, withCard: usersCard, name: otherUserName ) {  success in
            if success {
                print("Session Created")
            } else {
                print("Failed to send")
            }
        }
       // navigationItem.title = name
        
    }

    func sendNotification(result: [String: String]){
        guard let email =  UserDefaults.standard.value(forKey: "email") as? String,
              let senderName = UserDefaults.standard.value(forKey: "name") as? String,
              let otherUserEmail = result["email"] else {return}
        let creationDate = Int(Date().timeIntervalSince1970)
        let currentUserEmail = DatabaseManager.safeEmail(email: email)
        
        let notificationRef = DatabaseManager.notificationRef.child(otherUserEmail).childByAutoId()
        
        
        let values = ["checked": 0,
                      "creationDate": creationDate,
                      "senderEmail":currentUserEmail,
                      "senderName": senderName,
                      "id": notificationRef.key ?? "",
                      "receiverEmail": otherUserEmail] as [String : Any]
        
        notificationRef.setValue(values) { error, ref in
            guard error == nil else {
                print("Notification Failed")
                return
            }
            
            print("Notification Success")
        }
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! SearchUserTableviewCell
        
        cell.name.text = results[indexPath.row]["name"]
        //let url = results[indexPath.row][""]
        let urlPath = (UserDefaults.standard.value(forKey: "profile_picture_url") as? String)!
        let url = URL(string: urlPath)!
        cell.imageView?.kf.setImage(with: url)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = results[indexPath.row]
            
        sendNotification(result: result)
        
        /*
        guard let storyboard = self.storyboard, let vc = storyboard.instantiateViewController(withIdentifier: "KonnectSessionViewController") as? KonnectSessionViewController else {return}
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        
        vc.results = result
        createSession(result: result)
       
        
        //let connection = Connection(id: <#T##String#>, name: <#T##String#>, otherUserEmail: <#T##String#>, latestCard: //<#T##LatestCard#>)
        //print("result \(targetUserData)")
        present(nav, animated: true)
         */
        //celltappedAlert()
    }
    
    
}


extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            return}
        
        searchBar.resignFirstResponder()
        
        results.removeAll()
        ProgressHUD.animationType = .circleSpinFade
        ProgressHUD.show()
        
        self.searchUser(query: text)
    }
    
    func searchUser(query: String) {
        // Check if array has firebase results
        if hasFetched {
            self.filterUsers(with: query)
        } else {
            DatabaseManager.shared.getAllUsers { [weak self] result in
                switch result {
                case .success(let usersCollection):
                    self?.hasFetched = true
                    self?.users = usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Error getting users\(error)")
                }
            }
        }
        
        
    }
    
    func filterUsers(with term: String) {
        guard hasFetched else {return}
        
        ProgressHUD.dismiss()
        
        let results: [[String: String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased()  else {
                return false
            }
            
            return name.hasPrefix(term.lowercased())
            
        })
        
        self.results = results
        self.updateUI()
    }
    
        
    
    func updateUI() {
        if results.isEmpty {
            self.noResultLabel.isHidden = false
            ProgressHUD.dismiss()
        } else {
            self.noResultLabel.isHidden = true
            self.tableview.reloadData()
        }
    }
}

