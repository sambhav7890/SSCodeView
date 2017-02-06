//
//  UIViewExtension.swift
//  Pods
//
//  Created by Sambhav Shah on 5/27/16.
//  Copyright © 2017 Sambhav Shah. All rights reserved.
//

import UIKit

internal extension UIView {

	@discardableResult
	func loadViewFromNib() -> UIView {
		let nibName = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
		let view = Bundle(for: type(of: self)).loadNibNamed(nibName, owner: self, options: nil)?.first as! UIView
		view.translatesAutoresizingMaskIntoConstraints = false
		addSubview(view)

		let views = ["view": view]
		let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)
		let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: NSLayoutFormatOptions(), metrics: nil, views: views)

		let constraints = horizontalConstraints + verticalConstraints
		addConstraints(constraints)
		setNeedsUpdateConstraints()



		return view
	}

}
