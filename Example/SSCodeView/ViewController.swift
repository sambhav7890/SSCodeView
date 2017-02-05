//
//  ViewController.swift
//  SSCodeView
//
//  Created by sambhav7890 on 02/02/2017.
//  Copyright (c) 2017 sambhav7890. All rights reserved.
//
import UIKit
import SSCodeView

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
			let alertController = UIAlertController(title: "Success", message: "Code is \(verificationCodeView.getCode())", preferredStyle: .alert)
			let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
			alertController.addAction(okAction)
			present(alertController, animated: true, completion: nil)

			verificationCodeView.totalDigitCount = verificationCodeView.totalDigitCount == 6 ? 4 : 6
			
		}
	}
}

// MARK: - SSCodeViewDelegate
extension VerificationCodeViewController: SSCodeViewDelegate {
	func didChangeVerificationCode() {
		submitButton.isEnabled = verificationCodeView.isValid()
	}
}
