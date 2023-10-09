//
//  KonnectSessionViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/30/23.
//

import UIKit
import iCarousel

class KonnectSessionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    public var completion: (([String: String]) -> ())?
    
    public var results : [String: String]?
    
    private var selfSender: Sender? {
        guard let email =  UserDefaults.standard.value(forKey: "email") as? String else {return nil}
         return Sender(photoURL: "", senderId: "",
               displayName: email)
    }
    
    
    let mainCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        return view
    }()
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainCarousel)
            activateConstraint()
        mainCarousel.delegate = self
        mainCarousel.dataSource = self
       
        print("RESULT\(results)")
       // mainCarousel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 20, height: 300)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    
    func activateConstraint() {
        
        NSLayoutConstraint.activate([
            
            mainCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainCarousel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainCarousel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            mainCarousel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
        ])
    }

    private func createMessageID() -> String {
        return UUID().uuidString
    }
    
    
    private func createSession(result: [String: String]) {
        guard let name = result["name"],
              let email = result["email"] else {return}
        
        guard let currentUserEmail =  UserDefaults.standard.value(forKey: "email") as? String else {return }
         let sender =  Sender(photoURL: "", senderId: currentUserEmail,
                              displayName: "")
        
        let usersCard = UsersCard(sender: sender, cardId: createMessageID(), sentDate: Date(), text: "First Card")
        
        DatabaseManager.shared.createConnection(with: email, withCard: usersCard, name: name) {  success in
            if success {
                print("Message Sewnt")
            } else {
                print("Failed to send")
            }
        }
        navigationItem.title = name
        
    }
    
    @IBAction func connectSession() {
        guard let result = self.results else {return}
        createSession(result: result)
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

extension KonnectSessionViewController: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 4
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let view = Bundle.main.loadNibNamed("KonnectSessionView", owner: self)?.first as? KonnectSessionView
        
        
        return view!
    }
    
    
    
    
    
    
    
    
    
    
    
}
