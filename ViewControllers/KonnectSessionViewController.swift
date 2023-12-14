//
//  KonnectSessionViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/30/23.
//

import UIKit
import iCarousel
import ProgressHUD
//import Toast


class KonnectSessionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var showCardText: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    public var completion: (([String: String]) -> ())?
    public var results : [String: String]?
    private  var otherConnectedUser: AppUSer?
    private var userCards = [UsersCard]()
    public var connection: Connection?
    private var name = ""
    private var text = ""
    var categories = [Category]()
    var category: Category!
    
    var appUser: AppUSer? {
        guard let name = results?["name"] as? String,
              let email = results?["email"] as? String,
              let imageUrl = URL(string: UserDefaults.standard.value(forKey: "profile_picture_url") as? String ?? "")
                else {return nil}
        let user = AppUSer(name: name, email: email, imageUrl: imageUrl)
        
        return user
    }
    
    private var selfSender: Sender? {
        guard let email =  UserDefaults.standard.value(forKey: "email") as? String else {return nil}
        let safeEmail = DatabaseManager.safeEmail(email: email)
        return Sender(photoURL: "", senderId: "",
               displayName: safeEmail)
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
        
        guard let connection = connection else {return}
        navigationItem.title = "Connected with " + connection.name
        name = connection.name
       // let imageView = UIImageView()
        setupCollectionView()
        getAllCards(id: connection.id)
        
    }
    
    func fetchData(){
        FetchData.parseJSON { [weak self] categories in
            // self?.categories = categories.shuffled()
            self?.category = categories.randomElement()
            self?.categories = categories
            self?.mainCarousel.reloadData()
            self?.collectionView.reloadData()
        }
    }
    
    func setupCollectionView(){
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: view.frame.size.width/3, height: 45)
            //flowLayout.itemSize = CGSize(width: view.frame.size.width/2.5, height: 50)
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
            flowLayout.scrollDirection = .horizontal
        }
        
    }
    
    
    
    
    private func getAllCards(id: String) {
        
        DatabaseManager.shared.getAllCardsForCOnncetion(with: id) { [weak self] result in
            switch result {
            case .success(let userCards):
                guard !userCards.isEmpty else {
                    return
                }
                self?.userCards = userCards
                DispatchQueue.main.async {
                    self?.showCardText.text = userCards.last?.text
                    ProgressHUD.remove()
                }
                print("USER CAWRD \(userCards)")
                
            case .failure(let error):
                print("Failed to get USER CARDS\(error)")
            }
        }
        
    }
    
    
    func activateConstraint() {
        
        NSLayoutConstraint.activate([
            mainCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainCarousel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainCarousel.topAnchor.constraint(equalTo: self.collectionView.bottomAnchor, constant: 40),
            mainCarousel.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100)
        ])
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
    
    
    private func sendCard(){
        
        
        ProgressHUD.show("Waiting for \(name).....", symbol: "Symbol", interaction: false)
        
        guard let connection = connection, let currentUserEmail =  UserDefaults.standard.value(forKey: "email") as? String else {return }
        
        let name = connection.name
         
        let sender =  Sender(photoURL: "", senderId: currentUserEmail,
                              displayName: name)
        let card = UsersCard(sender: sender, cardId: createMessageID(), sentDate: Date(), text: inputTextField.text ?? "Hello")

        DatabaseManager.shared.sendCard(to: connection.id, card: card, name: name) { success in
            if success {
                print("SUCCESS sending Card")
            } else {
                print("ERROR sending Card")
            }
        }
        
    }
    
    
    @IBAction func SendCard() {
        
        sendCard()
    }
    
    
    @IBAction func connectSession() {
      //  guard let result = self.results else {return}
      //  createSession(result: result)
        
        //
        //ProgressHUD.remove()
        
    }
    
    
    @IBAction func dismiss() {
        dismiss(animated: true)
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

extension KonnectSessionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as!
        KonnectSessionCell
        cell.category = categories[indexPath.item]
        
        return cell
    }
    
    
    
    
    
}

extension KonnectSessionViewController: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return categories.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        let view = Bundle.main.loadNibNamed("KonnectSessionView", owner: self)?.first as? KonnectSessionView
        view?.frame = carousel.frame//CGRect(x: 0, y: 0, width: 200, height: 300)
        
        //let imageView = UIImageView()
        //imageView.backgroundColor = .brown
        
        return view!
    }
 
    
}
