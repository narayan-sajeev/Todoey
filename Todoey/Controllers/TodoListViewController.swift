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

    var itemArray = [Item]()
    
//        sets the file path where we will store the item
        
//        FileManager is an interface to interact with files on the device
//        we are using the default FileManager to retrieve the url for the directory we want to open
//        there is only one directory we want to retrieve, so we pull out the first once
//        appendingPathComponent adds the path of the program itself to the current url so we can get the entire url
//        we pass in Items.plist as the file we want to retrieve
        
//        dataFilePath is an optional, since there might not be any url
    
        let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        prints the local file location where the property list of the items is being stored
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {
//            itemArray = item
//        }
        
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
        
        let item = itemArray[indexPath.row]
        
//        set the text of the label of the cell to the element in the array with that index
        cell.textLabel?.text = item.title
        
//        Ternary operator ->
//        value = condition ? valueIfTrue : valueIfFalse
        
//        sets the cell to check if and only if the item is checked
        cell.accessoryType = item.done ? .checkmark : .none

        return cell
        
    }
    
    
    //MARK: - TableView Delegate Methods
 
//    deals with what happens when a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        sets the done property to the opposite of the current property
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
//        save the items to the file
        saveItems()
        
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
                
//                put the text into the Item object
                let newItem = Item()
                newItem.title = item
                
//                add it to the list
                self.itemArray.append(newItem)
                
//                save the items to the file
                self.saveItems()
                
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
    
//    creates a function to save the items to the list
    func saveItems() {
        
//      create an object to encode the data
        let encoder = PropertyListEncoder()
        
//      try to encode the data
        do {
//          encode the data
            let data = try encoder.encode(itemArray)
//          write the data
            try data.write(to: dataFilePath!)
//       if there is an error
        } catch {
//          print the error
            print("Error", error)
        }
        
//      and refresh the table
        tableView.reloadData()
        
    }
    
}
