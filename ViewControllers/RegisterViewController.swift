//
//  RegisterViewController.swift
//  DateNight
//
//  Created by Wayne Williams on 9/21/23.
//

import UIKit
import FirebaseAuth
import FirebaseCore


class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePicImageView: UIImageView!
    
    var selectedImage: UIImage?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        profilePicImageView.layer.cornerRadius = 50//profilePicImageView.frame.size.width/2
        profilePicImageView.clipsToBounds = true
        profilePicImageView.layer.borderColor = UIColor.lightGray.cgColor
        profilePicImageView.layer.borderWidth = 2
        // Do any additional setup after loading the view.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        tapGesture.numberOfTapsRequired = 1
        profilePicImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapProfilePic() {
        
        presentPhotoActionSheet()
    }
    
    
    
    
    
    
    @IBAction func registerBtn() {
        emailTextField.resignFirstResponder()
        nameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        
        
        guard let name = nameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,
              !name.isEmpty,
              !password.isEmpty,
              !email.isEmpty else {
            alertUserLoginError(text: "Please enter all information to create new account")
            return
            
        }
        
        if passwordTextField.text!.count <= 6 {
            alertUserLoginError(text: "Password must be more than 6 characters")
            return
        }
        
        // USER Account
        DatabaseManager.shared.isUserExists(with: email) { [weak self] exists in
            guard !exists else {
                // user alredy exists
                self?.alertUserLoginError(text: "User account for that email already exists")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] AuthResult, error in
                guard AuthResult != nil, error == nil else {
                    print("Error Creating User\(String(describing: error?.localizedDescription))")
                    return
                }
                
                let user = KonnectUser(name: name, email: email, isActive: false)
                UserDefaults.standard.set(name, forKey: "name")

                
                DatabaseManager.shared.insertUser(with: user, completion: { success in
                    if success {
                        guard let image = self?.profilePicImageView.image, let data = image.pngData() else {
                            
                            return
                        }
                        
                        let filename = user.profilePictureFileName
                        StorageManager.shared.uploadProfilePic(with: data, fileName: filename) { result in
                            switch result {
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage Maanger Error \(error)")
                            }
                        }
                      
                        
                        
                    }
                })
                
                
               
            }
        }
        
        
      
        
    }
    
    
    func alertUserLoginError(text: String) {
        let alert = UIAlertController(title: "", message: text, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        present(alert, animated: true)
    }

    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
        
    }
    
    func presentCamera() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    func presentPhotoPicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
        
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

extension RegisterViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let selectedImage_ = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        //self.selectedImage = slectedImage_
        self.profilePicImageView.image = selectedImage_
        picker.dismiss(animated: true)
    }
    
}
