//
//  ViewController.swift
//  BiometricAuthentication
//
//  Created by Sergio PH on 30/01/2018.
//  Copyright © 2018 Solid Gear. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    // MARK: - Constants
    
    let kSegueLoginSuccessfulID: String = "LoginSuccessful"
    let kUserKey: String = "user"
    let kPasswordKey: String = "password"
    let kErrorTitle: String = "Error"
    let kOKButtonTitle: String = "OK"
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    // MARK: - Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.biometricAuthenticator()
    }
    
    func biometricAuthenticator() {
        guard LAContext().canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) else {
            alertIfNoBiometricAuthenticationCompatible()
            return
        }
        
        let userdefaults = UserDefaults.standard
        guard userdefaults.string(forKey: kUserKey) != nil && userdefaults.string(forKey: kPasswordKey) != nil else { return }
        
        var messageForBiometricAuthentication = "You will pass with the correct fingerprint."
        
        if #available(iOS 11.0, *) {
            switch LAContext().biometryType {
            case .typeFaceID: messageForBiometricAuthentication = "Use your face to authenticate."
            case .typeTouchID: messageForBiometricAuthentication = "Use the correct fingerprint to authenticate."
            case .none: messageForBiometricAuthentication = ("There is no TouchID or FaceID.")
            }
        }
        
        LAContext().evaluatePolicy( .deviceOwnerAuthenticationWithBiometrics, localizedReason: messageForBiometricAuthentication, reply: {(success, error) -> Void in
            success ? self.performSegue(withIdentifier: self.kSegueLoginSuccessfulID, sender: nil) : self.showAlertForError(message: "Not logged")
        })
    }
    
    func alertIfNoBiometricAuthenticationCompatible(){
        showAlertForError(message: "This device does not have Biometric Authentication")
    }
    
    func storeUserAuthenticationData() {
        guard !userTextField.text!.isEmpty && !passwordTextField.text!.isEmpty else { return }
        let userDefaults = UserDefaults.standard
        userDefaults.set(userTextField.text, forKey: kUserKey)
        userDefaults.set(passwordTextField.text, forKey: kPasswordKey)
    }
    
    // MARK: - IBActions
    
    @IBAction func login(_ sender: Any) {
        storeUserAuthenticationData()
    }
    
    // MARK: - Util Methods
    
    func showAlertForError(title: String? = nil, message:String ) {
        let alertViewController = UIAlertController(title: title ?? kErrorTitle, message: message, preferredStyle: .alert)
        let okButtonAction = UIAlertAction(title: kOKButtonTitle, style: .default, handler: nil)
        alertViewController.addAction(okButtonAction)
        self.present(alertViewController, animated: true, completion: nil)
    }
    
}
