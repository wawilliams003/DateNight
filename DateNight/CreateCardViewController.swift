//
//  CreateCardViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 2/26/23.
//

import UIKit
import iCarousel

class CreateCardViewController: UIViewController,UICollectionViewDelegateFlowLayout, UITextViewDelegate {

    
    @IBOutlet var categoryCollectionView: UICollectionView!
    //@IBOutlet weak var fontsView: UIView!
    @IBOutlet weak var PhotoFrameView: UIView!
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var wordCountLbl: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var previewTextLbl: UILabel!
    @IBOutlet weak var previewContentView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    
    let categories = ["Love", "Health", "Life", "Goals"]
    let frames = ["frame1", "frame2", "frame3", "frame4"]
    var framesNameString: String?
    var selectedColor: UIColor?
    
    let framesCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        textView.delegate = self
        textView.tintColor = UIColor.white
        self.title = "CREATE CARD"
        view.addSubview(framesCarousel)
        framesCarousel.delegate = self
        framesCarousel.dataSource = self
        previewContentView.clipsToBounds = true
        previewContentView.layer.cornerRadius = 10
        activateConstraints()
        closeBtn()
        
        miscViews()
       // previewTextLbl.text = "currentText"
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Helper Functions
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            framesCarousel.leadingAnchor.constraint(equalTo: PhotoFrameView.leadingAnchor, constant: 10),
            framesCarousel.trailingAnchor.constraint(equalTo: PhotoFrameView.trailingAnchor, constant: -10),
            framesCarousel.topAnchor.constraint(equalTo: PhotoFrameView.topAnchor, constant: 10),
            framesCarousel.bottomAnchor.constraint(equalTo: PhotoFrameView.bottomAnchor, constant: -10),
        ])
    }
    
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
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
        
        
    }
    
    @IBAction func doneBtn(_ sender: Any) {
        
        
        
    }
    
    
}





extension CreateCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
       //cell.categoryLbl.text = "LOVE"
        //cell.backgroundColor = .red
        cell.topicLbl.text = categories[indexPath.row]
        return cell
    }
    
    
    
    
    
}


extension CreateCardViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)

        
    }

}

//MARK: Carousel Delegates

extension CreateCardViewController: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
       
        //if carousel == framesCarousel {
            return frames.count
        
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
       // if carousel == framesCarousel {
           // carouselCurrentIndex = carousel.currentItemIndex
            let view = UIImageView(image: UIImage(named: frames[index]))
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/3.5, height: 150)
            view.backgroundColor = .white
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1
            view.clipsToBounds = true
            return view
       // }
        
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
    }
    
    
    func carouselDidScroll(_ carousel: iCarousel) {
       // if carousel == framesCarousel {
            let name = frames[carousel.currentItemIndex]
           // framesNameString = name
        previewImage.image = UIImage(named: name)
       
    }
}



extension CreateCardViewController: iCarouselDelegate {
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
            
        case .spacing:
           // if carousel == framesCarousel {
                return value * 2.9
            //}
           // return value * 1.8
        case .visibleItems: return 3
            
        //case .offsetMultiplier: return 2
        default: return value
        }
        
    }
    
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
       
    }
    
}


extension CreateCardViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        let color = viewController.selectedColor
        colorView.backgroundColor = color
        selectedColor = color
        previewContentView.backgroundColor = color
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorView.backgroundColor = color
        selectedColor = color
        previewContentView.backgroundColor = color
    }
}

