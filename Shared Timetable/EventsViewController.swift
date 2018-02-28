//
//  EventsViewController.swift
//  Shared Timetable
//
//  Created by Даниил Пес Кудрявцев on 06/02/2018.
//  Copyright © 2018 Даниил Пес Кудрявцев. All rights reserved.
//

import UIKit
import CalendarKit

class EventsViewController: DayViewController {
    
    

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.white
        //self.navigationItem.title = "*название группы*" //сделать список участников по клику
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
