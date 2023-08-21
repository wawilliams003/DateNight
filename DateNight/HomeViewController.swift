//
//  ViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 12/13/22.
//

import UIKit
import Koloda
import LGButton
import iCarousel
import AVFoundation
import SwiftUI
import MessageUI

struct ColorTheme {
    static let lightColor = UIColor.init("30314B", alpha: 1.0)
    static let lightTeal = UIColor.init("089E97", alpha: 1.0)
    static let mainColor = UIColor.init("4361ee", alpha: 1.0)
}


@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.white
    @IBInspectable var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
    }
}




class HomeViewController: UIViewController, UIContextMenuInteractionDelegate {
  
    
    
    @IBOutlet weak var myView: UIView!
    // @IBOutlet weak var mainCarousel: iCarousel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var categoryTitleButton: UIButton!
    //MARK: Properties
    
    var speechLabel = UILabel()
    let synthesizer = AVSpeechSynthesizer()
    var carouselCurrentIndex = 0
    var categories = [Category]()
    var category: Category!
    var framesNameString = "frame3"
    var fontNameString = "Georgia-Bold"
    var backgroundColor = ColorTheme.mainColor
    var fontColor = ""
    var currentCarouselView: UIView?
    
    
    let mainCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .coverFlow
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isPagingEnabled = true
        return view
    }()
    
    
    
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        // view.contentOffset = CGSize(width: 50, height: 50)
        //view.numberOfVisibleItems = 5
        return view
    }()
    
    let fontCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let cancelButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = ColorTheme.lightColor
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle("X", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        button.addTarget(nil, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
        
    }()
    
    func tapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        myCarousel.addGestureRecognizer(tap)
        tap.numberOfTapsRequired = 2
        //view.addGestureRecognizer(tap)
        myCarousel.isUserInteractionEnabled = true
        //self.view.addSubview(view)

        // function which is triggered when handleTap is called
       
    }
    
    //let cards = ["dr", "thor", "ironman", "spider", "avenger"]
    
    let cards = ["Do you believe in love?", "Do you believe in love at first sight?",
                 "Do you know how to love?", "What is your definition of love?", "Do you love yourself?"]
    let frames = ["birthday", "border", "christmas", "merry-christmas"]
    
    let fonts = ["AmericanTypewriter-CondensedLight","Avenir-HeavyOblique",
                 "AvenirNext-Italic", "ChalkboardSE-Regular", "HelveticaNeue-CondensedBlack", "HelveticaNeue-Italic", "AcademyEngravedLetPlain"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FetchData.parseJSON { [weak self] categories in
            // self?.categories = categories.shuffled()
            self?.category = categories.randomElement()
            self?.mainCarousel.reloadData()
        }
        setupViews()
       // tapGesture()
        print("FETCHED CAT\(DataManager().fetchSavedCategories())")
        categoryTitleButton.titleLabel?.font = UIFont.systemFont(ofSize: 25, weight: .medium)
        
        }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //mainCarousel.dataSource = nil
    }
    
    
    
    //MARK: Helper Functions
    /*
     func parseJSON() {
     guard let path = Bundle.main.path(forResource: "data", ofType: "json") else {return}
     
     let url = URL(fileURLWithPath: path)
     
     do {
     let jsonData = try Data(contentsOf: url)
     let result = try JSONDecoder().decode(Result.self, from: jsonData)
     } catch {
     print("ERROR GETTING DATA \(error.localizedDescription)")
     }
     }
     */
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("Hello Tapped")
    }
    
    
    func setupViews(){
        view.addSubview(mainCarousel)
        view.addSubview(myCarousel)
        view.addSubview(fontCarousel)
        view.addSubview(cancelButton)
        fontCarousel.isHidden = true
        myCarousel.isHidden = true
        cancelButton.isHidden = true
        activateConstraint()
        //cancelButton.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
        // fontCarousel.frame = CGRect(x: 0, y: 380, width: view.frame.size.width, height: 100)
        myCarousel.dataSource = self
        myCarousel.delegate = self
        fontCarousel.dataSource = self
        fontCarousel.delegate = self
        mainCarousel.dataSource = self
        mainCarousel.delegate = self
    }
    
    
    func activateConstraint() {
        
        NSLayoutConstraint.activate([
            
            mainCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            mainCarousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            mainCarousel.topAnchor.constraint(equalTo: self.categoryTitleButton.bottomAnchor, constant: 50),
            mainCarousel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -50),
            
            myCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            myCarousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            myCarousel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            myCarousel.heightAnchor.constraint(equalToConstant: 200),
            
            fontCarousel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            fontCarousel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            fontCarousel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -170),
            fontCarousel.heightAnchor.constraint(equalToConstant: 100),
            
            cancelButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            cancelButton.widthAnchor.constraint(equalToConstant: 40),
            cancelButton.heightAnchor.constraint(equalToConstant: 40),
            cancelButton.bottomAnchor.constraint(equalTo: self.fontCarousel.topAnchor, constant: -25)
            
        ])
        
        
    }
    
    func hideView() {
        UIView.transition(with: view, duration: 0.7, options: .transitionCrossDissolve,  animations: { [weak self] in
            self?.fontCarousel.isHidden = true
            self?.myCarousel.isHidden = true
            self?.cancelButton.isHidden = true
            self?.stackView.isHidden = false
        })
        
    }
    
    func showViews() {
        
        let customizeVC = storyboard!.instantiateViewController(withIdentifier: "CustomizeViewController") as! CustomizeViewController
        
        guard let sheet = customizeVC.presentationController as? UISheetPresentationController else {return}
        sheet.detents = [.medium(), .large()]
        //sheet.largestUndimmedDetentIdentifier = .medium
        sheet.preferredCornerRadius = 20
        sheet.prefersGrabberVisible = true
        sheet.largestUndimmedDetentIdentifier = .none
        customizeVC.delegate = self
        present(customizeVC, animated: true)
        
        
        
        
        /*UIView.transition(with: fontCarousel, duration: 0.7, options: .transitionCrossDissolve,  animations: {[weak self] in
         self?.fontCarousel.isHidden = false
         self?.myCarousel.isHidden = false
         self?.cancelButton.isHidden = false
         self?.stackView.isHidden = true
         })
         */
        
        
        
        
    }
    
    
    func showBottomSheetVC(){
        let bottomSheetVC = storyboard!.instantiateViewController(withIdentifier: "BottomSheetViewController") as! BottomSheetViewController
        
        guard let sheet = bottomSheetVC.presentationController as? UISheetPresentationController
        else {return}
        
        if #available(iOS 16.0, *) {
            sheet.detents = [.custom {_ in
                300
            }]
        } else {
            // Fallback on earlier versions
        }
        sheet.preferredCornerRadius = 24
        sheet.prefersGrabberVisible = false
        sheet.largestUndimmedDetentIdentifier = .none
        // sheet.largestUndimmedDetentIdentifier = .medium
        let image = currentCarouselView?.screenshot()
        bottomSheetVC.screenshot = image
        present(bottomSheetVC, animated: true)
    }
    
    func changeLikeBtnImage(state: Bool) {
        if state == true {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: [])
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: [])
        }
        
    }
    
    
    private func showHeart(){
        let imageView = UIImageView(image: UIImage(systemName: "heart.fill"))
        
        let size = mainCarousel.frame.width/4
        imageView.tintColor = .systemRed
        mainCarousel.addSubview(imageView)
        imageView.center = mainCarousel.center
        imageView.frame = CGRect(x: (mainCarousel.frame.width-size)/2,
                                 y: (mainCarousel.frame.height-size)/2, width: size, height: size )
        
        //DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
        UIView.animate(withDuration: 0.5, animations: {
                imageView.alpha = 1
            }) { done in
                if done {
                    UIView.animate(withDuration: 1.5, animations: {
                        imageView.alpha = 0
                    }) { done in
                        if done {
                            imageView.removeFromSuperview()
                        }
                    }
                }
            }
        //})
    }


    func loadToast(){
        let customView = (Bundle.main.loadNibNamed("CustomToastView", owner: self)!.first as? CustomToastView)!
        self.view.showToast(customView, duration: 2.0, position: .center)
  
    }
    
    
    
   //MARK: Buttons
    
    @objc func cancelButtonAction() {
        hideView()
        
    }
    
    
    @IBAction func showChat(_ sender: Any) {
        
        let vc = UIHostingController(rootView: ContentView())
        present(vc, animated: true)
        
        
    }
    
    @IBAction func showCategories()  {
        let vc = storyboard!.instantiateViewController(withIdentifier: "CategoriesCollectionView") as! CategoriesCollectionView
        vc.delegate = self
        let navVC = UINavigationController(rootViewController: vc)
        self.present(navVC, animated: true)
        
        
    }
    
    @IBAction func reloadCards()  {
        //let back = currentIndex-1
        //mainCarousel.scrollToItem(at: back, animated: true)
       
        let vc = storyboard!.instantiateViewController(withIdentifier: "CreateCardViewController") as!
        CreateCardViewController
        let navVC = UINavigationController(rootViewController: vc)
        self.present(navVC, animated: true)
        
    }
    
    
    
    @IBAction func removeCard()  {
       // loadToast()
        let customView = (Bundle.main.loadNibNamed("CustomToastView", owner: self)!.first as? CustomToastView)!
        let width = view.frame.width/1.15
        customView.frame = CGRect(x: 0, y: 0, width: width, height: 250)
        customView.layer.cornerRadius = 20
        customView.textLabel.layer.borderColor = UIColor.white.cgColor
        customView.textLabel.layer.borderWidth = 1
        customView.textLabel.layer.cornerRadius = 10
        self.view.showToast(customView, duration: 4.0, position: .bottom)
        let items = self.category.items//{
        let text = items[currentIndex]
        customView.loadSpeech(text: text)
        
        /*
        let items = self.category.items//{
            let text = items[currentIndex]
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.5
            synthesizer.speak(utterance)
         */
    }
    
    var isSaved = false
    
    @IBAction func likeCard()  {
        let items = self.category.items
        let text = items[currentIndex]
        
        let category = Category(title: category.title, image: category.image,
                                color: category.color, items: [text])
        if DataManager().chekIfSaved(category: category) {
            changeLikeBtnImage(state: false)
            DataManager().removeCategory(category: category)
        } else {
            showHeart()
            changeLikeBtnImage(state: true)
            DataManager().saveCard(category: category)
        }
    }
    
    @IBAction func optionButton()  {
       showViews()
        
    }
    
    
    @IBAction func showCreatedCategoryBtn()  {
        let vc = storyboard!.instantiateViewController(withIdentifier: "ShowCreatedCatViewController") as!
        ShowCreatedCatViewController
        vc.categoryVCDelegate = self
        let navVC = UINavigationController(rootViewController: vc)
        self.present(navVC, animated: true)
        
    }
    
    
    var currentIndex = 0
    
}

