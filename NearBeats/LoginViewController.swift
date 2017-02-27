//
//  LoginViewController.swift
//  NearBeats
//
//  Created by Xie kesong on 2/23/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

fileprivate let SegueToHomeIden = "SegueToHome"

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            self.usernameTextField.delegate = self
        }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!{
        didSet{
            self.passwordTextField.delegate = self
        }
    }


    @IBOutlet weak var loginBtn: UIButton!{
        didSet{
            self.loginBtn.layer.cornerRadius = 6.0
            self.loginBtn.clipsToBounds = true
        }
    }
    
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        guard let username = self.usernameTextField.text else{
            return
        }
        guard let password = self.passwordTextField.text else{
            return
        }
        PFUser.logInWithUsername(inBackground: username, password: password) { (user, error) in
            //segeu to home
            if user != nil{
               self.performSegue(withIdentifier: SegueToHomeIden, sender: self)
            }else{
                print("failed to log in: \(error?.localizedDescription)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

