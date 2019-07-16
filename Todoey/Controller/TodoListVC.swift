//
//  ViewController.swift
//  Todoey
//
//  Created by Muhammad El Zedy on 7/11/19.
//  Copyright © 2019 ZozShark. All rights reserved.
//

import UIKit

class TodoListVC: UITableViewController {

    var item  = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

    }

    //MARK - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        let cellItem = item[indexPath.row]
        
        cell.textLabel?.text = cellItem.title
        
        cell.accessoryType = cellItem.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        item[indexPath.row].done = !item[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //MARK - Add New Item
    @IBAction func AddBtnPressed(_ sender: UIBarButtonItem) {
        
        var LtextField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What Will happen when the user clicks the add item button on our alert
            let freshItem = Item()
            freshItem.title = LtextField.text!
            self.item.append(freshItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            LtextField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
       
    }
    
    func saveItems(){
       
        
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(item)
            try data.write(to:dataFilePath!)
        }catch{
            print("Error encoding item, \(error)")
        }
        self.tableView.reloadData()
    }
    
   func loadItems(){
    
    if  let data = try? Data(contentsOf : dataFilePath!){
        let decoder = PropertyListDecoder()
        do{
            item  = try decoder.decode([Item].self, from: data) 
            
        }catch{
            print("Error encoding item, \(error)")
        }
        
    }
    }
    
    

}

