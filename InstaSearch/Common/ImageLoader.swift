//
//  ImageLoader.swift
//  InstaSearch
//
//  Created by Danya on 30.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import Foundation
import Alamofire
import AlamofireImage

class ImageLoader {
	
	class func load(with string: String, completion: @escaping (_ image: UIImage) -> Void) {
		guard let url = URL(string: string) else { return }
		ImageLoader.load(with: url) { image in
			completion(image)
		}
	}
	
	class func load(with url: URL, completion: @escaping (_ image: UIImage) -> Void) {
		let downloader = ImageDownloader.default
		let request = URLRequest(url: url)
		downloader.download(request) { response in
			switch response.result {
			case .success(let image):
				completion(image)
			case .failure(let error):
				NSLog("[ImageDownloader]: Loading Failure: \(error.localizedDescription)")
			}
		}
	}
	
}
