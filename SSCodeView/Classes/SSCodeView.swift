//
//  SSCodeView.swift
//  Pods
//
//  Created by Sambhav Shah on 11/01/17.
//  Copyright © 2017 Sambhav Shah. All rights reserved.
//

import UIKit

public protocol SSCodeViewDelegate: class {
	func didChangeVerificationCode()
}

@IBDesignable open class SSCodeView: UIView {

	// MARK: - Constants

	@IBInspectable public var totalDigitCount = 6 {
		didSet {
			self.updateDigitCount()
		}
	}

	@IBInspectable public var maxCharactersLength = 1 {
		didSet {
			for textFieldView in self.textFieldViews {
				textFieldView.maxCharactersLength = maxCharactersLength
			}
		}
	}

	// MARK: - IBInspectables
	@IBInspectable open var underlineColor: UIColor = UIColor.darkGray {
		didSet {
			for textFieldView in self.textFieldViews {
				textFieldView.underlineColor = self.underlineColor
			}
		}
	}

	@IBInspectable var underlineSelectedColor: UIColor = UIColor.black {
		didSet {
			for textFieldView in self.textFieldViews {
				textFieldView.underlineSelectedColor = self.underlineSelectedColor
			}
		}
	}

	@IBInspectable var textColor: UIColor = UIColor.darkText {
		didSet {
			for textFieldView in self.textFieldViews {
				textFieldView.numberTextField.textColor = self.textColor
			}
		}
	}

	@IBInspectable var textSize: CGFloat = 24.0 {
		didSet {
			for textFieldView in self.textFieldViews {
				if let font = textFieldView.numberTextField.font {
					textFieldView.numberTextField.font = font.withSize(self.textSize)
				} else {
					textFieldView.numberTextField.font = UIFont.systemFont(ofSize: self.textSize)
				}
			}
		}
	}

	@IBInspectable var textFont: String = "" {
		didSet {
			if let font = UIFont(name: textFont.trim(), size: self.textSize) {
				textFieldFont = font
			} else {
				textFieldFont = UIFont.systemFont(ofSize: self.textSize)
			}
		}
	}

	@IBInspectable var textFieldBackgroundColor: UIColor = UIColor.clear {
		didSet {
			for textFieldView in self.textFieldViews {
				textFieldView.numberTextField.backgroundColor = self.textFieldBackgroundColor
			}
		}
	}

	@IBInspectable var textFieldTintColor: UIColor = UIColor.blue {
		didSet {
			for textFieldView in self.textFieldViews {
				textFieldView.numberTextField.tintColor = self.textFieldTintColor
			}
		}
	}

	// MARK: - Variables
	public var textFieldFont = UIFont.systemFont(ofSize: 24.0) {
		didSet {
			for textFieldView in self.textFieldViews {
				textFieldView.numberTextField.font = self.textFieldFont
			}
		}
	}

	var textFieldViews: [SSTextFieldView] = []
	@IBOutlet open weak var digitStack: UIStackView!

	weak public var delegate: SSCodeViewDelegate?

	// MARK: - Lifecycle
	override init(frame: CGRect) {
		super.init(frame: frame)
		loadViewFromNib()
		updateDigitCount()
	}

	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		loadViewFromNib()
		updateDigitCount()
		setupVerificationCodeViews()
	}

	// MARK: - Public Methods
	public func getCode() -> String {
		var verificationCode = ""
		for textFieldView in textFieldViews {
			verificationCode += textFieldView.numberTextField.text ?? ""
		}
		return verificationCode
	}

	public func isValid() -> Bool {
		for textFieldView in textFieldViews {
			guard let theText = textFieldView.numberTextField.text else { return false }
			guard let _ = Int(theText) else { return false }
		}
		return true
	}

	public func updateDigitCount() {

		guard let _ = self.digitStack else { return }

		guard self.textFieldViews.count != self.totalDigitCount else {
			for aTextfieldView in self.textFieldViews {
				aTextfieldView.reset()
			}
			self.textFieldViews.first?.activate()
			return
		}

		guard self.totalDigitCount >= 0 else { return }

		if self.textFieldViews.count > self.totalDigitCount {
			guard let oldField = self.textFieldViews.popLast() else { return }
			oldField.removeFromSuperview()

			self.updateDigitCount()
		} else if  (self.textFieldViews.count < self.totalDigitCount) {
			guard let newField = createCodeDigitField() else { return }

			newField.maxCharactersLength = maxCharactersLength
			newField.underlineColor = self.underlineColor
			newField.underlineSelectedColor = self.underlineSelectedColor
			newField.numberTextField.textColor = self.textColor
			newField.numberTextField.backgroundColor = self.textFieldBackgroundColor
			newField.numberTextField.tintColor = self.textFieldTintColor
			newField.numberTextField.font = self.textFieldFont

			self.textFieldViews.append(newField)
			addDigitField(field: newField)

			updateDigitCount()
		}
	}
	
	private func createCodeDigitField() -> SSTextFieldView? {
		let origin = CGPoint.zero
		var size = self.bounds.size.width / CGFloat(self.totalDigitCount)
		let rect = CGRect(origin: origin, size: CGSize(width: size, height: size))
		let fieldView = SSTextFieldView(frame: rect)
		fieldView.delegate = self
		return fieldView
	}

	@discardableResult
	private func addDigitField(field: SSTextFieldView) -> SSTextFieldView {
		self.digitStack.addArrangedSubview(field)
		return field
	}


	// MARK: - Private Methods
	private func setupVerificationCodeViews() {
		for textFieldView in textFieldViews {
			textFieldView.delegate = self
		}
		textFieldViews.first?.activate()
	}
}

// MARK: - SSTextFieldDelegate
extension SSCodeView: SSTextFieldDelegate {
	func moveToNext(_ textFieldView: SSTextFieldView) {

		guard let index = textFieldViews.index(of: textFieldView) else { return }

		let activate: ((Array.Index) -> Void)  = { (validIndex) in
			self.textFieldViews[validIndex].activate()
		}

		if index == textFieldViews.count - 1 {
			activate(index)
		} else {
			activate(index+1)
		}

	}

	func moveToPrevious(_ textFieldView: SSTextFieldView, oldCode: String) {
		if textFieldViews.last == textFieldView && oldCode != " " {
			return
		}

		guard let index = textFieldViews.index(of: textFieldView) else { return }

		let resetactivation: ((Array.Index) -> Void)  = { (validIndex) in
			self.textFieldViews[validIndex].activate()
			self.textFieldViews[validIndex].reset()
		}

		if index == 0 {
			resetactivation(index)
		} else {
			resetactivation(index-1)
		}

	}

	func didChangeCharacters() {
		delegate?.didChangeVerificationCode()
	}
}
