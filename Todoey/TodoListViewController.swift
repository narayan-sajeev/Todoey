//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

// UITableViewController takes care of many of the delegate events and IBActions/IBOutlets that would have been necessary when inheriting from UIViewController
class TodoListViewController: UITableViewController {

    var itemArray = ["Homework", "Reading", "Writing"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        sets items to the array of keys stored in the defaults of the phone
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
        
    }

    
    //MARK: - TableView Datasource Methods
    
    
//    tells the tableview how many rows to make
//    returns an int, the length of the array
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

//    asks the data source for a cell to insert in a certain row of the table
//    returns a UITableViewCell, the cell in the row given
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        create the cell from a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
//        set the text of the label of the cell to the element in the array with that index
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
 
//    deals with what happens when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
//        if the cell is selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            deselect it
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
//            if it is not selected, select it
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
//        deselect the row
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    

    //MARK: - Add New Items

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
        var textField = UITextField()
        
//        creates an alert to be displayed
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
    
//        creates the action for the alert (the button names, the styles of the buttons, what happens when its done
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            runs once user clicks "Add Item" button on UIAlert
            
//            try to open the text the user entered
            if let item = textField.text {
                
//                add it to the list
                self.itemArray.append(item)
                
//                saves the item array internally
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
                
//                and refresh the table
                self.tableView.reloadData()
                
            }
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
     
//        puts the action into the alert
        alert.addAction(action)
        
//        presents the alert
        present(alert, animated: true, completion: nil)
        
    }
    
}
