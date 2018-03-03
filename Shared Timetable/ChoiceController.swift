//
//  ChoiceController.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 28/02/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import Foundation
import UIKit

class ChoiceController: UITabBarController {
    
    override func viewDidLoad() {
        self.tabBar.items?[0].title = "Groups"
        self.tabBar.items?[1].title = "Favorites"
        super.viewDidLoad()
    }
}
