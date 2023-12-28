//
//  KonnectViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/24/23.
//

import UIKit
import FirebaseAuth


var count = 0

class KonnectViewController: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var headerView: TableHeader!
    
    private var connections = [Connection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barbuttons()
        
        setupHeader()
        startListeningForConnections()
    }
    
    private func startListeningForConnections(){
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        
        DatabaseManager.shared.getAllConnections(for: safeEmail) { [weak self] result in
            switch result {
            case .success(let connections):
                guard !connections.isEmpty else {
                    return
                }
                self?.connections = connections
                DispatchQueue.main.async {
                    self?.tableview.reloadData()
                }
                
            case .failure(let error):
                print("ERROR getting connections\(error)")
                
            }
        }
    }
    
    
    func connectAlert(){
        let alert = UIAlertController(title: "Wants to conenct with you", message: "You can accept or deny request", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Accept", style: .default, handler: { _ in
            print("Connected")
        }))
        
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
            print("Didn't Connect")
        }))
        
        present(alert, animated: true)
    }
    
    
    func setupHeader(){
        tableview.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 220)
        //headerView.name.text = "HET"
        headerView.configure()
        /*
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let filename = safeEmail + "_profile_picture.png"
        let path = "images/"+filename
        //headerView.profileImage.
        
        StorageManager.shared.downloadURL(file: path) { [weak self] result in
            //let defaultImage = UIImageView
            switch result {
            case . success(let url):
                self?.downloadImage(imageView: self?.headerView.profileImage ?? UIImageView(), url: url)
            case .failure(let error):
                print("Error getting download image\(error)")
            }
        }
        
        */
        
       // headerView.name.text = "NAME"
        
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {return}
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }.resume()
        
        
    }
    
    func barbuttons() {
        let leftBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(leftBtnAction))
        self.navigationItem.leftBarButtonItem = leftBtn
        let rightBtn = UIBarButtonItem(title: "SignOut", image: nil, target: self, action: #selector(rightBtnAction))
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    @objc func leftBtnAction() {
        dismiss(animated: true)
    }

    
    @objc func rightBtnAction() {
//        let vc = storyboard!.instantiateViewController(withIdentifier: "RegisterViewController") as!
//        RegisterViewController
//        self.navigationController?.pushViewController(vc, animated: true)
        logOut()
    }
    
    @IBAction func searchBtn() {
       let vc = storyboard!.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
      //  let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

    @IBAction func logOutBtn() {
        logOut()
    }
    
    
    @IBAction func notificationBtn() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func logOut(){
        
        do  {
           try FirebaseAuth.Auth.auth().signOut()
            print("USER LOGGED OUT")
        } catch {
            
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


extension KonnectViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return connections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! KonnectVCTableCell
        cell.connection = connections[indexPath.row]
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableview.deselectRow(at: indexPath, animated: true)
        
        let connection = connections[indexPath.row]
        
        guard let storyboard = self.storyboard, let vc = storyboard.instantiateViewController(withIdentifier: "KonnectSessionViewController") as? KonnectSessionViewController else {return}
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.connection = connection
        //vc.results = 
       
        present(nav, animated: true)
    }
    
}

extension KonnectViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  80
    }
    
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        headerView.name.text = "SOME NAME"
        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}
