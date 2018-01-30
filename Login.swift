//
//  Login.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 28/01/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var labelConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var enterConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let screenHeight = view.frame.height
        labelConstraint.constant = screenHeight/7
        loginConstraint.constant = screenHeight/7
        passwordConstraint.constant = screenHeight/20
        enterConstraint.constant = screenHeight/15
        registerConstraint.constant = screenHeight/7
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let login = loginTextField.text
        let password = passwordTextField.text
        //сделать проверку правильности пароля
        let myUrl = "http://"
        //let request = NSMutableURLRequest(url: myUrl.toURL)
        //request.httpMethod = "POST"
        var postString = "login=(login)&password=(password)"
        dismiss(animated: true, completion: nil)
    }
    @IBAction func regiserAction(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: nil)
    }
    
    
}
