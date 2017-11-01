//
//  InstaPhotosViewController.swift
//  InstaSearch
//
//  Created by Danya on 30.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import UIKit

final class InstaPhotosViewController: UIViewController {

	// MARK: IBOutlets
	@IBOutlet weak var collectionView: UICollectionView! {
		willSet(collectionViewT) {
			collectionViewT.delegate = self
			collectionViewT.dataSource = self
			collectionViewT.registerReusableCell(InstaPhotoCollectionViewCell.self)
			collectionViewT.registerSupplementaryView(InstagramHeaderView.self,
			                                          kind: UICollectionElementKindSectionHeader)
			let gradient = CAGradientLayer().makeInstagramGradient(bounds: CGRect.init(x: 0,
			                                                                           y: 0,
			                                                                           width: collectionViewT.frame.height * 3 / 2,
			                                                                           height: collectionViewT.frame.height * 3 / 2))
			let localView = UIView()
			localView.layer.addSublayer(gradient)
			collectionViewT.backgroundView = localView
		}
	}
	
	// MARK: Properties
	fileprivate var refreshControl: UIRefreshControl!
	fileprivate var activityIndicator: UIActivityIndicatorView! {
		didSet {
			activityIndicator.hidesWhenStopped = true
			self.activityIndicator.activityIndicatorViewStyle = .white
		}
	}
	fileprivate var startIndexLoading: Int = 0
	fileprivate var inDownloadingProccess: Bool = true
	
	/// - Количество фото поэтапно загружаемых на странице
	fileprivate var picturesInfiniteCount: Int {
		return 3
	}
	fileprivate var cellHeight: CGFloat {
		let device = UIDevice.init()
		if device.screenType == .iPhones_5_5s_5c_SE {
			return 375
		}
		return 400
	}
	fileprivate var headerHeight: CGFloat {
		return 165
	}
	fileprivate lazy var instaDataManager: InstagramDataManager = {
		return InstagramDataManager()
	}()
	
	var currentUserData: InstaUser?
	
	// MARK: Functions
	override func viewDidLoad() {
		super.viewDidLoad()
		self.refreshControl = UIRefreshControl()
		self.refreshControl.attributedTitle = NSAttributedString(string: "Обновляем...")
		self.refreshControl.addTarget(self, action: #selector(self.refreshAction), for: .valueChanged)
		self.collectionView.addSubview(self.refreshControl)
		self.activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0,
		                                                                         y: 0,
		                                                                         width: 40,
		                                                                         height: 40))
		self.activityIndicator.center = self.view.center
		self.collectionView.addSubview(self.activityIndicator)
		self.activityIndicator.startAnimating()
		if currentUserData != nil {
			self.parseInstagramPhotos()
		} else {
			self.requestToInstaData()
		}
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
	}
	
	override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
		self.collectionView.collectionViewLayout.invalidateLayout()
	}
	
//	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//		super.viewWillTransition(to: size, with: coordinator)
//
//		coordinator.animate(alongsideTransition: { [unowned self] _ in
//			self.collectionView
//		}, completion: nil)
//	}
	
	@objc private func refreshAction() {
		self.startIndexLoading = 0
		self.requestToInstaData()
	}
	
	private func requestToInstaData() {
		let persistance = PersistanceService()
		guard persistance.instaUser != nil, persistance.instaUser?.token != "" else { return }
		instaDataManager.parseAfterLoginParameters(token: persistance.instaUser!.token) { [unowned self] (isSuccess, userData) in
			guard isSuccess else { return }
			guard let unwrappedData = userData else { return }
			self.currentUserData = unwrappedData
			self.parseInstagramPhotos()
		}
	}
	
	fileprivate func parseInstagramPhotos()	{
		guard currentUserData != nil else { return }
		inDownloadingProccess = true
		// Можно использовать OperationQueue для последовательной загрузки изображений
		let downloadGroup = DispatchGroup()
		let endCount = startIndexLoading + picturesInfiniteCount < currentUserData!.media.count ? startIndexLoading + picturesInfiniteCount : currentUserData!.media.count - 1
		for index in startIndexLoading...endCount {
			downloadGroup.enter()
			ImageLoader.load(with: currentUserData!.media[index].standartResolutonURL) { [weak self] resultImage in
				guard let unownedSelf = self else { return }
				unownedSelf.currentUserData!.media[index].standartResolutionImage = resultImage
				downloadGroup.leave()
			}
		}
		downloadGroup.notify(queue: .main) {
			self.activityIndicator.stopAnimating()
			self.activityIndicator.removeFromSuperview()
			self.refreshControl.endRefreshing()
			self.inDownloadingProccess = false
			self.collectionView.reloadData()
		}
	}
	
	
}

