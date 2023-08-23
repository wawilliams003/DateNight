//
//  CategoriesCollectionView.swift
//  DateNight
//
//  Created by Wayne Williams on 12/13/22.
//

import UIKit

private let reuseIdentifier = "Cell"


protocol CategoriesVCDelegate {
    func onDismiss(category: Category)
}




class CategoriesCollectionView: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    //MARK: Properties
    
    var categories = [Category]()
    var onCategoryVCDismissed: (() -> ())?
    var delegate: CategoriesVCDelegate?
    var favorites = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FetchData.parseJSON { [weak self] categories in
            self?.categories = categories
            self?.favorites = DataManager().fetchFavorites()
            self?.collectionView.reloadData()
        }
        
        setupCollectiobView()
        
        closeBtn()

    }
    
    
    
    //MARK: Helper Functions
    
    fileprivate func setupCollectiobView() {
        if let flowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 20
            // flowLayout.minimumInteritemSpacing = 15
            flowLayout.itemSize = CGSize(width: (view.frame.size.width/2)-30,
                                         height: 170)
            flowLayout.sectionInset = UIEdgeInsets(top: 15, left: 20, bottom: 5, right: 20)
            //flowLayout.headerReferenceSize =  CGSize(width: view.frame.size.width, height: 100)
        }
        
        let nib = UINib(nibName: "HeaderCollectionReusableView", bundle: nil)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        let favsNib = UINib(nibName: "FavoritesCollectionReusableView", bundle: nil)
        collectionView.register(favsNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: FavoritesCollectionReusableView.identifier)
    }
    
    func closeBtn() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeBtnAction))
    }
    
    
   @objc func closeBtnAction () {
       dismiss(animated: true)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return (section == 0) ? categories.count : favorites.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
            
            cell.categories = categories[indexPath.row]
            cell.dropShadow()
            // Configure the cell
            
            return cell
        } else {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
            
            //let categories =
            cell.categories = favorites[indexPath.row]
            cell.dropShadow()
            return cell
        }
    }
    
    
    

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
        return UICollectionReusableView()
        }
        
        if indexPath.section == 0 {
            let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.identifier, for: indexPath)
            return header
            
        }
        
        let header =  collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: FavoritesCollectionReusableView.identifier, for: indexPath)
        return header
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {

        return CGSize(width: view.frame.size.width, height: 80)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let category = categories[indexPath.row]
            delegate?.onDismiss(category: category)
            self.dismiss(animated: true)
        } else {
                let category = favorites[indexPath.row]
                delegate?.onDismiss(category: category)
                self.dismiss(animated: true)
            
        }
        }
        
        
    
    
    
    /*
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.size.width / 2, height: self.view.frame.size.width / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumLineSpacingForSectionAt section: Int) -> CGFloat {
          return 5
      }

      func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
          return 5
      }
    
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
