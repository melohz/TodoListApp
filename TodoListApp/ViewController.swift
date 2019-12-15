//
//  ViewController.swift
//  TodoListApp
//
//  Created by 板垣智也 on 2019/12/14.
//  Copyright © 2019 板垣智也. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    @IBOutlet weak var todoInputText: UITextField!
    @IBOutlet weak var todoListContentsTableView: UITableView!
    
    var todoContentsRealm: Results<TodoModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let readRealmInstance = try! Realm()
        
        self.todoContentsRealm = readRealmInstance.objects(TodoModel.self)
    }
    
    @IBAction func tapAddButton(_ sender: Any) {
        let todoModel: TodoModel = TodoModel()
        
        todoModel.todoContent = self.todoInputText.text
        
        let writeRealmInstance = try! Realm()
        
        try! writeRealmInstance.write {
            writeRealmInstance.add(todoModel)
        }
        
        self.todoListContentsTableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoContentsRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoContentCell", for: indexPath)
        
        let content: TodoModel = self.todoContentsRealm[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = content.todoContent
        
        return cell
    }
}
