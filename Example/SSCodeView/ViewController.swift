//
//  ViewController.swift
//  SSCodeView
//
//  Created by sambhav7890 on 02/02/2017.
//  Copyright (c) 2017 sambhav7890. All rights reserved.
//
import UIKit
import SSCodeView
import MobileCoreServices

class VerificationCodeViewController: UIViewController {

	// MARK: - IBOutlets
	@IBOutlet weak var verificationCodeView: SSCodeView!
	@IBOutlet weak var submitButton: UIButton!

	// MARK: - Lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()

		submitButton.isEnabled = false
		verificationCodeView.delegate = self
	}

	// MARK: - IBAction
	@IBAction func submitButtonTapped(_ sender: UIButton) {
		if verificationCodeView.isValid() {

			let newDigitCount = verificationCodeView.totalDigitCount == 6 ? 4 : 6

			let alertController = UIAlertController(title: "Success", message: "Code is \(verificationCodeView.getCode())", preferredStyle: .alert)

			let okAction = UIAlertAction(title: "Ok, reset to \(newDigitCount) digits", style: .default, handler: { (action) in
				self.verificationCodeView.totalDigitCount = newDigitCount
			})
			alertController.addAction(okAction)

			let copyAction = UIAlertAction(title: "Copy Code", style: .default, handler: { (action) in
				let pasteboardItem: [String : String] = [String(kUTTypeUTF8PlainText) : self.verificationCodeView.getCode()]
				UIPasteboard.general.addItems([pasteboardItem])
			})
			alertController.addAction(copyAction)

			let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
			alertController.addAction(cancelAction)

			present(alertController, animated: true, completion: nil)
		}
	}
}

// MARK: - SSCodeViewDelegate
extension VerificationCodeViewController: SSCodeViewDelegate {
	func didChangeVerificationCode() {
		submitButton.isEnabled = verificationCodeView.isValid()
	}
}
