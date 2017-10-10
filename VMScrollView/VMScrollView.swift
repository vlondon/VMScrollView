//
//  VMScrollView.swift
//  VMScrollView
//
//  Created by Vladimirs Matusevics on 2017/09/19.
//  Copyright © 2017 Vladimirs Matusevics. All rights reserved.
//

import UIKit

public protocol VMScrollViewProtocol {
    var cellClass: UICollectionViewCell.Type { get }
    
    func configureCollectionCell(_ cell: UICollectionViewCell, data: Any) -> UICollectionViewCell
    func scrollToPage(_ page: Int)
    func scroll(to index: Int, animated: Bool)
    func refreshWithNoDataChange()
}

public protocol VMScrollViewCell {
    func updateParallax(for contentOffsetX: CGFloat)
    func refresh()
}

open class VMScrollView: UICollectionReusableView, VMScrollViewProtocol {
    
    static let kCYScrollCellId = "kVMScrollCellId"
    
    open var cellClass: UICollectionViewCell.Type {
        return UICollectionViewCell.self
    }
    
    //MARK:- properties
    
    public lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pageControl)
        return pageControl
    }()
    
    public var pageControlOffset = UIOffset.zero {
        didSet {
            self.updatePageControl()
        }
    }
    
    public var data: [Any] {
        didSet {
            if data.count != oldValue.count {
                refresh()
            } else {
                refreshWithNoDataChange()
            }
        }
    }
    
    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.bounces = false
        
        collectionView.register(cellClass, forCellWithReuseIdentifier: VMScrollView.kCYScrollCellId)
        return collectionView
    }()
    
    //MARK:- init methods
    
    public override init(frame: CGRect) {
        self.data = []
        super.init(frame: frame)
        self.configureConstraints()
    }
    
    public convenience init(with data: [Any] = []) {
        self.init(frame: CGRect.zero)
        self.data = data
        self.refresh()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureConstraints() {
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let leftConst = NSLayoutConstraint(
            item: collectionView,
            attribute: .left,
            relatedBy: .equal,
            toItem: self,
            attribute: .left,
            multiplier: 1,
            constant: 0
        )
        let rightConst = NSLayoutConstraint(
            item: collectionView,
            attribute: .right,
            relatedBy: .equal,
            toItem: self,
            attribute: .right,
            multiplier: 1,
            constant: 0
        )
        let topConst = NSLayoutConstraint(
            item: collectionView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        let bottomConst = NSLayoutConstraint(
            item: collectionView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        self.addConstraints([leftConst,rightConst,topConst,bottomConst])
    }
    
    //MARK:- page control setting
    
    private func removePageControlAutoLayout() {
        self.pageControl.removeConstraints(self.pageControl.constraints)
        for constraint in self.constraints where constraint.firstItem === self.pageControl {
            self.removeConstraint(constraint)
        }
    }
    
    fileprivate func calculateParallax() {
        collectionView.visibleCells.forEach { cell in
            if let vmCell = cell as? VMScrollViewCell,
                let convertedPoint = cell.superview?.convert(cell.frame.origin, to: self.superview?.superview) {
                vmCell.updateParallax(for: convertedPoint.x)
            }
        }
    }
    
    public func updatePageControl() {
        
        if self.data.count <= 1 {
            self.updatePageControl(hidden: true)
            return
        }
        
        self.updatePageControl(hidden: false)
        self.updatePageControl(total: self.data.count)
        
        let pageControlWidth = Double(self.data.count) * 15
        let pageControlHeight = Double(16)
        
        self.removePageControlAutoLayout()
        let widthConst = NSLayoutConstraint(
            item: self.pageControl,
            attribute: .width,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: CGFloat(pageControlWidth)
        )
        let hightConst = NSLayoutConstraint(
            item: self.pageControl,
            attribute: .height,
            relatedBy: .equal,
            toItem: nil,
            attribute: .notAnAttribute,
            multiplier: 1,
            constant: CGFloat(pageControlHeight)
        )
        self.pageControl.addConstraints([widthConst, hightConst])
        
        let XConst = NSLayoutConstraint(
            item: self.pageControl,
            attribute: .centerX,
            relatedBy: .equal,
            toItem: self,
            attribute: .centerX,
            multiplier: 1,
            constant: pageControlOffset.horizontal
        )
        let YConst = NSLayoutConstraint(
            item: self.pageControl,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self,
            attribute: .bottom,
            multiplier: 1,
            constant: pageControlOffset.vertical - 10
        )
        self.addConstraints([XConst, YConst])
    }
    
    open func updatePageControl(hidden: Bool) {
        self.pageControl.isHidden = hidden
    }
    
    open func updatePageControl(total pages: Int) {
        self.pageControl.numberOfPages = pages
    }
    
    open func updatePageControl(page: Int) {
        self.pageControl.currentPage = page
    }
    
    //MARK:- VMScrollViewProtocol
    
    open func refresh() {
        self.collectionView.reloadData()
        
        if self.data.count > 1 {
            // unable to scroll before the collectionview is shown
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
                self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.top, .left], animated: false)
            }
        }
        
        self.updatePageControl()
    }
    
    open func refreshWithNoDataChange() {
        self.collectionView.reloadData()
    }
    
    private func transferIndex(_ index: Int) -> Int {
        if self.data.count <= 1 {
            return 0
        }
        
        if index == 0 {
            return self.data.count - 1
        } else if index == self.data.count + 1 {
            return 0
        }
        
        return index - 1
    }
    
    open func configureCollectionCell(_ cell: UICollectionViewCell, data: Any) -> UICollectionViewCell {
        return cell
    }
    
    open func scrollToPage(_ page: Int) {
        self.updatePageControl(page: page)
    }
    
    open func scroll(to index: Int, animated: Bool) {
        self.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: [.top, .left], animated: animated)
        self.scrollToPage(index - 1)
    }
    
}

extension VMScrollView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK:- delegate method
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.count > 1 ? self.data.count + 2 : self.data.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? VMScrollViewCell {
            cell.refresh()
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: VMScrollView.kCYScrollCellId, for: indexPath)
        
        let index = self.transferIndex(indexPath.row)
        
        let data = self.data[index]
        
        cell = self.configureCollectionCell(cell, data: data)
        
        return cell
        
    }
    
    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    open func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        calculateParallax()
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = Float(scrollView.contentOffset.x * 1.0 / scrollView.frame.size.width)
        
        index = index.isNaN ? 0 : index
        
        if index < 0.25 {
            self.collectionView.scrollToItem(at: IndexPath(item: self.data.count, section: 0), at: [.top,.left], animated: false)
        } else if index >= Float(self.data.count + 1) {
            self.collectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: [.top,.left], animated: false)
        }
        
        let page = self.transferIndex(Int(index))
        
        scrollToPage(page)
        calculateParallax()
    }
    
}

