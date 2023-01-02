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

struct ColorTheme {
    static let lightColor = UIColor.init("30314B", alpha: 1.0)
    static let lightTeal = UIColor.init("089E97", alpha: 1.0)
    static let mainColor = UIColor.init("e0aaff", alpha: 1.0)

    
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




class HomeViewController: UIViewController {

    
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
    var framesNameString = "border"
    var fontNameString = "Georgia-Bold"
    var backgroundColor = ColorTheme.mainColor
    
    let mainCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
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
        sheet.largestUndimmedDetentIdentifier = .medium
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
    
    
    func changeLikeBtnImage(state: Bool) {
        if state == true {
            likeButton.setImage(UIImage(systemName: "heart.fill"), for: [])
        } else {
            likeButton.setImage(UIImage(systemName: "heart"), for: [])
        }
        
    }
    
    /*
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            hideView()
            
            let location = touch.location(in: view)
            if fontCarousel.frame.contains(location) {
                print("FONTVIEWTAPPED")
            }
        } else {
            print("Remove Views")
        }
        
    }
    */

   //MARK: Buttons
    
    @objc func cancelButtonAction() {
        hideView()
        
    }
   
    @IBAction func showCategories()  {
        let vc = storyboard!.instantiateViewController(withIdentifier: "CategoriesCollectionView") as! CategoriesCollectionView
        vc.delegate = self
        self.present(vc, animated: true)
        
        
    }
    
    @IBAction func reloadCards()  {
        
        
    }
    
    
    
    @IBAction func removeCard()  {
        let items = self.category.items//{
            let text = items[currentIndex]
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            utterance.rate = 0.4
            synthesizer.speak(utterance)
       // }
        
        
    }
    
    var isSaved = false
    
    @IBAction func likeCard()  {
        let items = self.category.items
        let text = items[currentIndex]
        let card = Card(text: text, category: category.title)
        if DataManager().chekIfSaved(card: card) {
            changeLikeBtnImage(state: false)
            DataManager().removeCard(card: card)
        } else {
            changeLikeBtnImage(state: true)
            DataManager().saveCard(card: card)
        }
        
    }
    
    @IBAction func optionButton()  {
       showViews()
        
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
        
       // if carousel == mainCarousel {
            currentIndex = carousel.currentItemIndex
            let imageView = UIImageView(image: UIImage(named: framesNameString))
            imageView.layer.cornerRadius = 20
            imageView.clipsToBounds = true
            imageView.frame = mainCarousel.frame
            imageView.backgroundColor  = backgroundColor
            let label = UILabel()
            label.numberOfLines = 0
            label.textAlignment = .center
            label.clipsToBounds = true
            label.shadowColor = UIColor.darkGray
            label.layer.shadowOpacity = 0.5
            label.sizeToFit()
            label.font = UIFont(name: fontNameString, size: 40)
            imageView.addSubview(label)
            label.frame = CGRect(x: 15, y: 35, width: imageView.frame.width - 20, height: 200)
            if let category = category {
                categoryTitleButton.setTitle(category.title, for: .normal)
                label.text = category.items[index]
            }
            
            return imageView
        
        
    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
       // if carousel == mainCarousel {
            return category.items.count
    }
    
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
        let items = self.category.items
        let text = items[carousel.currentItemIndex]
        let card = Card(text: text, category: category.title)
        if DataManager().chekIfSaved(card: card) {
            changeLikeBtnImage(state: true)
        } else {
            changeLikeBtnImage(state: false)
        }

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
       
    }
    
}



//MARK: Delegate



//MARK: DataSource


extension UIColor {
  
  convenience init(_ hex: String, alpha: CGFloat = 1.0) {
    var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if cString.hasPrefix("#") { cString.removeFirst() }
    
    if cString.count != 6 {
      self.init("ff0000") // return red color for wrong hex input
      return
    }
    
    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: alpha)
  }

}
