//
//  DatabaseManager.swift
//  DateNight
//
//  Created by Wayne Williams on 9/24/23.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
    
    /// Inserts new user to database
    public func insertUser(with user: KonnectUser){
        database.child(user.email).setValue(["name": user.name,
                                             "email": user.email,
                                             "isActive": user.isActive])
    }
    
    public func isUserExists(with email: String, completion: @escaping ((Bool) -> ())) {
        
        database.child(email).observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            
            completion(true)
        }
    }
    
    
}


struct KonnectUser {
    let name: String
    let email: String
    let isActive: Bool
}
