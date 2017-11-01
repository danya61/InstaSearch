//
//  InstagramGradient.swift
//  InstaSearch
//
//  Created by Danya on 31.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import UIKit
import Foundation

extension CAGradientLayer {
	func makeInstagramGradient(bounds: CGRect) -> CAGradientLayer {
		self.frame = bounds
		self.colors = [
			UIColor(red: 48/255, green: 62/255, blue: 103/255, alpha: 1).cgColor,
			UIColor(red: 244/255, green: 88/255, blue: 53/255, alpha: 1).cgColor
		]
		self.startPoint = CGPoint(x:0, y:0)
		self.endPoint = CGPoint(x:1, y:1)
		return self
	}
}
