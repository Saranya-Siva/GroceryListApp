//
//  GroceryManager.swift
//  coreDataDemoApp
//
//  Created by Saranya Kalyanasundaram on 6/25/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct GroceryManager{
    
    var groceries = [Grocery]()
    let managedObjectContext : NSManagedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func getGroceryItem(_ index : Int) -> Grocery{
        return groceries[index]
    }
    
    mutating func removeGroceryItem (at index: Int){
        
        groceries.remove(at: index)
        
    }
    
    mutating func fetchGroceryData(completion:(_ err : Error?) -> ()){
        let groceryFetchRequest : NSFetchRequest<Grocery> = Grocery.fetchRequest()
        do{
            groceries = try managedObjectContext.fetch(groceryFetchRequest)
        }
        catch{
            completion(error)
        }
        
    }
    
    
    func createNewGrocery(name : String, date : Date, image: UIImage?, completion: (_ error : Error?)->()){
        
        let groceryItem = Grocery(context: managedObjectContext)
        
        if let groceryImage = image {
            groceryItem.groceryImage = groceryImage.pngData()
        }
        groceryItem.name = name
        
        groceryItem.addedDate = date
        
        do{
            try managedObjectContext.save()
            completion(nil)
        }
        catch{
            completion(error)
        }
    }
    func updateGroceryData(for item : Grocery, name : String, date : Date, image: UIImage?, completion: (_ error : Error?)->()){
        if let groceryImage = image {
            item.setValue(groceryImage.pngData(), forKey: "groceryImage")
        }
        item.setValue(name, forKey: "name")
        item.setValue(date, forKey: "addedDate")
        
        do{
            try managedObjectContext.save()
            completion(nil)
        }
        catch{
            completion(error)
        }
    }
}
