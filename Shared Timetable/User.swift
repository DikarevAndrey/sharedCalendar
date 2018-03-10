//
//  User.swift
//  Shared Timetable
//
//  Created by Даниил Кудрявцев on 14/02/2018.
//  Copyright © 2018 Даниил Кудрявцев. All rights reserved.
//

import Foundation
import UIKit
import CalendarKit

class User {
    public var relogin = true
    public var updateFavorites = true
    public var groups = [Group]()
    public var favorites = [String]()
    public var unconfirmed = [String]()
}
