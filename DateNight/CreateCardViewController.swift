//
//  CreateCardViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 2/26/23.
//

import UIKit

class CreateCardViewController: UIViewController,UICollectionViewDelegateFlowLayout, UITextViewDelegate {

    
    @IBOutlet var categoryCollectionView: UICollectionView!
    //@IBOutlet weak var fontsView: UIView!
    @IBOutlet weak var PhotoFrameView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var wordCountLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var previewTextLbl: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.tintColor = UIColor.white
        self.title = "Create Card"
        closeBtn()
        setupCollectionView()
        miscViews()
       // previewTextLbl.text = "currentText"
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Functions
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {return false}
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        wordCountLbl.text = "\(80 - updatedText.count)"
        previewTextLbl.text = updatedText
        
        return updatedText.count < 80
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
         if textView.textColor == UIColor.white {
             textView.text = nil
             textView.textColor = UIColor.white
        }
     }
     func textViewDidEndEditing(_ textView: UITextView) {
         if textView.text.isEmpty {
             textView.text = "enter text..."
             textView.textColor = UIColor.white
         }
     }
 //}
    
    
    func miscViews(){
        colorView.layer.cornerRadius = 10
        colorView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        colorView.layer.borderWidth = 1
        PhotoFrameView.layer.cornerRadius = 10
        PhotoFrameView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        PhotoFrameView.layer.borderWidth = 1
        textView.layer.cornerRadius = 10
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
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

