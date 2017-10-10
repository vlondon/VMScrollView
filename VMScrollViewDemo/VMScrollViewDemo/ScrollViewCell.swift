//
//  ScrollViewCell.swift
//  VMScrollViewDemo
//
//  Created by Vladimirs Matusevics on 19/09/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit

typealias ParallaxConstraint = (constraint: NSLayoutConstraint, multiplier: CGFloat)

struct CellData {
    var name: String
    var descr: String
    var color: UIColor
}

class ScrollViewCell: UICollectionViewCell {
    
    private var subviewsDidLayout = false
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .title1), size: 0)
        label.textColor = .white
        return label
    }()
    
    private lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont(descriptor: .preferredFontDescriptor(withTextStyle: .body), size: 0)
        label.textColor = .white
        return label
    }()
    
    fileprivate lazy var titleCenterConst: ParallaxConstraint = {
        return (NSLayoutConstraint(
            item: self.titleLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ), 0.3)
    }()
    
    fileprivate lazy var bodyCenterConst: ParallaxConstraint = {
        return (NSLayoutConstraint(
            item: self.bodyLabel,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self.contentView,
            attribute: .centerX,
            multiplier: 1,
            constant: 0
        ), 0.03)
    }()
    
    fileprivate lazy var bodyTopConst: ParallaxConstraint = {
        return (NSLayoutConstraint(
            item: self.bodyLabel,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.titleLabel,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        ), 0.2)
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(bodyLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        contentView.frame = bounds
        
        if !self.subviewsDidLayout {
            
            let titleTopConst = NSLayoutConstraint(
                item: titleLabel,
                attribute: .top,
                relatedBy: .equal,
                toItem: self.contentView,
                attribute: .top,
                multiplier: 1,
                constant: 40
            )
            
            self.contentView.addConstraints([
                titleCenterConst.constraint,
                titleTopConst,
                bodyCenterConst.constraint,
                bodyTopConst.constraint
            ])
            
            self.subviewsDidLayout = true
        }
        
        super.layoutSubviews()
    }
    
    func update(with data: CellData) {
        self.contentView.backgroundColor = data.color
        titleLabel.text = data.name
        bodyLabel.text = data.descr
    }
    
}

extension ScrollViewCell: VMScrollViewCell {
    
    func updateParallax(for contentOffsetX: CGFloat) {
        titleCenterConst.constraint.constant = contentOffsetX * titleCenterConst.multiplier
        bodyCenterConst.constraint.constant = contentOffsetX * bodyCenterConst.multiplier
        bodyTopConst.constraint.constant = abs(contentOffsetX) * bodyTopConst.multiplier
    }
    
    func refresh() {
        titleCenterConst.constraint.constant = 0
        bodyCenterConst.constraint.constant = 0
        bodyTopConst.constraint.constant = 0
    }
    
}
