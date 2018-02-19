//
//  Registration.swift
//  Shared Timetable
//
//  Created by Даниил Пес Кудрявцев on 29/01/2018.
//  Copyright © 2018 Даниил Пес Кудрявцев. All rights reserved.
//

import UIKit

var name: String = ""
var surname: String = ""
var patronymic: String = ""

class FirstStepRegistrationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var patronymicTextField: UITextField!
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameConstraint: NSLayoutConstraint!
    @IBOutlet weak var surnameConstraint: NSLayoutConstraint!
    @IBOutlet weak var patronymicConstraint: NSLayoutConstraint!
    @IBOutlet weak var warningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.frame.height
        warningConstraint.constant = screenHeight/30
        nameConstraint.constant = screenHeight/30
        surnameConstraint.constant = screenHeight/23
        patronymicConstraint.constant = screenHeight/23
        
        nextBarButtonItem.isEnabled = false
        nameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        //for function textFieldShouldReturn
        self.nameTextField.delegate = self
        self.surnameTextField.delegate = self
        self.patronymicTextField.delegate = self
    }
    
    //Hides keyboard while tapping outside the text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //Hides keyboard when "return" button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    //Implements every time textField.text is changed
    func editingChanged(_ textField: UITextField) {
        guard
            let name = nameTextField.text, !name.isEmpty,
            let surname = surnameTextField.text, !surname.isEmpty
        else {
                self.nextBarButtonItem.isEnabled = false
                return
        }
        nextBarButtonItem.isEnabled = true
    }
    
    @IBAction func nextAction(_ sender: Any) {
        warningLabel.text = ""
        name = nameTextField.text!
        surname = surnameTextField.text!
        patronymic = patronymicTextField.text!
        performSegue(withIdentifier: "next", sender: nil)
    }
    
}

class LastStepRegistrationViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var registerBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    @IBOutlet weak var warningConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConfirmationConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.frame.height
        warningConstraint.constant = screenHeight/30
        loginConstraint.constant = screenHeight/30
        passwordConstraint.constant = screenHeight/23
        passwordConfirmationConstraint.constant = screenHeight/23
        
        registerBarButtonItem.isEnabled = false
        loginTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordConfirmationTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        passwordTextField.addTarget(self, action: #selector(passwordsMatch), for: .editingChanged)
        passwordConfirmationTextField.addTarget(self, action: #selector(passwordsMatch), for: .editingChanged)
        
        //for function textFieldShouldReturn
        self.loginTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordConfirmationTextField.delegate = self
    }
    
    //Hides keyboard while tapping outside the text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    //Hides keyboard when "return" button pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    func asciiCapable(s: String) -> Bool {
        var flag = true
        for c in s {
            if !((c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || c == "." || c == "_" || c == "-" || c >= "0" && c <= "9") {
                flag = false
            }
        }
        return flag
    }
    
    func editingChanged(_ textField: UITextField) {
        let login = loginTextField.text!
        let password = passwordTextField.text!
        let passwordConfirmation = passwordConfirmationTextField.text!
        warningLabel.text = ""
        if !asciiCapable(s: login) || !asciiCapable(s: password) || !asciiCapable(s: passwordConfirmation) {
            warningLabel.text = "Only latin symbols, ., -, _ are expected"
            warningLabel.textColor = UIColor.white
            registerBarButtonItem.isEnabled = false
            return
        }
        if login.isEmpty || password.isEmpty || passwordConfirmation.isEmpty {
            registerBarButtonItem.isEnabled = false
            return
        }
        registerBarButtonItem.isEnabled = true
    }
    
    func passwordsMatch(_ textField: UITextField) {
        let login = loginTextField.text!
        let password = passwordTextField.text!
        let passwordConfirmation = passwordConfirmationTextField.text!
        warningLabel.text = ""
        if !asciiCapable(s: login) || !asciiCapable(s: password) || !asciiCapable(s: passwordConfirmation) {
            warningLabel.text = "Only latin symbols, ., -, _ are expected"
            warningLabel.textColor = UIColor.white
            registerBarButtonItem.isEnabled = false
            return
        }
        if passwordConfirmation.isEmpty || password.isEmpty || passwordConfirmation.count < password.count {
            registerBarButtonItem.isEnabled = false
            return
        }
        if password != passwordConfirmation {
            warningLabel.text = "Passwords do not match"
            warningLabel.textColor = UIColor.white
            registerBarButtonItem.isEnabled = false
            return
        }
        if login.isEmpty {
            registerBarButtonItem.isEnabled = false
        }
        registerBarButtonItem.isEnabled = false
    }
    
    @IBAction func registerAction(_ sender: Any) {
        let login = loginTextField.text!
        let password = passwordTextField.text!
        let myUrl = "http://188.166.110.14/signup?"
        let request = NSMutableURLRequest(url: URL(string: myUrl)!)
        request.httpMethod = "POST"
        let postString = "name=\(name)&surname=\(surname)&patronymic=\(patronymic)&login=\(login)&password=\(password)"
        request.httpBody = postString.data(using: String.Encoding.utf8)
        URLSession.shared.dataTask(with: request as URLRequest) {
            (_, response, error) in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else {
                    // Error handle
                    self.warningLabel.text = "No internet connection"
                    self.warningLabel.textColor = UIColor.white
                    return
                }
                let status = response.statusCode
                if let error = error {
                    print(error.localizedDescription)
                }
                //print("response status: \(status)")
                switch status {
                case 201:
                    let defaults = UserDefaults.standard
                    defaults.setValue(login, forKey: "login")
                    defaults.setValue(password, forKey: "password")
                    defaults.synchronize()
                    self.dismiss(animated: true, completion: nil)
                case 409:
                    self.warningLabel.text = "The user with this login already exists"
                    self.warningLabel.textColor = UIColor.white
                default:
                    self.warningLabel.text = "Unknown status code"
                    self.warningLabel.textColor = UIColor.white
                }
            }
        }.resume()
    }
}
