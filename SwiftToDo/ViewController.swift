//
//  ViewController.swift
//  SwiftToDo
//
//  Created by Miles Johnson on 7/7/15.
//  Copyright (c) 2015 StarShip Enterprise. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let managedObjectContext: NSManagedObjectContext! = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var itemsArray = [Items]()
    @IBOutlet var itemsTableView :UITableView!
    
    // MARK: - Core Methods
    func fetchItems(searchText: String) -> [Items] {
        let fetchRequest :NSFetchRequest = NSFetchRequest(entityName: "Items")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "itemName", ascending: true)]
        return managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as! [Items]
    }
    
    // MARK: - TableView Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        let currentItem = itemsArray[indexPath.row]
        cell.textLabel!.text = currentItem.itemName + ": " + currentItem.itemDescription
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("editToDetailSegue", sender: self)
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            itemsArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
    // MARK: - Interactivity Methods
    func addButtonPressed(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addToDetailSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destController = segue.destinationViewController as! DetailViewController
        if segue.identifier == "editToDetailSegue" {
            let indexPath = itemsTableView.indexPathForSelectedRow()
            if let unwrappedIndexPath = indexPath {
                let currentItem = itemsArray[unwrappedIndexPath.row]
                destController.selectedItem = currentItem
                itemsTableView.deselectRowAtIndexPath(unwrappedIndexPath, animated: true)
            }
        }
        if segue.identifier == "addToDetailSegue" {
            destController.selectedItem = nil
        }
    }
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        var addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addButtonPressed:")
        self.navigationItem.rightBarButtonItems = [addButton]
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        itemsArray = fetchItems("")
        itemsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

