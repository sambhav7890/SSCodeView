//
//  SSTextFieldView.swift
//  Pods
//
//  Created by Sambhav Shah on 13/01/17.
//  Copyright © 2017 Sambhav Shah. All rights reserved.
//

import UIKit

protocol SSTextFieldDelegate: class {
	func moveToNext(_ textFieldView: SSTextFieldView)
	func moveToPrevious(_ textFieldView: SSTextFieldView, oldCode: String)
	func didChangeCharacters()
}

@IBDesignable class SSTextFieldView: UIView {

	// MARK: - Constants
	public var maxCharactersLength = 1 {
		didSet {
			reset()
		}
	}

	// MARK: - IBInspectables
	@IBInspectable var underlineColor: UIColor = UIColor.darkGray {
		didSet {
			underlineView.backgroundColor = underlineColor
		}
	}

	@IBInspectable var underlineSelectedColor: UIColor = UIColor.black

	@IBInspectable var textColor: UIColor = UIColor.darkText {
		didSet {
			numberTextField.textColor = textColor
		}
	}

	@IBInspectable var textSize: CGFloat = 24.0 {
		didSet {
			numberTextField.font = UIFont.systemFont(ofSize: textSize)
		}
	}

	@IBInspectable var textFont: String = "" {
		didSet {
			if let font = UIFont(name: textFont, size: textSize) {
				numberTextField.font = font
			} else {
				numberTextField.font = UIFont.systemFont(ofSize: textSize)
			}
		}
	}

	@IBInspectable var textFieldBackgroundColor: UIColor = UIColor.clear {
		didSet {
			numberTextField.backgroundColor = textFieldBackgroundColor
		}
	}

	@IBInspectable var textFieldTintColor: UIColor = UIColor.blue {
		didSet {
			numberTextField.tintColor = textFieldTintColor
		}
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.numberTextField.text = "1"
	}

	// MARK: - IBOutlets
	@IBOutlet weak var numberTextField: UITextField!
	@IBOutlet weak private var underlineView: UIView!

	// MARK: - Variables
	weak var delegate: SSTextFieldDelegate?

	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		loadViewFromNib()
		setupBasics()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadViewFromNib()
		setupBasics()
	}

	func setupBasics() {
		numberTextField.delegate = self
		NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidChange(_:)), name: NSNotification.Name.UITextFieldTextDidChange, object: numberTextField)


		updateUnderline()

		if let font = UIFont(name: self.textFont, size: self.textSize) {
			numberTextField.font = font
		} else {
			numberTextField.font = UIFont.systemFont(ofSize: self.textSize)
		}
		numberTextField.backgroundColor = textFieldBackgroundColor
		numberTextField.tintColor = textFieldTintColor

	}

	deinit {
		NotificationCenter.default.removeObserver(self)
	}

	// MARK: - Public Methods
	public func activate() {
		numberTextField.becomeFirstResponder()
		if numberTextField.text?.characters.count == 0 {
			numberTextField.text = " "
		}
	}

	public func deactivate() {
		numberTextField.resignFirstResponder()
	}

	public func reset() {
		numberTextField.text = " "
		updateUnderline()
	}

	// MARK: - FilePrivate Methods
	dynamic fileprivate func textFieldDidChange(_ notification: Foundation.Notification) {
		if numberTextField.text?.characters.count == 0 {
			numberTextField.text = " "
		}
	}

	fileprivate func updateUnderline() {
		underlineView.backgroundColor = numberTextField.text?.trim() != "" ? underlineSelectedColor : underlineColor
	}

}

// MARK: - UITextFieldDelegate
extension SSTextFieldView: UITextFieldDelegate {
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		let currentString = numberTextField.text!
		let newString = currentString.replacingCharacters(in: textField.text!.range(from: range)!, with: string)

		if newString.characters.count > self.maxCharactersLength {
			delegate?.moveToNext(self)
			textField.text = string
		} else if newString.characters.count == 0 {
			delegate?.moveToPrevious(self, oldCode: textField.text!)
			numberTextField.text = " "
		}

		delegate?.didChangeCharacters()
		updateUnderline()

		return newString.characters.count <= self.maxCharactersLength
	}
}
