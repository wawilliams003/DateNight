//
//  KonnectSessionViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/30/23.
//

import UIKit
import iCarousel
import ProgressHUD
import BLTNBoard
//import Toast


class KonnectSessionViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var showCardText: UILabel!
    @IBOutlet weak var inputTextField: UITextField!
    
    public var completion: (([String: String]) -> ())?
    public var results : [String: String]?
   // private  var otherConnectedUser: AppUSer?
    private var userCards = [UsersCard]()
    public var connection: Connection?
    private var name = ""
    private var text = ""
    var categories = [Category]()
    var category: Category!
    var selectedCategory: Category!
    var carouselIndex = 0
    
    /*
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
        return Sender(photoURL: "", senderEmail: "",
               displayName: safeEmail)
    }
     */
    
    let mainCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var boardManager: BLTNItemManager = {
       
        let item = BLTNPageItem(title: "You are connected with \(connection?.name ?? "")")
        item.image = UIImage(systemName: "checkmark")
        item.actionButtonTitle = "SEND CARD"
        item.alternativeButtonTitle = "Wait for \(connection?.name ?? "")"
        item.descriptionText = "Send and share card with \(connection?.name ?? "")"
        
        //item.appearance.actionButtonColor = .systemGreen
        item.appearance.actionButtonTitleColor = .white
        item.appearance.alternativeButtonBorderColor = .link
        item.appearance.alternativeButtonBorderWidth = 1
        
        
        return BLTNItemManager(rootItem: item)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainCarousel)
            activateConstraint()
        fetchData()
        mainCarousel.delegate = self
        mainCarousel.dataSource = self
        
        guard let connection = connection else {return}
        navigationItem.title = "Connected with " + connection.name
        name = connection.name
       // let imageView = UIImageView()
        setupCollectionView()
        //getAllCards(id: connection.id)
        //getLastCard(for: connection.id)
        tapGesture()
        boardManager.backgroundViewStyle = .dimmed
        boardManager.showBulletin(above: self)
        //boardManager.allowsSwipeInteraction = true
        //print("CONNECTION\(connection)")
    }
    
    func fetchData(){
        FetchData.parseJSON { [weak self] categories in
            self?.selectedCategory = categories.randomElement()
            // self?.categories = categories.shuffled()
            //self?.category = categories.randomElement()
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
                    guard let email = Constants().currentUserEmail,
                          let senderEmail = userCards.last?.sender.senderEmail else {return}
                    print("EMAIL\(email)")
                    if email != senderEmail {
                        ProgressHUD.show(userCards.last?.text, interaction: true)
                        //self?.showCardText.text = userCards.last?.text
                    }
                   
                }
                print("USER CAWRD \(userCards)")
               // ProgressHUD.show(userCards.last?.text, interaction: true)

                
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

    func tapGesture(){
        let gesture = UITapGestureRecognizer()
        gesture.numberOfTapsRequired = 2
        gesture.addTarget(self, action: #selector(gestureAction))
        
        mainCarousel.addGestureRecognizer(gesture)
    }
    
    
    @objc func gestureAction() {
        let text = selectedCategory.items[carouselIndex]
        self.sendCard(text: text)
    }
    
    
    private func createMessageID() -> String {
        return UUID().uuidString
    }
    
    
    private func createSession(result: [String: String]) {
        guard let otherUserName = result["name"],
              let otherUserEmail = result["email"] else {return}
        
        guard let currentUserEmail =  UserDefaults.standard.value(forKey: "email") as? String,
              let name = UserDefaults.standard.value(forKey: "name") as? String      else {return }
         let sender =  Sender(photoURL: "", senderEmail: currentUserEmail,
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
    
    private func sendCard(text: String) {
        
        ProgressHUD.show("Waiting for \(name).....", symbol: "Symbol", interaction: true)
        
        guard let connection = connection, let currentUserEmail =  UserDefaults.standard.value(forKey: "email") as? String else {return }
        
        let name = connection.name
         
        let sender =  Sender(photoURL: "", senderEmail: currentUserEmail,
                              displayName: name)
        let card = UsersCard(sender: sender, cardId: createMessageID(), sentDate: Date(), text: text)

        DatabaseManager.shared.sendCard(to: connection.id, card: card, name: name) { success in
            if success {
                print("SUCCESS sending Card")
                //guard let connection = self.connection else {return}
               
            } else {
                print("ERROR sending Card")
            }
        }
        
    }
    
    
    func getLastCard(for id: String) {
        DatabaseManager().getLastCard(with: id) { result in
            switch result {
            case .success(let userCard):
                DispatchQueue.main.async {
                    guard let email = Constants().currentUserEmail else {return }
                          let senderEmail = userCard.sender.senderEmail
                    if email != senderEmail {
                        ProgressHUD.show(userCard.text, interaction: true)
                        //self?.showCardText.text = userCards.last?.text
                    }
                   
                   
                }
                
                
            case .failure(let error):
                print("Failed to get USER CARD\(error)")
            }
        }
    }
    
    /*
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
    */

    
    
    
    @IBAction func SendCard() {
        
       // sendCard()
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
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategory = categories[indexPath.item]
        mainCarousel.reloadData()
    }
    
    
    
}

extension KonnectSessionViewController: iCarouselDataSource, iCarouselDelegate {
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        
        return (selectedCategory.items.count) //?? categories.randomElement()!.items.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        guard let konnectSessionView = Bundle.main.loadNibNamed("KonnectSessionView", owner: self)?.first as? KonnectSessionView else {return UIView()}
        konnectSessionView.frame = carousel.frame//CGRect(x: 0, y: 0, width: 200, height: 300)
        
        //konnectSessionView.category = selectedCategory?.items[index] ?? categories.randomElement()
        konnectSessionView.cardLabel.text = selectedCategory.items[index]
        
        let myIndex = 1 + index
        let remainingCard = selectedCategory.items.count
    
        //let infoLbl = UILabel()
        konnectSessionView.countLabel.text = "\(myIndex)/\(remainingCard)"
        konnectSessionView.countLabel.layer.cornerRadius = 20
        konnectSessionView.countLabel.layer.borderColor = UIColor.secondaryLabel.cgColor
        konnectSessionView.countLabel.layer.borderWidth = 1
        
        return konnectSessionView
    }
 
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        self.carouselIndex = carousel.currentItemIndex
    }
    

    
}
