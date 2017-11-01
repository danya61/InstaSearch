//
//  InstaCellViewModel.swift
//  InstaSearch
//
//  Created by Danya on 31.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import Foundation
import UIKit

struct InstaCellVM: CollectionCellViewModel {
	var likesCount: Int
	var commentsCount: Int
	var currentImage: UIImage
	var descriptionText: String
	
	init(likes: Int, comments: Int, image: UIImage, descriptionText: String) {
		self.likesCount = likes
		self.commentsCount = comments
		self.currentImage = image
		self.descriptionText = descriptionText
	}
	
	
	func configure(cell: InstaPhotoCollectionViewCell) {
		cell.commentsCountLabel.text = "\(commentsCount)"
		cell.likesCountLabel.text = "\(likesCount)"
		cell.mainImage.image = currentImage
		cell.photoTextLabel.text = descriptionText
	}
}
