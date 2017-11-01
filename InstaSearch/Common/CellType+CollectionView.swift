//
//  CellType.swift
//  InstaSearch
//
//  Created by Danya on 30.10.17.
//  Copyright © 2017 Danya. All rights reserved.
//
import UIKit
import Foundation

protocol CellAnyViewModel {
	static var type: UIView.Type { get }
	func configure(cell: UIView)
}

protocol CollectionCellViewModel: CellAnyViewModel {
	associatedtype Cell: UIView
	func configure(cell: Cell)
}

extension CollectionCellViewModel {
	static var type: UIView.Type {
		return Cell.self
	}
	
	func configure(cell: UIView) {
		configure(cell: cell as! Cell)
	}
}

extension UICollectionView {
	func dequeueReusableCell(with model: CellAnyViewModel, for indexPath: IndexPath) -> UICollectionViewCell {
		let identifier = String(describing: type(of: model).type)
		let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
		model.configure(cell: cell)
		return cell
	}
}

extension UICollectionView {
	func registerReusableCell<T: UICollectionViewCell>(_: T.Type) where T: Reusable {
		if let nib = T.nib {
			self.registeri(nib, forCellWithReuseIdentifier: T.reuseIdentifier)
		} else {
			self.register(T.self, forCellWithReuseIdentifier: T.reuseIdentifier)
		}
	}
	
	func dequeueReusableCell<T: UICollectionViewCell>(_: T.Type, indexPath: IndexPath) -> T? where T: Reusable {
		return self.dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T
	}
	
	func registerSupplementaryView<T: UICollectionReusableView>(_ : T.Type, kind: String) where T: Reusable {
		if let nib = T.nib {
			self.register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
		} else {
			self.register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.reuseIdentifier)
		}
	}

	func dequeueSupplementaryView<T: UICollectionReusableView>(_: T.Type, kind: String, indexPath: IndexPath) -> T where T: Reusable {
		return self.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.reuseIdentifier, for: indexPath) as! T
	}
}

internal protocol Reusable: class {
	
	static var reuseIdentifier: String { get }
	
	static var nib: UINib? { get }
}

internal extension Reusable {
	
	static var reuseIdentifier: String { return String(describing: self) }
	
	static var nib: UINib? { return UINib(nibName: String(describing: self), bundle: nil) }
}

extension UICollectionReusableView: Reusable { }


