//
//  Constants.swift
//  DateNight
//
//  Created by Wayne Williams on 8/26/23.
//

import Foundation
import UIKit


struct Constants {
    
    struct ScreenSize {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.width
    }
    
    var currentUserEmail: String? {
        guard let currentUserEmail =  UserDefaults.standard.value(forKey: "email") as? String else {return nil }
        return currentUserEmail
    }
    
}
