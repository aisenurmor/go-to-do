//
//  Category.swift
//  gotodo
//
//  Created by aisenur on 23.03.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date = Date()
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
