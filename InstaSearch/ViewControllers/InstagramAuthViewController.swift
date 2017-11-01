//
//  InstagramAuthViewController.swift
//  InstaSearch
//
//  Created by Danya on 29.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit

final class InstagramAuthViewController: UIViewController {

	//  MARK: Properties & Outlets
	fileprivate lazy var instagramDataManager: InstagramDataManager = {
		return InstagramDataManager()
	}()
	
	@IBOutlet weak var loginWebView: UIWebView! {
		didSet {
			loginWebView.delegate = self
		}
	}
	
	//  MARK: Functions

	override func viewDidLoad() {
		super.viewDidLoad()
		self.configureAuth()
	}
	
	private func configureAuth() {
		let authURL = String.init(format: "%@?client_id=%@&redirect_uri=%@&response_type=token&DEBUG=True",
		                          arguments: [instagramDataManager.instaAuthURL,
		                                      instagramDataManager.instaClientId,
		                                      instagramDataManager.instaRedirectURL])
		let urlRequest = URLRequest(url: URL(string: authURL)!)
		loginWebView.loadRequest(urlRequest)
	}
	
	fileprivate func checkRequestForCallbackURL(request: URLRequest) -> Bool {
		let requestURLString = (request.url?.absoluteString)! as String
		if requestURLString.hasPrefix(instagramDataManager.instaRedirectURL) {
			let range: Range<String.Index> = requestURLString.range(of: "#access_token=")!
			let token = requestURLString.substring(from: range.upperBound)
			instagramDataManager.parseAfterLoginParameters(token: token, complition: { (isSuccess, userData) in
				guard isSuccess else { print("failed instagram authorize"); return }
				guard userData != nil else {print("failed. UserData = nil"); return }
				loginToInstgram = true
				self.presentcollectionController(with: userData!)
			})
			return false
		}
		return true
	}
	
	private func presentcollectionController(with userData: InstaUser) {
		let VC = self.storyboard?.instantiateViewController(withIdentifier:
																												String.init(describing: InstaPhotosViewController.self)) as! InstaPhotosViewController
		VC.currentUserData = userData
		let navVC = UINavigationController.init(rootViewController: VC)
		self.present(navVC, animated: true, completion: nil)
	}
	
}

extension InstagramAuthViewController: UIWebViewDelegate {
	func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
		return checkRequestForCallbackURL(request: request)
	}

	func webViewDidStartLoad(_ webView: UIWebView) {
		print("start load instagram auth")
	}
	
	func webViewDidFinishLoad(_ webView: UIWebView) {
		print("finish load instagram auth")
	}
	
	func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
		webViewDidFinishLoad(webView)
	}
}
