//
//  ViewController.swift
//  Grocery
//
//  Created by Mike Kari Anderson on 7/21/18.
//  Copyright © 2018 Mike Kari Anderson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Auth.auth().addStateDidChangeListener() { auth, user in
            guard user != nil else {
                self.usernameField.text = ""
                self.passwordField.text = ""
                self.usernameField.becomeFirstResponder()
                return
            }
            
            user!.getIDTokenResult(forcingRefresh: true) { token, error in
                guard error == nil else {
                    self.usernameField.text = ""
                    self.passwordField.text = ""
                    self.usernameField.becomeFirstResponder()
                    return
                }
                
                // properly logged in now
            }
        }
    }

    // MARK - Actions
    @IBAction func loginDidTouch(_ sender: UIButton) {
        guard
            let username = usernameField.text,
            let password = passwordField.text
            else { return }
        Auth.auth().signIn(withEmail: username, password: password) { user, error in
            
        }
    }
    
}

