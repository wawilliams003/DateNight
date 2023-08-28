//
//  PaymentViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 8/26/23.
//

import UIKit


struct PaymentInfoModel {
    let labe1, label2, label3, label4 : String
    let purchaseType: String
    
    static func paymentInfoData() ->[PaymentInfoModel] {
        
        var data = [PaymentInfoModel]()
        
        let basicInfo = PaymentInfoModel(labe1: "View all cards", label2: "Save cards to photo library", label3: "Customize cards ", label4: "Share cards", purchaseType: "BASIC")
        
        let premiumInfo = PaymentInfoModel(labe1: "All basic features", label2: "View cards you’ve created", label3: "Play audio ", label4: "Need OPtions", purchaseType: "Premium")
        
        data.append(basicInfo)
        data.append(premiumInfo)
        
        return data
    }
}



class PaymentViewController: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var popularView: UIView!
    @IBOutlet weak var basicView: UIView!
    
    
    
    var isSelected = true
    
    var model = [PaymentInfoModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        model = PaymentInfoModel.paymentInfoData()
        collectionView.reloadData()
        viewProperties()
        collectionViewLayout()
        // Do any additional setup after loading the view.
        
        //let layout = UICollectionViewLayout().coll
    }
    
    
    func viewProperties() {
        popularView.layer.borderColor = UIColor.systemRed.cgColor
        popularView.layer.borderWidth = 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(basicViewAction))
        tapGesture.numberOfTapsRequired = 1
        basicView.addGestureRecognizer(tapGesture)
        
        let tapGesture_ = UITapGestureRecognizer(target: self, action: #selector(popularViewAction))
        tapGesture_.numberOfTapsRequired = 1
        popularView.addGestureRecognizer(tapGesture_)
       
    }
    
    func collectionViewLayout() {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let height = collectionView.frame.height
            let width = collectionView.frame.width
            layout.itemSize = CGSize(width: width - 20, height: height - 10)
            //layout.minimumLineSpacing = 5
            layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
    }
    
    
    @objc func basicViewAction(){
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.popularView.layer.borderColor = self!.isSelected ? UIColor.clear.cgColor : UIColor.red.cgColor
            //popularView.backgroundColor = isSelected ? UIColor.red.withAlphaComponent(0.4) : UIColor.clear
            //popularView.layer.borderWidth = 2
            self?.basicView.layer.borderColor = UIColor.systemRed.cgColor
            self?.basicView.layer.borderWidth = 2
            self?.isSelected = false
            self?.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .right, animated: true)
            //self?.collectionView.reloadData()
        })
       
        
        
    }
    
    
    
    @objc func popularViewAction(){
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            self?.basicView.layer.borderColor = self!.isSelected ? UIColor.red.cgColor : UIColor.clear.cgColor
            self?.popularView.layer.borderColor = UIColor.systemRed.cgColor
            self?.isSelected = true
            self?.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .right, animated: true)

        })
    }
    
    
    @IBAction func popularBtn(){
        
        
    }
    
    
    @IBAction func basicBtn(){
        

    }
    
    
    @IBAction func closeBtn(){
        dismiss(animated: true)

    }

}

extension PaymentViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! PurchaseInfoCollectionViewCell
        let model = model[indexPath.row]
        cell.model = model
        
        return cell
    }
    
    
    
    
    
}

