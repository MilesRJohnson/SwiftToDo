//
//  DetailViewController.swift
//  SwiftToDo
//
//  Created by Miles Johnson on 7/7/15.
//  Copyright (c) 2015 StarShip Enterprise. All rights reserved.
//

import UIKit
import CoreData
class DetailViewController: UIViewController, UITextFieldDelegate {
    
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var                    selectedItem          :Items?
    private var            currentItem           :Items! //unwrapped version
    
    @IBOutlet private var  saveButton            :UIBarButtonItem!
    @IBOutlet private var  nameTextField         :UITextField!
    @IBOutlet private var  descriptionTextField  :UITextField!
    @IBOutlet private var  typeSegControl        :UISegmentedControl!
    @IBOutlet private var  importanceSegControl  :UISegmentedControl!
    @IBOutlet private var  completeSwitch        :UISwitch!
    @IBOutlet private var  datesLabel            :UILabel!
    @IBOutlet private var  dateDuePicker         :UIDatePicker!
    // MARK: - Interactvitiy Methods
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func saveButtonPressed(sender: UIBarButtonItem) {
        currentItem.itemName = nameTextField.text
        currentItem.itemDescription = descriptionTextField.text
        switch typeSegControl.selectedSegmentIndex {
        case 0:
            currentItem.itemType = "Personal"
        case 1:
            currentItem.itemType = "Home"
        case 2:
            currentItem.itemType = "Work"
        case 3:
            currentItem.itemType = "Class"
        default:
            println("Default")
        }
        currentItem.itemImportance = importanceSegControl.selectedSegmentIndex
        var formatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy hh:mm"
        datesLabel.text = ""
        if let dateEntered = currentItem.dateEntered as NSDate? {
            datesLabel.text = "\(formatter.stringFromDate(dateEntered))"
        }
        currentItem.itemDueDate = dateDuePicker.date
        currentItem.itemComplete = completeSwitch.on
        appDelegate.saveContext()
        navigationController!.popViewControllerAnimated(true);
    }

    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if let unwrappedItem = selectedItem {
            currentItem = unwrappedItem
            nameTextField.text = currentItem.itemName
            descriptionTextField.text = currentItem.itemDescription
            switch currentItem.itemType {
            case "Personal":
                typeSegControl.selectedSegmentIndex = 0
            case "Home":
                typeSegControl.selectedSegmentIndex = 1
            case "Work":
                typeSegControl.selectedSegmentIndex = 2
            case "Class":
                typeSegControl.selectedSegmentIndex = 3
            default:
                println("Default")
            }
            importanceSegControl.selectedSegmentIndex = (currentItem.itemImportance) as Int
            var formatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd/yyyy hh:mm"
            datesLabel.text = "Date Assigned: \(formatter.stringFromDate(currentItem.dateEntered))"
            dateDuePicker.date = currentItem.itemDueDate

            completeSwitch.on = currentItem.itemComplete.boolValue
            
        } else {
            let entityDescription : NSEntityDescription! = NSEntityDescription.entityForName("Items", inManagedObjectContext: managedObjectContext)
            currentItem = Items(entity: entityDescription, insertIntoManagedObjectContext: managedObjectContext)
            currentItem.itemName = ""
            currentItem.itemDescription = ""
            currentItem.dateEntered = NSDate()
            nameTextField.text = currentItem.itemName
            descriptionTextField.text = currentItem.itemDescription
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if managedObjectContext.hasChanges {
            managedObjectContext.rollback()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}
