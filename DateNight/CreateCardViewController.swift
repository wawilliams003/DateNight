//
//  CreateCardViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 2/26/23.
//

import UIKit

class CreateCardViewController: UIViewController,UICollectionViewDelegateFlowLayout {

    
    @IBOutlet var categoryCollectionView: UICollectionView!
    //@IBOutlet weak var fontsView: UIView!
    @IBOutlet weak var PhotoFrameView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var textView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Create Card"
        closeBtn()
        setupCollectionView()
        miscViews()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Functions
    
    func miscViews(){
        colorView.layer.cornerRadius = 10
        colorView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        colorView.layer.borderWidth = 1
        PhotoFrameView.layer.cornerRadius = 10
        PhotoFrameView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        PhotoFrameView.layer.borderWidth = 1
        
    }

    func closeBtn() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(dismissVC))
        
    }
    
   @objc func dismissVC(){
       self.dismiss(animated: true)
        
        
    }

    
    func setupCollectionView() {
        if let flowLayout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = CGSize(width: 150, height: 40)
            flowLayout.scrollDirection = .horizontal
            flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        
    }
    
    @IBAction func colorPickerBtn(_ sender: Any) {
        
        
        
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        
        
    }
    
    
}





extension CreateCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        cell.layer.cornerRadius = 20
        
        
        return cell
    }
    
    
    
    
    
    
}


extension CreateCardViewController: UICollectionViewDelegate {
    
    

}

