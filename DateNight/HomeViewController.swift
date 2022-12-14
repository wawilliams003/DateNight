//
//  ViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 12/13/22.
//

import UIKit
import Koloda
import LGButton

class HomeViewController: UIViewController {

    
    @IBOutlet weak var kView: KolodaView!
    
    
    
    let cards = ["dr", "thor", "ironman", "spider", "avenger"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupKView()
        
        // Do any additional setup after loading the view.
    }

    func setupKView(){
        kView.delegate = self
        kView.dataSource = self
        kView.layer.cornerRadius = 20
        kView.clipsToBounds = true
        
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
        
        
    }
    
    @IBAction func saveCard()  {
        
        
    }
    
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


