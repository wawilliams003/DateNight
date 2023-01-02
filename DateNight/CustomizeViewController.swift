//
//  CustomizeViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 1/1/23.
//

import UIKit
import iCarousel


protocol CustomizeViewControllerDelegate {
    func frameNameString(nameString: String)
    func fontNameString(nameString: String)
    func selectedColor(color: UIColor)
}






class CustomizeViewController: UIViewController {

    
    @IBOutlet weak var fontsView: UIView!
    @IBOutlet weak var PhotoFrameView: UIView!
    @IBOutlet weak var colorView: UIView!
    
    //MARK: Properties
    
    var delegate: CustomizeViewControllerDelegate?
    var framesNameString: String?
    var fontNameString: String?
    var selectedColor:  UIColor?
    
    let framesCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let fontCarousel: iCarousel = {
        let view = iCarousel()
        view.type = .rotary
        view.scrollSpeed = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    let fonts = ["AmericanTypewriter-CondensedLight","Avenir-HeavyOblique",
                 "AvenirNext-Italic", "ChalkboardSE-Regular", "HelveticaNeue-CondensedBlack", "HelveticaNeue-Italic", "ChalkboardSE-Bold","AcademyEngravedLetPlain"]
    let frames = ["birthday", "border", "christmas", "merry-christmas"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    @IBAction func selectColor() {
        
        let colorPickerVC = UIColorPickerViewController()
        //pickerVC.delegate = self
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
        
        
        
    }
    
    
    
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if framesNameString != nil {
            delegate?.frameNameString(nameString: framesNameString ?? "")
        }
       
        if fontNameString != nil {
            delegate?.fontNameString(nameString: fontNameString ?? "")
        }
        
       // guard (selectedColor != nil) else {return}
        
        if selectedColor != nil {
            delegate?.selectedColor(color: selectedColor ?? UIColor())
        }
        
    }
    
    
    func setupView() {
        
        view.addSubview(framesCarousel)
        view.addSubview(fontCarousel)
        fontCarousel.delegate = self
        fontCarousel.dataSource = self
        framesCarousel.delegate = self
        framesCarousel.dataSource = self
        
       // fontCarousel.frame = CGRect(x: 0, y: fontsView.center.y, width: fontsView.frame.size.width - 10, height: 60)
        
        
        activateConstraints()
        
        
        fontsView.layer.cornerRadius = 10
        fontsView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        fontsView.layer.borderWidth = 1
        PhotoFrameView.layer.cornerRadius = 10
        PhotoFrameView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        PhotoFrameView.layer.borderWidth = 1
        colorView.layer.cornerRadius = 10
        colorView.layer.borderColor = UIColor(white: 1, alpha: 0.3).cgColor
        colorView.layer.borderWidth = 1
        
    }
    
    
    
    func activateConstraints() {
        
        NSLayoutConstraint.activate([
            
            fontCarousel.leadingAnchor.constraint(equalTo: fontsView.leadingAnchor, constant: 10),
            fontCarousel.trailingAnchor.constraint(equalTo: fontsView.trailingAnchor, constant: -10),
            fontCarousel.topAnchor.constraint(equalTo: fontsView.topAnchor, constant: 10),
            fontCarousel.bottomAnchor.constraint(equalTo: fontsView.bottomAnchor, constant: -10),
            
            framesCarousel.leadingAnchor.constraint(equalTo: PhotoFrameView.leadingAnchor, constant: 10),
            framesCarousel.trailingAnchor.constraint(equalTo: PhotoFrameView.trailingAnchor, constant: -10),
            framesCarousel.topAnchor.constraint(equalTo: PhotoFrameView.topAnchor, constant: 10),
            framesCarousel.bottomAnchor.constraint(equalTo: PhotoFrameView.bottomAnchor, constant: -10),

            
        
        
        ])
        
        
        
    }
    
    
    

    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//MARK: Carousel Delegates

extension CustomizeViewController: iCarouselDataSource {
    func numberOfItems(in carousel: iCarousel) -> Int {
       
        if carousel == framesCarousel {
            return frames.count
        }
        return fonts.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        
        if carousel == framesCarousel {
           // carouselCurrentIndex = carousel.currentItemIndex
            let view = UIImageView(image: UIImage(named: frames[index]))
            view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width/4, height: 150)
            view.backgroundColor = .purple
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor.white.cgColor
            view.layer.borderWidth = 1
            view.clipsToBounds = true
            return view
        }
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.fontsView.frame.size.width/4, height: 70))
        let label = UILabel(frame: view.frame)
        view.addSubview(label)
        label.text = "Aa"
        label.textAlignment = .center
        label.font = UIFont(name: fonts[index], size: 30)
        //label.font = UIFont.systemFont(ofSize: 30, weight: .semibold)
        view.backgroundColor = ColorTheme.lightColor
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        return view
    }
    
    func carouselDidEndScrollingAnimation(_ carousel: iCarousel) {
        
    }
    
    
    func carouselDidScroll(_ carousel: iCarousel) {
        if carousel == framesCarousel {
            let name = frames[carousel.currentItemIndex]
            framesNameString = name
        } else {
            let name = fonts[carousel.currentItemIndex]
            fontNameString = name
        }
    }
}



extension CustomizeViewController: iCarouselDelegate {
    
    func carousel(_ carousel: iCarousel, valueFor option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch option {
            
        case .spacing:
            if carousel == framesCarousel {
                return value * 2.9
            }
            return value * 1.8
            
        case .visibleItems: return 3
            
        //case .offsetMultiplier: return 2
        default: return value
        }
        
    }
    
    
    func carousel(_ carousel: iCarousel, didSelectItemAt index: Int) {
       
    }
    
}


extension CustomizeViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        let color = viewController.selectedColor
        colorView.backgroundColor = color
        selectedColor = color
    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        colorView.backgroundColor = color
        selectedColor = color
    }
}
