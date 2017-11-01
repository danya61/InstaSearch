//
//  UIColor+HEX.swift
//  InstaSearch
//
//  Created by Danya on 30.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import UIKit
import Foundation

extension UIColor {
	convenience init(hex: String, alpha: CGFloat? = 1.0) {
		var hexInt: UInt32 = 0
		let scanner = Scanner(string: hex)
		scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
		scanner.scanHexInt32(&hexInt)
		
		let red = CGFloat((hexInt & 0xFF0000) >> 16) / 255.0
		let green = CGFloat((hexInt & 0x00FF00) >> 8) / 255.0
		let blue = CGFloat((hexInt & 0x0000FF)) / 255.0
		let alpha = alpha!
		
		self.init(red: red, green: green, blue: blue, alpha: alpha)
	}
}

