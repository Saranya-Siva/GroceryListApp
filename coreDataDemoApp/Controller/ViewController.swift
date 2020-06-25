//
//  ViewController.swift
//  coreDataDemoApp
//
//  Created by Saranya Kalyanasundaram on 5/30/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit
import CoreData


class ViewController: UIViewController{

    @IBOutlet weak var groceriesTableView: UITableView!
    
    var groceryManager = GroceryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        groceryManager.fetchGroceryData(){(err) in
            if let err = err {
                print("message: \(err.localizedDescription)")
            }
        }
    }
   
    
    @IBAction func addGroceryClicked(_ sender: Any) {
        guard let addGroceryView = storyboard?.instantiateViewController(identifier: "GroceryDetailsView") as? AddGroceryView else{ return }
        
        addGroceryView.currentPageType = .addGrocery
        navigationController?.pushViewController(addGroceryView, animated: true)
        
    }
     
}

extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - Delegate Methods
       func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           groceryManager.groceries.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as! GroceryItemCell
           let groceryDataForCell = groceryManager.getGroceryItem(indexPath.row)
           cell.setData(groceryDataForCell)
           return cell
       }
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
           guard let addGroceryView = storyboard?.instantiateViewController(identifier: "GroceryDetailsView") as? AddGroceryView else{ return }
           
           addGroceryView.currentPageType = .groceryDetail
           let item = groceryManager.getGroceryItem(indexPath.row)
           addGroceryView.currentGroceryItem = item
         
           navigationController?.pushViewController(addGroceryView, animated: true)
           
       }
       
       func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
           
           if editingStyle == .delete{
               
               groceryManager.managedObjectContext.delete(groceryManager.groceries[indexPath.row])
               
               DispatchQueue.main.async {[weak self] in
                   self?.groceryManager.removeGroceryItem(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .left)
               }
               
               do{
                   try groceryManager.managedObjectContext.save()
               }
               catch{
                   print("could not save the changes ")
               }
               
           }
       }
       
    
    
}
