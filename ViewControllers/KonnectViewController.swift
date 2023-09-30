//
//  KonnectViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/24/23.
//

import UIKit

class KonnectViewController: UIViewController {

    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var headerView: TableHeader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        barbuttons()
        
        setupHeader()
    }
    
    
    
    func setupHeader(){
        tableview.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: tableview.frame.width, height: 130)
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {return }
        let safeEmail = DatabaseManager.safeEmail(email: email)
        let filename = safeEmail + "_profile_picture_png"
        let path = "images/"+filename
        
        
        StorageManager.shared.downloadURL(file: path) { [weak self] result in
            //let defaultImage = UIImageView
            switch result {
            case . success(let url):
                self?.downloadImage(imageView: self?.headerView.profileImage ?? UIImageView(), url: url)
            case .failure(let error):
                print("Error getting download image\(error)")
            }
        }
        
        
        
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
        let rightBtn = UIBarButtonItem(title: "Register", image: nil, target: self, action: #selector(rightBtnAction))
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    @objc func leftBtnAction() {
        dismiss(animated: true)
    }

    
    @objc func rightBtnAction() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "RegisterViewController") as!
        RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func searchBtn() {
       let vc = storyboard!.instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
      //  let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
        
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
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension KonnectViewController: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//        headerView.name.text = "NAME"
//        return headerView
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        200
//    }
}
