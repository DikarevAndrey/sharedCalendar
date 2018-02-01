//
//  Registration.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 29/01/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit

var name: String = ""
var surname: String = ""
var patronymic: String = ""

class FirstStepRegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameConstraint: NSLayoutConstraint!
    @IBOutlet weak var surnameConstraint: NSLayoutConstraint!
    @IBOutlet weak var patronymicConstraint: NSLayoutConstraint!
    @IBOutlet weak var nextConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.frame.height
        warningConstraint.constant = screenHeight/30
        nameConstraint.constant = screenHeight/30
        surnameConstraint.constant = screenHeight/23
        patronymicConstraint.constant = screenHeight/23
        nextConstraint.constant = screenHeight/30
    }
    
    @IBAction func nextAction(_ sender: Any) {
        name = nameTextField.text!
        surname = surnameTextField.text!
        patronymic = patronymicTextField.text!
        if name.isEmpty || surname.isEmpty {
            warningLabel.text = "Поля имя и фамилия обязательны"
            warningLabel.textColor = UIColor.red
        }
        else {
            performSegue(withIdentifier: "next", sender: nil)
        }
    }
}

class LastStepRegistrationViewController: UIViewController {
    
    
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfrimationTextField: UITextField!
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConfirmationConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.frame.height
        warningConstraint.constant = screenHeight/30
        loginConstraint.constant = screenHeight/30
        passwordConstraint.constant = screenHeight/23
        passwordConfirmationConstraint.constant = screenHeight/23
        registerConstraint.constant = screenHeight/30
    }
    @IBAction func registerAction(_ sender: Any) {
        let login = loginTextField.text!
        let password = passwordTextField.text!
        let passwordConfirmation = passwordConfrimationTextField.text!
        if login.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
            warningLabel.text = "Все поля обязательны"
            warningLabel.textColor = UIColor.red
        }
        else {
            if passwordConfirmation != password {
                warningLabel.text = "Пароли не совпадают"
                warningLabel.textColor = UIColor.red
            }
            else {
                let myUrl = "https://mighty-springs-49939.herokuapp.com/signup?"
                let request = NSMutableURLRequest(url: URL(string: myUrl)!)
                request.httpMethod = "POST"
                let postString = "name=\(name)&surname=\(surname)&patronymic=\(patronymic)&login=\(login)&password=\(password)"
                //print(postString)
                request.httpBody = postString.data(using: String.Encoding.utf8)
                URLSession.shared.dataTask(with: request as URLRequest) {
                    (_, response, error) in
                    DispatchQueue.main.async {
                        let status = (response as! HTTPURLResponse).statusCode
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        //print("response status: \(status)")
                        switch status {
                        case 201:
                            self.dismiss(animated: true, completion: nil)
                        case 409:
                            self.warningLabel.text = "Такой логин уже существует"
                            self.warningLabel.textColor = UIColor.red
                        default:
                            print("unknown status code")
                        }
                    }
                }.resume()
                //dismiss(animated: true, completion: nil)
            }
        }
    }
}
