//
//  LogInViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/21/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore

class LogInViewController: UIViewController {

    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signInButton: GIDSignInButton!
    //private let googleLogInButton = GIDSignInButton()
    
    
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
    
    func googleSignIn() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] result, error in
          guard error == nil else {
              print("Failure to sign in with google")
              return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            
            Auth.auth().signIn(with: credential) { result, error in
                print("SUCCESS SIGNING IN USER")
              // At this point, our user is signed in
            }
          
        }
        
        
        
    }
    
    @IBAction func addGoogleSignInButtton() {
        googleSignIn()
        
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
            
            let user = result.user
            UserDefaults.standard.set(email, forKey: "email")
            
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
