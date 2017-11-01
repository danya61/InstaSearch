//
//  CircleImageView.swift
//  InstaSearch
//
//  Created by Danya on 30.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import UIKit
import Foundation

final class CircleImageView: UIImageView {
	
 var roundness: CGFloat = 2 {
		didSet{
			setNeedsLayout()
		}
	}
	
 var borderWidth: CGFloat = 5 {
		didSet{
			setNeedsLayout()
		}
	}
	
 var borderColor: UIColor = UIColor.blue {
		didSet{
			setNeedsLayout()
		}
	}
	
	var background: UIColor = UIColor.clear {
		didSet{
			setNeedsLayout()
		}
	}
	
	init(imageSize: CGFloat = 90, borderWidth:CGFloat = 4, roundess: CGFloat = 2,
	     borderColor:UIColor = UIColor.blue.withAlphaComponent(0.8), background: UIColor = UIColor.clear) {
		self.roundness = roundess
		self.borderWidth = borderWidth
		self.borderColor = borderColor
		self.background = background
		super.init(frame: CGRect(x: 0, y: 0, width: imageSize, height: imageSize))
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override public func layoutSubviews() {
		super.layoutSubviews()
		
		layer.cornerRadius = bounds.width / roundness
		layer.borderWidth = borderWidth
		layer.borderColor = borderColor.cgColor
		layer.backgroundColor = background.cgColor
		clipsToBounds = true
		
		let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: bounds.width / roundness)
		let mask = CAShapeLayer()
		
		mask.path = path.cgPath
		layer.mask = mask
	}
}
