//
//  TodoModel.swift
//  TodoListApp
//
//  Created by 板垣智也 on 2019/12/15.
//  Copyright © 2019 板垣智也. All rights reserved.
//

import Foundation
import RealmSwift

class TodoModel: Object {
    @objc dynamic var todoContent: String? = nil
}
