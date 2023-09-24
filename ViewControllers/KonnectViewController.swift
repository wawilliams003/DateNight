//
//  KonnectViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/24/23.
//

import UIKit

class KonnectViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        barbuttons()
        // Do any additional setup after loading the view.
    }
    
    
    func barbuttons() {
        let leftBtn = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(leftBtnAction))
        self.navigationItem.leftBarButtonItem = leftBtn
        let rightBtn = UIBarButtonItem(title: "Register", image: nil, target: self, action: #selector(rightBtnAction))
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    @objc func leftBtnAction() {
        dismiss(animated: true)
    }

    
    @objc func rightBtnAction() {
        let vc = storyboard!.instantiateViewController(withIdentifier: "RegisterViewController") as!
        RegisterViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