extension InstaPhotosViewController: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let orientation = UIApplication.shared.statusBarOrientation
		if orientation == .landscapeLeft || orientation == .landscapeRight {
			return CGSize.init(width: self.collectionView.frame.width / 2 - 30,
			                   height: self.collectionView.frame.width / 2)
		} else {
			return CGSize.init(width: self.collectionView.frame.width - 30,
			                   height: cellHeight)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 15
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
		let orientation = UIApplication.shared.statusBarOrientation
		if orientation == .landscapeLeft || orientation == .landscapeRight {
			return CGSize.init(width: headerHeight,
			                   height: self.collectionView.bounds.width / 3)
		} else {
			return CGSize.init(width: self.collectionView.bounds.width,
			                   height: headerHeight)
		}

	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		 return UIEdgeInsets(top: 18.0, left: 15.0, bottom: 1.0, right: 15.0)
	}
}

extension InstaPhotosViewController: UICollectionViewDelegate, UICollectionViewDataSource {
	
	func numberOfSections(in collectionView: UICollectionView) -> Int {
		return self.currentUserData != nil ? 1 : 0
	}
	
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		switch kind {
		case UICollectionElementKindSectionHeader:
			let cell = collectionView.dequeueSupplementaryView(InstagramHeaderView.self,
			                                                   kind: UICollectionElementKindSectionHeader,
			                                                   indexPath: indexPath)
			cell.configure(imagePath: currentUserData!.avatar, username: currentUserData!.username)
			return cell
		case UICollectionElementKindSectionFooter:
			fallthrough
		default:
			return UICollectionReusableView()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard self.currentUserData != nil, self.currentUserData!.media[0].standartResolutionImage != nil else { return 0 }
		return picturesInfiniteCount + startIndexLoading
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let instaModel = InstaCellVM.init(likes: currentUserData!.media[indexPath.row].likesCount,
		                                  comments: currentUserData!.media[indexPath.row].commentsCount,
		                                  image: currentUserData!.media[indexPath.row].standartResolutionImage!,
		                                  descriptionText: currentUserData!.media[indexPath.row].photoText)
		let cell = collectionView.dequeueReusableCell(with: instaModel, for: indexPath) as! InstaPhotoCollectionViewCell
		return cell
	}
}

extension InstaPhotosViewController {
	
 func scrollViewDidScroll(_ scrollView: UIScrollView) {
	guard !inDownloadingProccess else { return }
		let offsetY = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		if offsetY > contentHeight - scrollView.frame.size.height {
			if startIndexLoading + picturesInfiniteCount < self.currentUserData!.media.count - 1 {
				self.activityIndicator = UIActivityIndicatorView.init(frame: CGRect.init(x: 0,
				                                                                         y: 0,
				                                                                         width: 40,
				                                                                         height: 40))
				self.activityIndicator.center = CGPoint.init(x: self.view.center.x,
				                                             y: self.view.frame.height - 25)
				self.collectionView.addSubview(self.activityIndicator)
				self.activityIndicator.startAnimating()
				self.startIndexLoading += picturesInfiniteCount
				self.parseInstagramPhotos()
			}
		}
	}
	
}
