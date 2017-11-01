//
//  InstaPhotoCollectionViewCell.swift
//  InstaSearch
//
//  Created by Danya on 30.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit

final class InstaPhotoCollectionViewCell: UICollectionViewCell {
	
	// MARK: IBOutlets
	@IBOutlet weak var mainImage: UIImageView!
	
	@IBOutlet weak var likesCountLabel: UILabel!
	@IBOutlet weak var commentsCountLabel: UILabel!
	
	@IBOutlet weak var photoTextLabel: UILabel!
	
	// MARK: Functions
	override func awakeFromNib() {
		super.awakeFromNib()
		self.configureCellDesign()
	}
	
	override func prepareForReuse() {
		self.mainImage.image = nil
		super.prepareForReuse()
	}
	
	private func configureCellDesign() {
		self.layer.borderColor = UIColor(hex: "DBDBDB").cgColor
		self.layer.borderWidth = 1.0
		
		self.contentView.layer.cornerRadius = 5.0
		self.contentView.layer.borderWidth = 0.8
		self.contentView.layer.borderColor = UIColor.clear.cgColor
		self.contentView.layer.masksToBounds = true
		
		self.layer.cornerRadius = 5.0
		self.layer.shadowColor = UIColor(hex: "000", alpha: 0.11).cgColor
		self.layer.shadowOffset = CGSize(width: 0, height: 3.0)
		self.layer.shadowRadius = 4.0
		self.layer.shadowOpacity = 1.0
		self.layer.masksToBounds = false
		self.backgroundColor = .white
	}
}
