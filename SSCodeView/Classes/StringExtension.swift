//
//  StringExtension.swift
//  Pods
//
//  Created by Sambhav Shah on 5/27/16.
//  Copyright © 2017 Sambhav Shah. All rights reserved.
//

import UIKit

extension String {
	func trim(_ option: CharacterSet = .whitespaces) -> String {
		return trimmingCharacters(in: CharacterSet.whitespaces)
  }
}

//NSRange From Range
extension String {
	func nsRange(from range: Range<String.Index>) -> NSRange {
		let from = range.lowerBound.samePosition(in: utf16)
		let to = range.upperBound.samePosition(in: utf16)
		return NSRange(location: utf16.distance(from: utf16.startIndex, to: from),
		               length: utf16.distance(from: from, to: to))
	}
}

//Range From NSRange
extension String {
	func range(from nsRange: NSRange) -> Range<String.Index>? {
		guard
			let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
			let to16 = utf16.index(from16, offsetBy: nsRange.length, limitedBy: utf16.endIndex),
			let from = String.Index(from16, within: self),
			let to = String.Index(to16, within: self)
			else { return nil }
		return from ..< to
	}
}
