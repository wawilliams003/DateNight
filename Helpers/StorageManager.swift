//
//  StorageManager.swift
//  DateNight
//
//  Created by Wayne Williams on 9/29/23.
//

import Foundation
import FirebaseStorage


final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias uploadPictureCompletion = (Swift.Result<String, Error>) -> Void
    
    ///Upload picture to firebase
    public func uploadProfilePic(with data: Data, fileName: String, completion: @escaping uploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil) { metadata, error in
            guard error == nil else {
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL { url, error in
                guard let url = url else {
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                
                let urlString = url.absoluteString
                print("URL STRING\(urlString)")
                completion(.success(urlString))
                
                
            }
            
            
        }
        
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
    
    public func downloadURL(file path: String, completion: @escaping (Swift.Result<URL, Error>) -> Void) {
        
        let reference = storage.child(path)
        reference.downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadUrl))
                return
                
            }
            
            completion(.success(url))
        }
        
    }
    
}
