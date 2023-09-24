//
//  LogInViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/21/23.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!

    
    
    
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
    
    func alertUserLoginError(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }
    
    @IBAction func loginBtn() {
        emailTextfield.resignFirstResponder()
        passwordTextfield.resignFirstResponder()
        
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
            alertUserLoginError(text: "Please enter all information to log in.")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            guard let result = authResult, error == nil else {
                print("ERROR LON IN USER")
                return
            }
            
            print("LOG IN SUCCESS \(result.user.displayName)")
            
        }
        
        
        
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
