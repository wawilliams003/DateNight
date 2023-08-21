//
//  String+Extension.swift
//  DateNight
//
//  Created by Wayne Williams on 8/11/23.
//

import Foundation

extension String {
    
    var isEmptyOrWhiteSpace: Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
