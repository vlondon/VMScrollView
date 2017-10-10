//
//  ScrollView.swift
//  VMScrollViewDemo
//
//  Created by Vladimirs Matusevics on 19/09/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//


import UIKit

class ScrollView: VMScrollView {
    
    override func cellClass() -> UICollectionViewCell.Type {
        return ScrollViewCell.self
    }
    
    override func configureCollectionCell(_ cell: UICollectionViewCell, data: Any) -> UICollectionViewCell {
        let cell = cell as! ScrollViewCell
        
        if let data = data as? CellData {
            cell.update(with: data)
        }
        
        return cell
    }
    
}