//MARK: Category View Controller Delegate
extension HomeViewController: CategoriesVCDelegate {
   
    func onDismiss(category: Category) {
        categoryTitleButton.setTitle(category.title, for: .normal)
        //categoryTitleButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        self.category.items.removeAll()
          self.category = category
          self.mainCarousel.reloadData()
    }
}


//MARK: Customs View Controller Delegate
extension HomeViewController: CustomizeViewControllerDelegate {
    
    func selectedColor(color: UIColor) {
        backgroundColor = color
        mainCarousel.reloadData()
    }
    
    func frameNameString(nameString: String) {
        framesNameString = nameString
        mainCarousel.reloadData()
    }
    
    func fontNameString(nameString: String) {
        fontNameString = nameString
        mainCarousel.reloadData()
    }
    
    
}


//MARK: MyCarousel Delegate

extension HomeViewController: iCarouselDataSource {
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
            
            currentIndex = carousel.currentItemIndex
        let imageView = UIImageView()
        
        let myIndex = 1 + index
        
        if let frameString = category.frame {
            imageView.image = UIImage(named: frameString)
        } else {
            imageView.image = UIImage(named: framesNameString)
        }
        
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            imageView.frame = mainCarousel.frame
             imageView.backgroundColor  = UIColor.secondarySystemBackground
            //imageView.layer.borderColor = UIColor.lightGray.cgColor
            //imageView.layer.borderWidth = 1
            let label = UILabel()
           // label.textColor = .black
            label.textColor = backgroundColor
            //label.tintColor = UIColor.red
            label.numberOfLines = 0
            label.textAlignment = .center
            label.clipsToBounds = true
            //label.shadowColor = UIColor.black
            //label.layer.shadowOpacity = 0.5
            label.sizeToFit()
            label.font = UIFont(name: fontNameString, size: 35)
            imageView.addSubview(label)
            label.frame = CGRect(x: 20, y: 35, width: imageView.frame.size.width - 30, height: 250)
            if let category = category {
                categoryTitleButton.setTitle(category.title, for: .normal)
                label.text = category.items[index]
            }
        
           
            let remainingCard = category.items.count
        
