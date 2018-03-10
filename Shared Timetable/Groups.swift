//
//  ViewController.swift
//  Shared Timetable
//
//  Created by Даниил Пес Кудрявцев on 26/01/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit
import CalendarKit
import Foundation

class Group {
    var name: String!
    var id: String!
}

let user = User()

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    var amountOfGroups: Int?
    var groups = [Group]()
    
    override func viewWillAppear(_ animated: Bool) {
        if user.relogin {
            getData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
    }
    
    func getData() {
        //Checks whether user is logged in
        let login = UserDefaults.standard.value(forKey: "login") as? String ?? ""
        let password = UserDefaults.standard.value(forKey: "password") as? String ?? ""
        print(login)
        print(password)
        if login.isEmpty || password.isEmpty {
            print("Not logged in")
            self.performSegue(withIdentifier: "authorization", sender: nil)
        }
        else {
            let postString = "login=\(login)&password=\(password)"
            let myURL = URL(string: "http://188.166.110.14/signin?\(postString)")!
            let session = URLSession(configuration: URLSessionConfiguration.default)
            session.dataTask(with: myURL) { (_, response, error) in
                DispatchQueue.main.async {
                    guard let response = response as? HTTPURLResponse else {
                        // Error handle
                        return
                    }
                    let status = response.statusCode
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    print("response status: \(status)")
                    switch status {
                    case 202:
                        print("Logged in")
                    case 401:
                        self.performSegue(withIdentifier: "authorization", sender: nil)
                    default:
                        print("unknown status code")
                    }
                }
                }.resume()
        }
        
        //Receiving user groups information from server
        let postString = "login=\(login)"
        let myURL = URL(string: "http://188.166.110.14/user_groups?\(postString)")!
        URLSession.shared.dataTask(with: myURL) { (data, response, error) -> Void in
            
            guard let data = data else {
                print("No data received")
                return
            }
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    self.amountOfGroups = jsonObject["amount"] as? Int
                    if self.amountOfGroups == nil {
                        print("nil")
                    }
                    print(self.amountOfGroups!)
                    var groups = [Group]()
                    //Main thread implementation
                    if self.amountOfGroups! > 0 {
                        let dictionary = jsonObject["groups"] as? [[String:Any]]
                        for groupInfo in dictionary! {
                            let group = Group()
                            group.id = groupInfo["id"] as? String ?? ""
                            group.name = groupInfo["name"] as? String ?? ""
                            print(group.name!)
                            print(group.id!)
                            groups.append(group)
                        }
                        //Main thread implementation
                        DispatchQueue.main.async {
                            self.groups = groups
                            //End of groups information receiving
                            user.relogin = false
                        }
                    }
                    //Main thread implementation
                    DispatchQueue.main.async {
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
    
    //Logging out
    @IBAction func quitAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to quit?", message: nil, preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Quit", style: .destructive) { (_) in
            let defaults = UserDefaults.standard
            defaults.setValue("", forKey: "login")
            defaults.setValue("", forKey: "password")
            defaults.synchronize()
            user.relogin = true
            user.updateFavorites = true
            self.performSegue(withIdentifier: "authorization", sender: nil)
        }
        alertController.addAction(yesAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        if item.title == "Groups" {
            print("kek")
        }
    }
    
    //создание новой ячейки
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupsCell") as! GroupsCell //cell - ячейка таблицы
        cell.cellLabel.text = groups[indexPath.row].name
        return cell
    }
    //возвращает количество ячеек
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if amountOfGroups != nil {
            return amountOfGroups!
        }
        return 0
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
        //tableView.cellForRow(at: indexPath)?.prepareForReuse()
        tableView.deselectRow(at: indexPath, animated: true)
        
        //переход к календарю
        let controller = EventsViewController()
        controller.hidesBottomBarWhenPushed = true
        controller.navigationItem.title = groups[indexPath.row].name
        show(controller, sender: nil)
        //performSegue(withIdentifier: "open", sender: nil)
    }
    
    @IBAction func newGroupAction(_ sender: Any) {
        performSegue(withIdentifier: "newGroup", sender: nil)
    }
}

class GroupsCell: UITableViewCell {
    
    @IBOutlet weak var cellLabel: UILabel!

}

