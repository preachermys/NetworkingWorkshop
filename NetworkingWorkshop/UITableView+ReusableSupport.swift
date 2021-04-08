//
//  UITableView+ReusableSupport.swift
//  NetworkingWorkshop
//
//  Created by  Admin on 06.04.2021.
//

import UIKit

extension UITableView {
    /**
     Register a Class-Based `UICollectionViewCell` subclass (conforming to `Reusable`)
     - parameter cellType: the `UICollectionViewCell` (`Reusable`-conforming) subclass to register
     - seealso: `register(_:,forCellWithReuseIdentifier:)`
     */
    final func register<T: UITableViewCell>(cellType: T.Type)
        where T: ReuseIdentifying {
            self.register(UINib.init(nibName: T.reuseIdentifier, bundle: Bundle.main),
                          forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Returns a reusable `UICollectionViewCell` object for the class inferred by the return-type
     - parameter indexPath: The index path specifying the location of the cell.
     - parameter cellType: The cell class to dequeue
     - returns: A `Reusable`, `UICollectionViewCell` instance
     - note: The `cellType` parameter can generally be omitted and infered by the return type,
     except when your type is in a variable and cannot be determined at compile time.
     - seealso: `dequeueReusableCell(withReuseIdentifier:,for:)`
     */
    final func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
          where T: ReuseIdentifying {
              guard let cell = self.dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
                  fatalError(
                      "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                          + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                          + "and that you registered the cell beforehand"
                  )
              }
              return cell
      }
}

extension UICollectionView {
    /**
     Register a Class-Based `UICollectionViewCell` subclass (conforming to `Reusable`)
     - parameter cellType: the `UICollectionViewCell` (`Reusable`-conforming) subclass to register
     - seealso: `register(_:,forCellWithReuseIdentifier:)`
     */
    final func register<T: UICollectionViewCell>(cellType: T.Type)
        where T: ReuseIdentifying {
            register(UINib.init(nibName: T.reuseIdentifier, bundle: Bundle.main),
                     forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    /**
     Returns a reusable `UICollectionViewCell` object for the class inferred by the return-type
     - parameter indexPath: The index path specifying the location of the cell.
     - parameter cellType: The cell class to dequeue
     - returns: A `Reusable`, `UICollectionViewCell` instance
     - note: The `cellType` parameter can generally be omitted and infered by the return type,
     except when your type is in a variable and cannot be determined at compile time.
     - seealso: `dequeueReusableCell(withReuseIdentifier:,for:)`
     */
    final func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T
          where T: ReuseIdentifying {
            guard let cell = dequeueReusableCell(withReuseIdentifier: cellType.reuseIdentifier, for: indexPath) as? T else {
                  fatalError(
                      "Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self). "
                          + "Check that the reuseIdentifier is set properly in your XIB/Storyboard "
                          + "and that you registered the cell beforehand"
                  )
              }
              return cell
      }
}
