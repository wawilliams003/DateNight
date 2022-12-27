//
//  Extensions.swift
//  DateNight
//
//  Created by Wayne Williams on 12/24/22.
//

import Foundation
import UIKit

extension UIView {
  func screenshot() -> UIImage {
    return UIGraphicsImageRenderer(size: bounds.size).image { _ in
      drawHierarchy(in: CGRect(origin: .zero, size: bounds.size), afterScreenUpdates: true)
    }
  }

}
