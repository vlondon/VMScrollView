//
//  ViewController.swift
//  VMScrollViewDemo
//
//  Created by Vladimirs Matusevics on 19/09/2017.
//  Copyright © 2017 vmatusevic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var scrollView: ScrollView = {
        return ScrollView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
        scrollView.data = [
            CellData(name: "First Cell", descr: "Aaaaa aaa aaa", color: .random()),
            CellData(name: "Second Cell", descr: "Bbb bbbbb bbbbb", color: .random()),
            CellData(name: "Third Cell", descr: "Cccc cccccc ccccc", color: .random())
        ]
    }
    
    private func addSubviews() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let top = NSLayoutConstraint(
            item: scrollView,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .top,
            multiplier: 1,
            constant: 0
        )
        
        let right = NSLayoutConstraint(
            item: scrollView,
            attribute: .right,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .right,
            multiplier: 1,
            constant: 0
        )
        
        let bottom = NSLayoutConstraint(
            item: scrollView,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .bottom,
            multiplier: 1,
            constant: 0
        )
        
        let left = NSLayoutConstraint(
            item: scrollView,
            attribute: .left,
            relatedBy: .equal,
            toItem: self.view,
            attribute: .left,
            multiplier: 1,
            constant: 0
        )
        
        view.addConstraints([top, right, bottom, left])
    }
    
}
