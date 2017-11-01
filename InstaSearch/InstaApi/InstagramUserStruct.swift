//
//  InstagramUserStruct.swift
//  InstaSearch
//
//  Created by Danya on 28.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import Foundation

class InstaUser: NSObject, NSCoding {
	
	var token: String
	var media: [InstagramMedia]
	var username: String
	var avatar: String
	
	init(token: String, uid: String, media: [InstagramMedia], username: String, avatar: String) {
		self.avatar = avatar
		self.username = username
		self.media = media
		self.token = token
	}
	
	override init() {
		self.token = ""
		self.media = [InstagramMedia]()
		self.username = ""
		self.avatar = ""
		super.init()
	}
	
	func encode(with aCoder: NSCoder) {
		aCoder.encode(token, forKey: "token")
		aCoder.encode([InstagramMedia](), forKey: "media")
		aCoder.encode(username, forKey: "username")
		aCoder.encode(avatar, forKey: "avatar")
	}
	
	required init?(coder aDecoder: NSCoder) {
		self.media = aDecoder.decodeObject(forKey: "media") as! [InstagramMedia]
		self.token = aDecoder.decodeObject(forKey: "token") as! String
		self.username = aDecoder.decodeObject(forKey: "username") as! String
		self.avatar = aDecoder.decodeObject(forKey: "avatar") as! String
	}
	
}
