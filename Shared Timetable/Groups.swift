//
//  ViewController.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 26/01/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import UIKit
import CalendarKit

class GroupsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        //проверка на авторизованность
        let login = UserDefaults.standard.value(forKey: "login") as? String ?? ""
        let password = UserDefaults.standard.value(forKey: "password") as? String ?? ""
        print(login)
        print(password)
        
        if login.isEmpty || password.isEmpty {
            self.performSegue(withIdentifier: "authorization", sender: nil)
        }
        else {
            let postString = "login=\(login)&password=\(password)"
            let myURL = URL(string: "https://mighty-springs-49939.herokuapp.com/signin?\(postString)")!
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
                        print("already logged in")
                    case 401:
                        self.performSegue(withIdentifier: "authorization", sender: nil)
                    default:
                        print("unknown status code")
                    }
                }
                }.resume()
        }
        // Do any additional setup after loading the view, typically from a nib.
        //performSegue(withIdentifier: "authorization", sender: nil)
    }
    
    
    //выход из профиля
    @IBAction func quitAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.setValue("", forKey: "login")
        defaults.setValue("", forKey: "password")
        defaults.synchronize()
        performSegue(withIdentifier: "authorization", sender: nil)
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
        //переход к календарю
        let controller = EventsViewController()
        show(controller, sender: nil)
        //performSegue(withIdentifier: "open", sender: nil)
    }
    
    @IBAction func newGroupAction(_ sender: Any) {
        performSegue(withIdentifier: "newGroup", sender: nil)
    }
    
    
}

class LabelCell: UITableViewCell {
    
    @IBOutlet weak var label1: UILabel!
}

