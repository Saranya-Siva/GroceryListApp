//
//  AddGroceryView.swift
//  coreDataDemoApp
//
//  Created by Saranya Kalyanasundaram on 5/31/20.
//  Copyright © 2020 Saranya. All rights reserved.
//

import UIKit
import CoreData

enum pageType{
    case addGrocery
    case groceryDetail
}
class AddGroceryView: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateFieldSelected: UIDatePicker!
    
    var currentPageType : pageType = .addGrocery
    var currentManagedObject : NSManagedObject?
    var currentGroceryItem : Grocery?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapRecognizer)
        itemNameField.delegate = self
        setUpUIElements()
    }
    
    
    // MARK: - Helper methods
    @objc func imageViewTapped(){
        print("imageTapped")
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker,animated: true, completion: nil)
    }
    
    func setUpUIElements(){
        switch currentPageType{
        case .addGrocery:
            //imageView.image = nil
            itemNameField.text = nil
            dateFieldSelected.date = Date()
        case .groceryDetail:
            if let groceryItem = currentGroceryItem{
                imageView.image = UIImage(data: groceryItem.groceryImage!)
                itemNameField.text = groceryItem.name
                dateFieldSelected.date = groceryItem.addedDate ?? Date()
            }
        }
    }
    func createGroceryItem(){
        if currentGroceryItem == nil {
            
            let groceryItem = Grocery(context: ViewController.managedObjectContext)
        
            if let groceryImage = imageView.image {
                groceryItem.groceryImage = groceryImage.pngData()
            }
            groceryItem.name = itemNameField.text
            
            groceryItem.addedDate = dateFieldSelected.date
            
        }
        else{
             if let groceryImage = imageView.image {
                currentGroceryItem?.setValue(groceryImage.pngData(), forKey: "groceryImage")
            }
            currentGroceryItem?.setValue(itemNameField.text, forKey: "name")
            currentGroceryItem?.setValue(dateFieldSelected.date, forKey: "addedDate")
        }
        
        do{
            try ViewController.managedObjectContext.save()
            if let originalView = self.navigationController?.viewControllers[0] as? ViewController{
                originalView.getTableData()
            }
            self.navigationController?.popViewController(animated: true)
            //getTableData()
        }
        catch{
            showAlert(message: "Couldn save the data\(error.localizedDescription) ")
        }
            
            
            
    }
    
    func showAlert(message : String){
        let alert = UIAlertController(title: "Data Demo", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
   // MARK: - DelegateMethods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            picker.dismiss(animated: true, completion:{
                //self.createGroceryItem(image:image)
                self.imageView.image = image
             })
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }

    // MARK: - Handler methods
    @IBAction func cancelClicked(_ sender: Any) {
        print("cancel clicked")
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveNewGroceryItem(_ sender: Any) {
        if itemNameField.text == ""{
            showAlert(message: "Please enter item Name")
        }
        else{
            createGroceryItem()
        }
    
    }
}
