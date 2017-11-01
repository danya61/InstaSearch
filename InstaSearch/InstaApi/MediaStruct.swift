//
//  MediaStruct.swift
//  InstaSearch
//
//  Created by Danya on 29.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import Foundation
import SwiftyJSON

class InstagramMedia {
	var standartResolutionImage: UIImage?
	var standartResolutonURL: String
	var photoText: String
	var likesCount: Int
	var commentsCount: Int
	
	init(with json: JSON) {
		let comments = json["comments"]
		self.commentsCount = comments["count"].intValue
		self.photoText = json["caption"]["text"].stringValue
		self.likesCount = json["likes"]["count"].intValue
		self.standartResolutionImage = nil
		let imagePath = json["images"]
		let standartResolutionImage = imagePath["standard_resolution"]
	  standartResolutonURL = standartResolutionImage["url"].stringValue
	}

}
