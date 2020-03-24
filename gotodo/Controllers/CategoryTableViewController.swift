//
//  CategoryTableViewController.swift
//  gotodo
//
//  Created by aisenur on 22.03.2020.
//  Copyright © 2020 aisenur. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeTableViewController {
    var realm = try! Realm()
    var categoryArray: Results<Category>? // auto reload
    var colorArray = ["#eb3b5a", "#fa8231", "#f7b731", "#20bf6b", "#fc5c65", "#20bf6b", "#0fb9b1", "#2d98da", "#3867d6", "#8854d0", "#a5b1c2", "#4b6584"]
    
    @IBOutlet var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(hexString: "#FAFAFA")
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.") }
        Utils.statusBarColorOptions(color: "#706fd3")
        navBar.backgroundColor = UIColor(hexString: "#706fd3")
        navBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: ContrastColorOf(UIColor(hexString: "#706fd3")!, returnFlat: true)]
    }
    
    //MARK: - TableView Datasoruce Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numOfSections: Int = 0
        if categoryArray!.count > 0 {
            numOfSections            = categoryArray!.count
            tableView.backgroundView = nil
            tableView.backgroundColor = UIColor(hexString: "#FAFAFA")
        }
        else {
            tableView.backgroundView  = noDataView
        }
        return numOfSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No category added yet."
        cell.textLabel?.textColor = ContrastColorOf(UIColor(hexString: categoryArray?[indexPath.row].color ?? "#706fd3")!, returnFlat: true)
        cell.backgroundColor = UIColor(hexString: categoryArray?[indexPath.row].color ?? "#706fd3")
        
        return cell
    }
    
    //MARK: - Data Manipulation Methods
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving context, \(error)")
        }
        tableView.reloadData()
    }
    
    func loadCategories() {
        categoryArray = realm.objects(Category.self).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let item = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(item)
                }
            } catch {
                print("Error delete category, \(error)")
            }
        }
    }
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        var textField = UITextField()
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        alert.addAction(UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            if let randomElement = self.colorArray.randomElement() {
                newCategory.color = randomElement
            }
            self.save(category: newCategory)
        })
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            alertTextField.autocorrectionType = .no
            alertTextField.autocapitalizationType = .words
            
            textField = alertTextField
        }
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
        
    }
}
