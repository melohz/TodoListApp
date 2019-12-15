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
    
    // 追加ボタンタップ
    @IBAction func tapAddButton(_ sender: Any) {
        
        if !isNewTodoValidated() { return }
        
        let todoModel: TodoModel = TodoModel()
        
        todoModel.todoContent = self.todoInputText.text
        
        let writeRealmInstance = try! Realm()
        
        try! writeRealmInstance.write {
            writeRealmInstance.add(todoModel)
        }
        
        self.todoInputText.text = ""
        self.todoListContentsTableView.reloadData()
    }
    
    func isNewTodoValidated() -> Bool {
        guard let inputText = todoInputText.text else { return false }
        if inputText.isEmpty {
            alertDialog(title: "Input error", message: "Todo description is empty")
            return false
        }
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (todoInputText.isFirstResponder) {
            todoInputText.resignFirstResponder()
        }
    }
    
    func alertDialog(title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(defaultAction)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todoContentsRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoContentCell", for: indexPath)
        
        let content: TodoModel = self.todoContentsRealm[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = content.todoContent
        
        return cell
    }
    
    // Tells the delegate that the specified row is now selected.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (todoInputText.isFirstResponder) {
            todoInputText.resignFirstResponder()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let deleteRealmInstance = try! Realm()
            if let deleteTargetString = todoContentsRealm[indexPath.row].todoContent {
                let deleteTarget = deleteRealmInstance.objects(TodoModel.self).filter("todoContent == %@", deleteTargetString)
                try! deleteRealmInstance.write {
                    deleteRealmInstance.delete(deleteTarget)
                }
                
                tableView.deleteRows(at: [indexPath as IndexPath], with: UITableView.RowAnimation.automatic)
            }
            
        } else if editingStyle == UITableViewCell.EditingStyle.insert {
            	
        }
    }
}
