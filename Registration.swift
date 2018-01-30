//
//  Registration.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 29/01/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    
    
    @IBOutlet weak var nameConstraint: NSLayoutConstraint!
    @IBOutlet weak var surnameConstraint: NSLayoutConstraint!
    @IBOutlet weak var patronymicConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConstraint: NSLayoutConstraint!
    @IBOutlet weak var passwordConfirmationConstraint: NSLayoutConstraint!
    @IBOutlet weak var registerConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let screenHeight = view.frame.height
        nameConstraint.constant = screenHeight/12
        surnameConstraint.constant = screenHeight/23
        patronymicConstraint.constant = screenHeight/23
        loginConstraint.constant = screenHeight/23
        passwordConstraint.constant = screenHeight/23
        passwordConfirmationConstraint.constant = screenHeight/23
        registerConstraint.constant = screenHeight/15
    }
}
