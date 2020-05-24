//
//  ViewController.swift
//  My Todo App
//
//  Created by Ioana Gadinceanu on 5/24/20.
//  Copyright © 2020 Ioana Gadinceanu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UITableViewController {
   
   //   private var todoItems = TodoItem.getMockedData()
   private var todoItems = [TodoItem]()
   
   @objc func didTapAddItemButton(_ sender: UIBarButtonItem) {
      
      //Create an allert
      let alert = UIAlertController(title: "New todo item",
                                    message: "Insert the title of the new todo item:",
                                    preferredStyle: .alert)
      
      //Add textField to the alert
      alert.addTextField(configurationHandler: nil)
      
      //Add cancel button
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      
      //Add ok button
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
         
         if let title = alert.textFields?[0].text {
            self.addNewTodoItem(title: title)
         }
      }))
      
      //Present alert to user
      self.present(alert, animated: true, completion: nil)
   }
   
   
   //MARK: Add new items
   private func addNewTodoItem(title: String) {
      
      //The index of the new item will be the current item count
      let newIndex = todoItems.count
      
      // Create new item and add it to the todo items list
      todoItems.append(TodoItem(title: title))
      
      //Tell table view a new row has been created
      tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .top)
   }
   

   
   //MARK: ViewDidLoad()
   override func viewDidLoad() {
      super.viewDidLoad()
      self.title = "To do"
      
      navigationController?.navigationBar.prefersLargeTitles = true
      self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(ViewController.didTapAddItemButton(_:)))
      tableView.allowsMultipleSelectionDuringEditing = true
   }
   
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return todoItems.count
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell_todo", for: indexPath)
      
      if indexPath.row < todoItems.count {
         let item = todoItems[indexPath.row]
         cell.textLabel?.text = item.title
         
         let accessory: UITableViewCell.AccessoryType = item.done ? .checkmark : .none
         cell.accessoryType = accessory
      }
      return cell
   }
   
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      if indexPath.row < todoItems.count {
         let item = todoItems[indexPath.row]
         item.done  = !item.done
         
         tableView.reloadRows(at: [indexPath], with: .automatic)
      }
   }
   
   //MARK: Remove items
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
      if indexPath.row < todoItems.count {
         todoItems.remove(at: indexPath.row)
         tableView.deleteRows(at: [indexPath], with: .top)
      }
   }
   
   //MAK: Editing items
   override func setEditing(_ editing: Bool, animated: Bool) {
       super.setEditing(editing, animated: true)
       tableView.setEditing(tableView.isEditing, animated: true)
    }
   
      //MARK: title for header in Section
      override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
         var title: String? = "Section"
         return title
   }
}

