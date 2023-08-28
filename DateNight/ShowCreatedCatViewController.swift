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
        
        let category = createdCategories[indexPath.row]
        cell.category = category
        cell.likesCount.text = "\(category.items.count)"
        
       // cell.dropShadow()
        
        return cell
        
    }
    
    /*
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = createdCategories[indexPath.row]
        categoryVCDelegate?.onDismiss(category: category)
        dismiss(animated: true)
    }
    */
        
        
     func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ShowCreatedCatCell else {return}
      //  guard let topCell = collectionView.cellForItem(at: indexPath) as? TopSpeakersCollecViewCell else {return}
        
        UIView.animate(withDuration: 0.3) {
            cell.transform = .init(scaleX: 0.95, y: 0.95)
        } completion: { (done) in
            if done {
                UIView.animate(withDuration: 0.1) {
                    cell.transform = .identity
                } completion: { [ weak self](done) in
                    if done {
                        guard let category = self?.createdCategories[indexPath.row] else {return}
                        self?.categoryVCDelegate?.onDismiss(category: category)
                        self?.dismiss(animated: true)
                    }
                }
            }
        }

    }
    
}
