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

class HomeViewController: UIViewController {

    
    @IBOutlet weak var kView: KolodaView!
    
    
    //MARK: Properties
    
    let myCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
       // view.contentOffset = CGSize(width: 50, height: 50)
        //view.numberOfVisibleItems = 5
        return view
    }()
    
    let fontCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        
        return view
    }()
    
    //let cards = ["dr", "thor", "ironman", "spider", "avenger"]
    
    let cards = ["Do you believe in love?", "Do you believe in love at first sight?", "Have you ever been in love?", "What is your definition of love?", "Do you love yourself?"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKView()
        
        view.addSubview(myCarousel)
        view.addSubview(fontCarousel)
        fontCarousel.isHidden = true
        myCarousel.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 200)
        fontCarousel.frame = CGRect(x: 0, y: 380, width: view.frame.size.width, height: 100)
        myCarousel.dataSource = self
        myCarousel.delegate = self
        fontCarousel.dataSource = self
        fontCarousel.delegate = self
        
        // Do any additional setup after loading the view.
    }

    func setupKView(){
        kView.delegate = self
        kView.dataSource = self
        kView.layer.cornerRadius = 20
        kView.clipsToBounds = true
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        UIView.transition(with: view, duration: 0.7, options: .transitionCrossDissolve,  animations: { [weak self] in
            self?.fontCarousel.isHidden = true
        })
    }
    

   //MARK: Buttons
   
    @IBAction func showCategories()  {
        let vc = storyboard!.instantiateViewController(withIdentifier: "CategoriesCollectionView") as! CategoriesCollectionView
       // let storyboard = UIStoryboard(name: "CategoriesCollectionView", bundle: nil)
       // let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoriesCollectionView") as! CategoriesCollectionView
        self.present(vc, animated: true)
        
        
    }
    
    @IBAction func reloadCards()  {
        
        
    }
    
    @IBAction func removeCard()  {
        
        
    }
    
    @IBAction func likeCard()  {
        fontCarousel.isHidden = false
        UIView.transition(with: fontCarousel, duration: 0.5, options: .transitionCrossDissolve,  animations: nil)
        
    }
    
    @IBAction func saveCard()  {
        
        
    }
    
}

//MARK: MyCarousel Delegate

extension HomeViewController: iCarouselDataSource {
    
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        if carousel == myCarousel {
            let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/4, height: 150))
            view.backgroundColor = .purple
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1
            view.clipsToBounds = true
            return view
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/4, height: 50))
        let label = UILabel(frame: view.frame)
        view.addSubview(label)
        label.text = "Aa"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20)
        view.backgroundColor = .brown
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
        
    }
    
    
    func numberOfItems(in carousel: iCarousel) -> Int {
        return 8
    }
    
    
    
    
}


extension HomeViewController: iCarouselDelegate {
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
        case .spacing: return value * 1.75
            
        case .visibleItems: return 3
            
        //case .offsetMultiplier: return 2
        default: return value
        }
        
    }
    
//    func carouselItemWidth(_ carousel: iCarousel) -> CGFloat {
//        return 150
//    }
    
}



//MARK: Delegate

extension HomeViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        koloda.resetCurrentCardIndex()
        koloda.reloadData()
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        true
    }
    
}


//MARK: DataSource
extension HomeViewController: KolodaViewDataSource {
    
    func koloda(_ koloda: Koloda.KolodaView, viewForCardAt index: Int) -> UIView {
        let kView = UIImageView(image: UIImage(named: cards[index]))
        let coverView = UIView(frame: CGRect(x: 0, y: 0, width: koloda.frame.width, height: 150))
        coverView.backgroundColor = .black
        coverView.layer.opacity = 0.050
        kView.addSubview(coverView)
        kView.image = UIImage(named: "border")
        kView.backgroundColor = .purple
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.clipsToBounds = true
        label.shadowColor = UIColor.darkGray
        label.layer.shadowOpacity = 0.5
        kView.addSubview(label)
        //label.adjustsFontSizeToFitWidth = true
        label.frame = CGRect(x: 20, y: 35, width: koloda.frame.width-20, height: 200)
        label.text = cards[index]
        kView.layer.cornerRadius = 20
        kView.clipsToBounds = true
        
        return kView
    }
    
    func kolodaNumberOfCards(_ koloda: Koloda.KolodaView) -> Int {
        cards.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
            return .fast
        }
    
    
    
}


