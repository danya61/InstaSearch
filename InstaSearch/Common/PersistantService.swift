//
//  PersistantService.swift
//  InstaSearch
//
//  Created by Danya on 29.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//

import Foundation

final class PersistanceService {
	
	// MARK: -
	private let instaId = "instaSearch.InstaUser"
	
	// MARK: Initialize
	init() {
		self.defaults = UserDefaults.standard
	}
	
	// MARK: -
	// MARK: Properties
	
	// MARK: Private
	private var defaults: UserDefaults
	
	// MARK: Public
	var instaUser: InstaUser? {
		get {
			let unarchiveData = defaults.value(forKey: instaId) as? Data
			guard let data = unarchiveData else {return nil}
			let unarchieveObject = NSKeyedUnarchiver.unarchiveObject(with: data) as? InstaUser
			return unarchieveObject
		}
		set {
			guard let value = newValue else {
				defaults.set(nil, forKey: instaId)
				return
			}
			let archiverData = NSKeyedArchiver.archivedData(withRootObject: value)
			defaults.set(archiverData, forKey: instaId)
			defaults.synchronize()
		}
	}
	
}
