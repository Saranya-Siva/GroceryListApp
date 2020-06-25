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
    var currentGroceryItem : Grocery?
    var groceryManager = GroceryManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageViewTapped))
//        imageView.isUserInteractionEnabled = true
//        imageView.addGestureRecognizer(tapRecognizer)
        itemNameField.delegate = self
        setUpUIElements()
    }
    
    
    // MARK: - Helper methods
   @IBAction func imageButtonTapped(_ sender: Any){
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
            
            groceryManager.createNewGrocery(name : itemNameField.text!, date : dateFieldSelected.date, image: imageView.image){(err) in
                if let err = err {
                    showAlert(message: err.localizedDescription)
                }
                else{
                    if let originalView = self.navigationController?.viewControllers[0] as? ViewController{
                        groceryManager.fetchGroceryData(){(err) in
                            if let err = err {
                                print("message: \(err.localizedDescription)")
                            }
                        }
                        originalView.groceriesTableView.reloadData()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        else{
            
            groceryManager.updateGroceryData(for : currentGroceryItem!, name : itemNameField.text!, date : dateFieldSelected.date, image:  imageView.image){(err) in
                if let err = err {
                    showAlert(message: err.localizedDescription)
                }
                else{
                    if let originalView = self.navigationController?.viewControllers[0] as? ViewController{
                        originalView.groceriesTableView.reloadData()
                    }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        
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
