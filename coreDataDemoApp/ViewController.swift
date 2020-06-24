//
//  ViewController.swift
//  coreDataDemoApp
//
//  Created by Saranya Kalyanasundaram on 5/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var groceriesTableView: UITableView!
    static var managedObjectContext  : NSManagedObjectContext!
    var groceries = [Grocery]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        ViewController.managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        getTableData()
    }
   
    
    // MARK: - Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groceries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as! GroceryItemCell
        cell.setData(groceries[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let addGroceryView = storyboard?.instantiateViewController(identifier: "GroceryDetailsView") as? AddGroceryView else{ return }
        
        addGroceryView.currentPageType = .groceryDetail
        let item = groceries[indexPath.row]
        addGroceryView.currentGroceryItem = item
       // addGroceryView.currentManagedObject = getSelectedDataObject(name: item.name!, addedDate: item.addedDate!)
        navigationController?.pushViewController(addGroceryView, animated: true)
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            
            DispatchQueue.global(qos: .userInitiated).async{[weak self] in
                ViewController.managedObjectContext.delete((self?.groceries[indexPath.row])!)
                
                DispatchQueue.main.async {[weak self] in
                    self?.groceries.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .left)
                }
            }
            do{
                try ViewController.managedObjectContext.save()
            }
            catch{
                print("could not save the changes ")
            }
            
        }
    }
    
    // MARK: - Helper methods
    func getTableData(){
        let groceryFetchRequest : NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do{
            groceries = try ViewController.managedObjectContext.fetch(groceryFetchRequest)
            groceriesTableView.reloadData()
        }
        catch{
            print("Couldn load data from the database \(error.localizedDescription)")
        }
        
    }
    
    @IBAction func addGroceryClicked(_ sender: Any) {
        guard let addGroceryView = storyboard?.instantiateViewController(identifier: "GroceryDetailsView") as? AddGroceryView else{ return }
        
        addGroceryView.currentPageType = .addGrocery
        navigationController?.pushViewController(addGroceryView, animated: true)
        
    }
    
    
    func getSelectedDataObject(name : String, addedDate : Date ) -> NSManagedObject?{
        let fetchRequest : NSFetchRequest<Grocery>  = Grocery.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name = %@ AND addedDate = %@", argumentArray: [name,addedDate])
        var fetchedItem : NSManagedObject? 
        do{
            let results = try ViewController.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                fetchedItem =  results?[0]
            }
               
        }
        catch{
            print("Couldn load data from the database \(error.localizedDescription)")
            
        }
        return fetchedItem
    }
    
    
   
    
}

