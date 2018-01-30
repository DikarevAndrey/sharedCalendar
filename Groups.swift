//
//  ViewController.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 26/01/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //сделать проверку, что пользователь залогинин
        // Do any additional setup after loading the view, typically from a nib.
        performSegue(withIdentifier: "kek", sender: nil)
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! LabelCell //cell - ячейка таблицы
        cell.label1.text = "Bla-bla-bla"
        return cell
    }
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 17
    }
    //возвращает количество секций, то есть 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "header"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "open", sender: nil)
    }
}

class LabelCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
}

