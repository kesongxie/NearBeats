//
//  SignUpViewController.swift
//  NearBeats
//
//  Created by Xie kesong on 2/23/17.
//  Copyright © 2017 ___KesongXie___. All rights reserved.
//

import UIKit
import Parse

fileprivate let SegueToHomeIden = "SegueToHome"

class SignUpViewController: UIViewController {

    @IBAction func backBtnTapped(_ sender: UIBarButtonItem) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
 
    @IBOutlet weak var usernameTextField: UITextField!{
        didSet{
            self.usernameTextField.delegate = self
        }
    }

    
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        guard let username = self.usernameTextField?.text else{
            return
        }
        guard !username.isEmpty else{
            return
        }
        
        guard let password = self.passwordTextField?.text else{
            return
        }
        guard !password.isEmpty else{
            return
        }
        ParseApp.signUp(username: username, password: password) { (succeed, error) in
            if succeed{
                print("sign up succeed")
                self.performSegue(withIdentifier: SegueToHomeIden, sender: self)
            }else{
                print("Can't sign up \(error?.localizedDescription)")
            }
        }
    }
    
    @IBOutlet weak var signUpBtn: UIButton!{
        didSet{
            self.signUpBtn.layer.cornerRadius = 6.0
            self.signUpBtn.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension SignUpViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