            let infoLbl = UILabel()
            infoLbl.text = "\(myIndex)/\(remainingCard)"
            infoLbl.textColor = backgroundColor//.withAlphaComponent(0.9)
            let frameWidth = imageView.frame.width / 2 - 30
            let height = imageView.frame.size.height - 70
            infoLbl.textAlignment = .center
            infoLbl.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            infoLbl.frame = CGRect(x: frameWidth , y: height, width: 50, height: 50)
            imageView.addSubview(infoLbl)
            infoLbl.layer.cornerRadius = 25
            infoLbl.clipsToBounds = true
        infoLbl.layer.borderColor = backgroundColor.cgColor //UIColor.darkGray.cgColor.copy(alpha: 0.6)
            infoLbl.layer.borderWidth = 2
        currentCarouselView = imageView
        imageView.dropShadow()
        return imageView
        
        
    }
    
    
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
       // if carousel == mainCarousel {
            return category.items.count
    }
    
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
        let items = self.category.items
        let text = items[carousel.currentItemIndex]
        let category = Category(title: category.title, image: category.image,
                                color: category.color, items: [text])
        if DataManager().chekIfSaved(category: category) {
            changeLikeBtnImage(state: true)
        } else {
            changeLikeBtnImage(state: false)
        }
        
        carouselCurrentIndex = carousel.currentItemIndex
        
        guard let currentView = carousel.currentItemView else {return}
        currentCarouselView = currentView//.snapshotView(afterScreenUpdates: true)
        
        if carousel.currentItemIndex == 2 {
            showPaymentOptionsView()
        }

    }
    
    
    func showPaymentOptionsView() {
            let customView = ShowPaymentOptionsView.loadNib()
            let width = view.frame.width/1.15
            let height = view.frame.height/2
            customView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            customView.layer.cornerRadius = 20
        customView.layer.borderWidth = 1.5
        customView.layer.borderColor = UIColor.red.cgColor
            self.view.showToast(customView, duration: 20.0, position: .bottom)
            //mainCarousel.isUserInteractionEnabled = false
    }
    
    func carouselDidScroll(_ carousel: iCarousel) {
      //  carouselCurrentIndex = carousel.currentItemIndex
        
        currentIndex = carousel.currentItemIndex
    }

}


