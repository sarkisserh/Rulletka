//
//  UICollectionViewCell.swift
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cell: T.Type) {
        register(T.nib, forCellWithReuseIdentifier: T.identifier)
    }
}
