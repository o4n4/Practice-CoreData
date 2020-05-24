//
//  ViewController.swift
//  ToDoList_CoreData
//
//  Created by Ioana Gadinceanu on 5/23/20.
//  Copyright © 2020 Ioana Gadinceanu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   
   @IBOutlet weak var tableView: UITableView!
   
   var itemName: [NSManagedObject] = []
   
   //MARK: ViewDidLoad()
   override func viewDidLoad() {
      super.viewDidLoad()
   }
   
   
   //MARK: ViewWillAppear
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Title")
      
      do {
         itemName = try context.fetch(fetchRequest)
      }
         
      catch {
         print("Error in loading data.")
      }
   }
   
   
   //MARK: TextField
   var titleTextField: UITextField!
   
   func titleTextField(textField: UITextField) {
      titleTextField = textField
      titleTextField.placeholder = "Item Name"
   }
   
   
   //MARK: Add button
   @IBAction func addButton(_ sender: UIBarButtonItem) {
      
      let alert = UIAlertController(title: "New todo item",
         message: "Insert the title of the new todo item:",
         preferredStyle: .alert)
      
      
      let addAction = UIAlertAction(title: "Save", style: .default, handler: self.save)
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

      alert.addAction(addAction)
      alert.addAction(cancelAction)

      alert.addTextField(configurationHandler: titleTextField)
      self.present(alert, animated: true, completion: nil)
   }
   
   //MARK: Remove using CoreData
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      
      if editingStyle == UITableViewCell.EditingStyle.delete {
         
         let appDelegate =   UIApplication.shared.delegate as! AppDelegate
         let context = appDelegate.persistentContainer.viewContext
         context.delete(itemName[indexPath.row])
         itemName.remove(at: indexPath.row)
         
         do {
            try context.save()
            
         }
         catch {
            print("There was an error in deleting item.")
         }
         self.tableView.reloadData()
      }
   }
   
   //MARK: saving using CoreData
   func save(alert: UIAlertAction) {
      
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let entity = NSEntityDescription.entity(forEntityName: "Title", in: context)!
      let theTitle = NSManagedObject(entity: entity, insertInto: context)
      theTitle.setValue(titleTextField.text, forKey: "title")
      
      do {
         try context.save()
         itemName.append(theTitle)
      }
      catch {
         print("There was an error in saving. ")
      }
      self.tableView.reloadData()
   }
   
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return itemName.count
   }
   
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let title = itemName[indexPath.row]
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      cell.textLabel?.text = title.value(forKey: "title") as? String
      return cell
   }
}

