//
//  Item.swift
//  gotodo
//
//  Created by aisenur on 23.03.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isDone: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
