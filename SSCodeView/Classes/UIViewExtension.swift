//
//  UIViewExtension.swift
//  Pods
//
//  Created by Sambhav Shah on 5/27/16.
//  Copyright © 2017 Sambhav Shah. All rights reserved.
//

import UIKit

extension UIView {
	func loadViewFromNib() {
		let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
		let view = Bundle(for: type(of: self)).loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)

		let views = ["view": view]
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
		addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views))
		setNeedsUpdateConstraints()
	}

//	@discardableResult
//	func addEqualHeightConstraint() -> NSLayoutConstraint? {
//		guard let superView = self.superview else { return nil }
//		let constraint = NSLayoutConstraint.init(item: self, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: superView, attribute: NSLayoutAttribute.height, multiplier: 1, constant: 0)
//		superView.addConstraint(constraint)
//		return constraint
//	}
}
