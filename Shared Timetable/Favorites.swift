//
//  Favorites.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 01/03/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func unconfirmedAction(_ sender: Any) {
        performSegue(withIdentifier: "unconfirmed", sender: nil)
    }
    
    @IBAction func newFavoriteAction(_ sender: Any) {
        performSegue(withIdentifier: "newFavorite", sender: nil)
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! FavoritesCell //cell - ячейка таблицы
        cell.cellLabel.text = "kekekekek"
        return cell
    }
    
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //возвращает количество секций, то есть 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //отвечает за заголовок
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class FavoritesCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
}


class UnconfirmedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unconfirmedCell") as! UnconfirmedCell //cell - ячейка таблицы
        cell.cellLabel.text = "kekekekek"
        return cell
    }
    
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //возвращает количество секций, то есть 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //отвечает за заголовок
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class UnconfirmedCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
}


class NewFavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newFavoriteCell") as! NewFavoriteCell //cell - ячейка таблицы
        cell.cellLabel.text = "kekekekek"
        return cell
    }
    
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    //возвращает количество секций, то есть 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //отвечает за заголовок
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

class NewFavoriteCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
}















