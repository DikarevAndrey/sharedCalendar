//
//  Login.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 28/01/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var labelConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let screenHeight = view.frame.height
        labelConstraint.constant = screenHeight/7
        warningConstraint.constant = screenHeight/25
        loginConstraint.constant = screenHeight/20
        passwordConstraint.constant = screenHeight/20
        registerConstraint.constant = screenHeight/5
    }
    
    @IBAction func loginAction(_ sender: Any) {
        let login = loginTextField.text!
        let password = passwordTextField.text!
        if login.isEmpty || password.isEmpty {
            warningLabel.text = "Все поля обязательны"
            warningLabel.textColor = UIColor.red
        }
        else {
            let postString = "login=\(login)&password=\(password)"
            let myURL = URL(string: "https://mighty-springs-49939.herokuapp.com/signin?\(postString)")!
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: myURL) { (_, response, error) in
                DispatchQueue.main.async {
                    let status = (response as! HTTPURLResponse).statusCode
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("response status: \(status)")
                    switch status {
                    case 202:
                        self.dismiss(animated: true, completion: nil)
                    case 401:
                        self.warningLabel.text = "Неверное имя пользователя или пароль"
                        self.warningLabel.textColor = UIColor.red
                    default:
                        print("unknown status code")
                    }
                }
                }.resume()
            //dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func registerAction(_ sender: Any) {
        performSegue(withIdentifier: "register", sender: nil)
    }
    
    
    
}
