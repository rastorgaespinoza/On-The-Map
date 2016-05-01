//
//  Constants.swift
//  On The Map
//
//  Created by Rodrigo Astorga on 01-05-16.
//  Copyright © 2016 Rodrigo Astorga. All rights reserved.
//

import UIKit

struct Constants {
    
    // MARK: UI
    struct UI {
        static let LoginColorTop = UIColor(red: 170/255, green: 114/255, blue: 42/255, alpha: 1.0).CGColor
        static let LoginColorBottom = UIColor(red: 163/255, green: 68/255, blue: 28/255, alpha: 1.0).CGColor
        static let GreyColor = UIColor(red: 0.702, green: 0.863, blue: 0.929, alpha:1.0)
        static let BlueColor = UIColor(red: 0.0, green:0.502, blue:0.839, alpha: 1.0)
        static let lightOrangeColor = UIColor(red: 183/255, green: 147/255, blue: 115/255, alpha: 1.0)
    }
    
    // MARK: Selectors
    struct Selectors {
        static let KeyboardWillShow: Selector = Selector("keyboardWillShow:")
        static let KeyboardWillHide: Selector = Selector("keyboardWillHide:")
        static let KeyboardDidShow: Selector = Selector("keyboardDidShow:")
        static let KeyboardDidHide: Selector = Selector("keyboardDidHide:")
    }
}