extension HomeViewController: iCarouselDelegate {
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
            
        case .spacing:
            if carousel == myCarousel {
                return value * 2.75
            }
            return value * 2
            
        case .visibleItems: return 3
            
            //case .offsetMultiplier: return 2
        default: return value
        }
        
    }
    
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
        
        let interaction = UIContextMenuInteraction(delegate: self)
        
        //guard let view = carousel.currentItemView else {return}
        carousel.addInteraction(interaction)
        //imageView.addInteraction(interaction)
        // imageView.isUserInteractionEnabled = true
        
        //showBottomSheetVC()
    }
    
    
    func createContextMenu() -> UIMenu {
        let shareAction = UIAction(title: "Message", image: UIImage(systemName: "message.fill")) { [weak self] _ in
            self?.showMessage()
        }
        
        let options = UIAction(title: "More Options", image: UIImage(systemName: "list.bullet.circle")) {[weak self] _ in
            self?.showActivityController()
        }
        
        let saveToPhotos = UIAction(title: "Add To Photos", image: UIImage(systemName: "photo")) { [weak self] _ in
            self?.savePhoto()
        }
        
        return UIMenu(title: "", children: [shareAction, saveToPhotos , options ])
    }
    
    
    
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in
            return self.createContextMenu()
        }
        
        
    }
    
    
    
    //MARK: Delegate
    
    
    
    //MARK: DataSource
    
    
}

extension HomeViewController: MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate {
    
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        
    }
    
    func showMessage() {
        if MFMessageComposeViewController.canSendText() {
            let messageVC = MFMessageComposeViewController()
            messageVC.messageComposeDelegate = self
            messageVC.body = "From DateNight App"
            let screenshot = currentCarouselView?.screenshot()
            guard let image = screenshot, let data = image.pngData() else {return}
            messageVC.addAttachmentData(data, typeIdentifier: "public.data", filename: "image.png")
            self.present(messageVC, animated: true)
        }
    }
    
    func showActivityController() {
        
        guard let image = currentCarouselView?.screenshot() else {return}
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        print("IMAGE \(image)")
       present(activityController, animated: true)
    }
    
    
    func savePhoto() {
        guard let image = currentCarouselView?.screenshot() else {return}
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        
    }
    
}
