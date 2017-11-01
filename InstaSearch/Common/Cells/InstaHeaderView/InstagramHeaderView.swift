//
//  InstagramHeaderView.swift
//  InstaSearch
//
//  Created by Danya on 30.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import UIKit
import Foundation

class InstagramHeaderView: UICollectionReusableView {
	
	// MARK: IBOutlets & variables
	
	@IBOutlet weak var usernameLabel: UILabel!
	@IBOutlet weak var circleImageView: CircleImageView!
	
	fileprivate var userImagePath: String = "" 
	fileprivate var username: String = ""
	
//	fileprivate lazy var usernameLabel: UILabel! = {
//		return UILabel()
//	}()
//	fileprivate lazy var circleImageView: CircleImageView = {
//		return CircleImageView()
//	}()
	
	// MARK: Functions
//	override init(frame: CGRect) {
//		self.userImagePath = ""
//		self.username = ""
//		super.init(frame: frame)
//	}
//
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.username = ""
		self.userImagePath = ""
	}
	
	func configure(imagePath: String, username: String) {
		self.userImagePath = imagePath
		self.username = username
		self.initialize()
	}
	
	override func prepareForReuse() {
	//	self.usernameLabel = UILabel()
		super.prepareForReuse()
	}
	
	private func initialize() {
		self.backgroundColor = .clear
		ImageLoader.load(with: userImagePath) { outputImage in
			self.circleImageView.image = outputImage

			self.usernameLabel.text = self.username
			self.usernameLabel.textAlignment = .center
			self.usernameLabel.textColor = .white
		}
	}
	
}
