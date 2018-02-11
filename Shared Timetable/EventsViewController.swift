//
//  EventsViewController.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 06/02/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit
import CalendarKit

class EventsViewController: DayViewController {
    
    

    override func viewDidLoad() {
        self.navigationItem.title = "*название группы*" //сделать список участников по клику
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(buttonAction))
        self.navigationItem.rightBarButtonItem = addButton
        super.viewDidLoad()
    }
    
    func buttonAction() {
        let controller = EventAddingViewController()
        show(controller, sender: nil)
        print("Button tapped")
    }
    
}
