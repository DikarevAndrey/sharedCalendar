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
    
    override func viewWillAppear(_ animated: Bool) {
        if user.updateFavorites {
            getFavorites()
        }
    }
    
    func getFavorites() {
        //Receiving user groups information from server
        let admin = UserDefaults.standard.value(forKey: "login") as? String ?? ""
        let postString = "login=\(admin)"
        let myURL = URL(string: "http://188.166.110.14/favs?\(postString)")!
        URLSession.shared.dataTask(with: myURL) { (data, response, error) -> Void in
            
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    let amount = jsonObject["amount"] as? Int
                    //Main thread implementation
                    var favoriteUsers = [String]()
                    if amount! > 0 {
                        //Main thread implementation
                        favoriteUsers = jsonObject["favs"] as! [String]
                    }
                    DispatchQueue.main.async {
                        user.favorites = favoriteUsers
                        self.tableView.reloadData()
                        user.updateFavorites = false
                    }
                } else {
                    print("JSON failed")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritesCell") as! FavoritesCell //cell - ячейка таблицы
        cell.cellLabel.text = user.favorites[indexPath.row]
        return cell
    }
    
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.favorites.count
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func unconfirmedAction(_ sender: Any) {
        performSegue(withIdentifier: "unconfirmed", sender: nil)
    }
    
    @IBAction func newFavoriteAction(_ sender: Any) {
        performSegue(withIdentifier: "newFavorite", sender: nil)
    }
}

class FavoritesCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
}


class UnconfirmedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmBarButtonItem: UIBarButtonItem!
    
    var usersToConfirm = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        confirmBarButtonItem.title = "Confirm"
        confirmBarButtonItem.isEnabled = false
        getUnconfirmed()
    }
    
    
    func getUnconfirmed() {
        let admin = UserDefaults.standard.value(forKey: "login") as? String ?? ""
        let postString = "login=\(admin)"
        let myURL = URL(string: "http://188.166.110.14/unconfirmed_favs?\(postString)")!
        print("getting unconfirmed " + postString)
        URLSession.shared.dataTask(with: myURL) { (data, response, error) -> Void in
            
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    let amount = jsonObject["amount"] as? Int
                    //Main thread implementation
                    var unconfirmedUsers = [String]()
                    if amount! > 0 {
                        unconfirmedUsers = jsonObject["users"] as! [String]
                    }
                    DispatchQueue.main.async {
                        user.unconfirmed = unconfirmedUsers
                        self.tableView.reloadData()
                    }
                } else {
                    print("JSON failed")
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            }.resume()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        user.updateFavorites = true
        let admin = UserDefaults.standard.value(forKey: "login") as? String ?? ""
        let myUrl = URL(string: "http://188.166.110.14/confirm_fav?")!
        for u in usersToConfirm {
            let postString = "to=\(admin)&from=\(u)"
            print(postString)
            var request = URLRequest(url: myUrl)
            request.httpMethod = "POST"
            request.httpBody = postString.data(using: .utf8)
            URLSession.shared.dataTask(with: request) { (_, response, error) -> Void in
                DispatchQueue.main.async {
                    guard let response = response as? HTTPURLResponse else {
                        // Error handle
                        print("No internet connection")
                        return
                    }
                    let status = response.statusCode
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    //print("response status: \(status)")
                    switch status {
                    case 200:
                        print("Users confirmation: OK")
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                        }
                    case 405:
                        print("Users confirmation: No such request received")
                    case 500:
                        print("Users confirmation: chosen users not confirmed")
                    default:
                        print("unknown status code")
                    }
                    //print("responseString = \(responseString)")
                }
                }.resume()
        }
    }
    
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "unconfirmedCell") as! UnconfirmedCell //cell - ячейка таблицы
        cell.cellLabel.text = user.unconfirmed[indexPath.row]
        if usersToConfirm.contains(user.unconfirmed[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.unconfirmed.count
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
        if usersToConfirm.contains(user.unconfirmed[indexPath.row]) {
            var copyUsersToConfirm = [String]()
            for u in usersToConfirm {
                if u != user.unconfirmed[indexPath.row] {
                    copyUsersToConfirm.append(u)
                }
            }
            usersToConfirm = copyUsersToConfirm
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            usersToConfirm.append(user.unconfirmed[indexPath.row])
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        if usersToConfirm.count > 0 {
            confirmBarButtonItem.isEnabled = true
            if usersToConfirm.count == 1 {
                confirmBarButtonItem.title = "Confirm " + String(usersToConfirm.count) + " user"
            }
            else {
                confirmBarButtonItem.title = "Confirm " + String(usersToConfirm.count) + " users"
            }
        } else {
            confirmBarButtonItem.title = "Confirm"
            confirmBarButtonItem.isEnabled = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

class UnconfirmedCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
}


class NewFavoriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButtonItem: UIBarButtonItem!
    
    /*let addBarButtonItem = UIBarButtonItem(
        title: "Add",
        style: .done,
        target: self,
        action: #selector(addAction)
    )*/
    var usersToAdd = [String]()
    var amountOfUsers: Int?
    var users = [String]()
    lazy var searchBar:UISearchBar = UISearchBar()
    override func viewDidLoad() {
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        tableView.tableHeaderView = searchBar
        searchBar.delegate = self
        searchBar.keyboardType = UIKeyboardType.asciiCapable
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        //navigationItem.rightBarButtonItem = addBarButtonItem
        //addBarButtonItem.isEnabled = false
        
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addBarButtonItem.title = "Add"
        addBarButtonItem.isEnabled = false
        if usersToAdd.count > 0 {
            addBarButtonItem.isEnabled = true
            addBarButtonItem.title = "Add " + String(usersToAdd.count)
        }
    }
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    //Hides keyboard when "search" button pressed
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }
    
    //checks if searchText has unexpected symbols (any except ASCII, dots, dashes, underscores)
    func asciiCapable(s: String) -> Bool {
        var flag = true
        for c in s {
            if !((c >= "a" && c <= "z") || (c >= "A" && c <= "Z") || c == "." || c == "_" || c == "-" || c >= "0" && c <= "9") {
                flag = false
            }
        }
        return flag
    }
    
    //Get users for searchText while searchText is being edited
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //checks if searchText has spaces
        var searchTextHasSpace = false
        for character in searchText {
            if character == " " {
                searchTextHasSpace = true
            }
        }
        if !searchText.isEmpty && !searchTextHasSpace && asciiCapable(s: searchText) {
            let postString = "key=\(searchText)"
            let myURL = URL(string: "http://188.166.110.14/find_users?\(postString)")!
            URLSession.shared.dataTask(with: myURL) { (data, response, error) -> Void in
                
                guard let response = response as? HTTPURLResponse else {
                    // Error handle
                    return
                }
                guard let data = data else {
                    print("No data received")
                    return
                }
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        self.amountOfUsers = jsonObject["amount"] as? Int
                        if self.amountOfUsers! > 0 {
                            let users = jsonObject["users"] as? [String]
                            let defaults = UserDefaults.standard
                            let userLogin = defaults.string(forKey: "login")
                            var usersCopy = [String]()
                            for user in users! {
                                if user != userLogin {
                                    usersCopy.append(user)
                                }
                                else {
                                    self.amountOfUsers! = self.amountOfUsers! - 1
                                }
                            }
                            DispatchQueue.main.async {
                                //print(self.amountOfUsers!)
                                self.users = usersCopy
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    } else {
                        print("json failed")
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                }.resume()
        }
        else {
            amountOfUsers = 0
            tableView.reloadData()
        }
    }
    
    @IBAction func addAction(_ sender: Any) {
        let admin = UserDefaults.standard.value(forKey: "login") as? String ?? ""
        let myUrl = URL(string: "http://188.166.110.14/new_favs?")!
        var postString = ""
        for u in usersToAdd {
            postString += "favs[]=\(u)&"
        }
        postString += "from=\(admin)"
        print(postString)
        var request = URLRequest(url: myUrl)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        URLSession.shared.dataTask(with: request) { (_, response, error) -> Void in
            DispatchQueue.main.async {
                guard let response = response as? HTTPURLResponse else {
                    // Error handle
                    print("No internet connection")
                    return
                }
                let status = response.statusCode
                if let error = error {
                    print(error.localizedDescription)
                }
                //print("response status: \(status)")
                switch status {
                case 200:
                    print("Users adding: OK")
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                case 405:
                    print("Users adding: Already waiting for confirmation")
                case 500:
                    print("Users adding: chosen users not added")
                default:
                    print("unknown status code")
                }
                //print("responseString = \(responseString)")
            }
            }.resume()
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newFavoriteCell") as! NewFavoriteCell //cell - ячейка таблицы
        let user = users[indexPath.row]
        cell.cellLabel.text = user
        if usersToAdd.contains(user) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if amountOfUsers == nil {
            return 0
        }
        return amountOfUsers!
    }
    //возвращает количество секций, то есть 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //отвечает за заголовок
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Send request to:"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if usersToAdd.contains(user) {
            var copyUsersToAdd = [String]()
            for m in usersToAdd {
                if m != user {
                    copyUsersToAdd.append(m)
                }
            }
            usersToAdd = copyUsersToAdd
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            usersToAdd.append(user)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        if usersToAdd.count > 0 {
            addBarButtonItem.isEnabled = true
            if usersToAdd.count == 1 {
                addBarButtonItem.title = "Add " + String(usersToAdd.count) + " user"
            }
            else {
                addBarButtonItem.title = "Add " + String(usersToAdd.count) + " users"
            }
        } else {
            addBarButtonItem.title = "Add"
            addBarButtonItem.isEnabled = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

class NewFavoriteCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!
}















