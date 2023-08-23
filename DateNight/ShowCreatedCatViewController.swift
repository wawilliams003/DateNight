//
//  ShowCreatedCatViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 4/23/23.
//




import UIKit

class ShowCreatedCatViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var upgradeView: UIView!
    
    var createdCategories = [Category]()
    
    var userCreatedCategories = [[Category]]()
    var categoryVCDelegate: CategoriesVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createdCategories = DataManager().fetchCreatedCategories()
        //userCreatedCategories = DataManager().fetchUserCreatedCategories()
        //print("USER CREATED \(userCreatedCategories.count)")
        collectionView.reloadData()
        closeBtn()
        setupCollectionView()
        
        upgradeView.layer.cornerRadius = 8
        // Do any additional setup after loading the view.
    }
    
    
    func closeBtn() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBtnAction))
    }
    
    
   @objc func closeBtnAction () {
       dismiss(animated: true)
    }
    
    

    func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let width = collectionView.frame.size.width / 2-8
            //let height = collectionView.frame.size.width / 2
            flowLayout.itemSize = CGSize(width: width, height: width)
            flowLayout.scrollDirection = .vertical
            flowLayout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            flowLayout.minimumLineSpacing = 5
        }
        
    }

}


extension ShowCreatedCatViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return createdCategories.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ShowCreatedCatCell
        
        cell.category = createdCategories[indexPath.row]
       // cell.dropShadow()
        
        return cell
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = createdCategories[indexPath.row]
        categoryVCDelegate?.onDismiss(category: category)
        dismiss(animated: true)
    }
    
    
}
