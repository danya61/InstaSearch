//
//  Instagram.swift
//  InstaSearch
//
//  Created by Danya on 28.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import Foundation
import Alamofire
import SwiftyJSON

final class InstagramDataManager {
	// MARK: Properties
	typealias JSONDictionary = [String:Any]

	private let _INSTAMEDIA_LINK = "https://api.instagram.com/v1/users/self/media/recent/?access_token="
	private let _INSTAUSERINFO_LINK = "https://api.instagram.com/v1/users/self/?access_token="
	private let _INSTA_CLIENT_ID = "feee5a6efd2e47728c40dc0d731a3093"
	private let _INSTA_REDIRECT_URI = "https://instasearch.eu.auth0.com/login/callback"
	private let _INSTA_CLIENT_SECRET = "c738fe37bbf94fbf9683bf183ee4e23b"
	
	var instamediaLink: String {
		return _INSTAMEDIA_LINK
	}
	var instaClientId: String {
		return _INSTA_CLIENT_ID
	}
	var instaRedirectURL: String {
		return _INSTA_REDIRECT_URI
	}
	var instaClientSecret: String {
		return _INSTA_CLIENT_SECRET
	}
	let instaAuthURL = "https://api.instagram.com/oauth/authorize/"

	fileprivate let persistance = PersistanceService()
	fileprivate var currentUserInfo = InstaUser()
	//  MARK: Functions
	
	// Instagram login function
	
	func parseAfterLoginParameters(token: String, complition: @escaping ((Bool, InstaUser?) -> Void)) {
		currentUserInfo.token = token
		let globalGroup = DispatchGroup()
		globalGroup.enter()
		self.parseUserInfoParameters(with: token, dispatchGroup: globalGroup)
		globalGroup.enter()
		self.parseUserMediaParameters(with: token, dispatchGroup: globalGroup)
		
		globalGroup.notify(queue: .main) {
			print("\n\n finish instagram parse data [complition]")
			self.persistance.instaUser = self.currentUserInfo
			complition(true, self.currentUserInfo)
		}
	}
	
	private func parseUserMediaParameters(with token: String, dispatchGroup: DispatchGroup) {
		let userMediaURL = "\(_INSTAMEDIA_LINK)\(token)"
		Alamofire.request(userMediaURL, method: .get, encoding: JSONEncoding.default)
			.validate()
			.responseJSON { response in
				switch response.result {
				case .success(let result):
					let jsonRes = JSON(result)
					let downloadGroup = DispatchGroup()
					let dataRes = jsonRes["data"]
					var mediaArray = [InstagramMedia]()
					for (_, data) in dataRes {
						downloadGroup.enter()
						mediaArray.append(InstagramMedia.init(with: data))
						downloadGroup.leave()
					}
					downloadGroup.notify(queue: DispatchQueue.main, execute: {
						self.currentUserInfo.media = mediaArray
						dispatchGroup.leave()
					})
				case .failure(let error):
					print("error of parsing Instagram media: \(error)")
				}
			}
	}
	
	private func parseUserInfoParameters(with token: String, dispatchGroup: DispatchGroup) {
		let userInfoURL = "\(_INSTAUSERINFO_LINK)\(token)"
		Alamofire.request(userInfoURL, method: .get, encoding: JSONEncoding.default)
			.validate()
			.responseJSON {response in
				switch response.result {
				case .success(let result):
					let jsonResult = JSON(result)
					let dataJSON = jsonResult["data"]
					self.currentUserInfo.avatar = dataJSON["profile_picture"].stringValue
					self.currentUserInfo.username = dataJSON["username"].stringValue
					dispatchGroup.leave()
				case .failure(let error):
					print("error of parsing instagram info: \(error)")
				}
			}
	}
	
}
	

