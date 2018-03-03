//
//  NewGroup.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 18/02/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit
import CalendarKit
import Foundation

var members = [String]()

class MembersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var nextBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
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
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        nextBarButtonItem.isEnabled = false
        if members.count > 0 {
            nextBarButtonItem.isEnabled = true
        }
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
    
    
    @IBAction func cancelAction(_ sender: Any) {
        members = [String]()
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func nextAction(_ sender: Any) {
        performSegue(withIdentifier: "newGroupNext", sender: nil)
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newMemberCell") as! NewMemberCell //cell - ячейка таблицы
        let user = users[indexPath.row]
        cell.cellLabel.text = user
        if members.contains(user) {
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
    
    //отвечает за заголовок таблицы
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Users found:"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        if members.contains(user) {
            var copyMembers = [String]()
            for m in members {
                if m != user {
                    copyMembers.append(m)
                }
            }
            members = copyMembers
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            members.append(user)
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        if members.count > 0 {
            nextBarButtonItem.isEnabled = true
        } else {
            nextBarButtonItem.isEnabled = false
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class NewMemberCell: UITableViewCell {
    @IBOutlet weak var cellLabel: UILabel!
}

class GroupCreatingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let createBarButtonItem = UIBarButtonItem(
        title: "Create",
        style: .done,
        target: self,
        action: #selector(createAction)
    )
    
    @IBOutlet weak var groupNameTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var stripLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var stripLabel: UILabel!
    @IBOutlet weak var membersTableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var membersTableView: UITableView!
    override func viewDidLoad() {
        stripLabel.backgroundColor = UIColor.lightGray
        let screenHeight = view.frame.height
        groupNameTextFieldConstraint.constant = screenHeight/5
        stripLabelConstraint.constant = screenHeight/100
        membersTableViewConstraint.constant = screenHeight/15
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.rightBarButtonItem = createBarButtonItem
        createBarButtonItem.tintColor = UIColor.green
        createBarButtonItem.isEnabled = false
        groupNameTextField.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        groupNameTextField.delegate = self
        super.viewDidLoad()
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
    
    func editingChanged(_ textField: UITextField) {
        createBarButtonItem.isEnabled = false
        if !(groupNameTextField.text ?? "").isEmpty {
            createBarButtonItem.isEnabled = true
        }
    }
    func createAction() {
        print("kek")
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell") as! MemberCell //cell - ячейка таблицы
        cell.label.text = members[indexPath.row]
        return cell
    }
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    //возвращает количество секций, то есть 1
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //отвечает за заголовок таблицы
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Members"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
}
