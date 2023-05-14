//
//  UICollectionView.swift
//  JATC
//
//  Created by Osama Hasan on 29/11/2022.
//

import UIKit

extension UICollectionView {
    
    func register<Cell: UICollectionViewCell>(cellClass: Cell.Type) {
        self.register(UINib(nibName: String(describing: Cell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: Cell.self))
    }
    
    func dequeueReusableCell<Cell: UICollectionViewCell>(withClass name: Cell.Type, for indexPath: IndexPath) -> Cell {
        let identifier = String(describing: name)
        guard let cell = dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Couldn't find UICollectionViewCell for \(identifier), make sure the cell is registered with UICollectionView")
        }
        
        return cell
    }
    
}

