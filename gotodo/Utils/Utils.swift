//
//  Utils.swift
//  gotodo
//
//  Created by aisenur on 24.03.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import UIKit

class Utils {
    static func statusBarColorOptions(color hexString: String) {
       if #available(iOS 13, *) {
           let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
           statusBar.backgroundColor = UIColor(hexString: hexString)
           UIApplication.shared.keyWindow?.addSubview(statusBar)
       } else {
          let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
          if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
             statusBar.backgroundColor = UIColor(hexString: hexString)
          }
       }
    }
}
