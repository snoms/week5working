//
//  MasterViewController.swift
//  week5
//
//  Created by bob on 04/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UIAlertViewDelegate {

    var detailViewController: DetailViewController? = nil
    var objects = [AnyObject]()
//    var list1 = todoList(name: "first list")
    var todoListArray: [ToDoList] = [ToDoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        

//        print(list1.name)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewObject(sender: AnyObject) {
        
        let alert = UIAlertController(title: "New Todo list", message: "Please enter your list name here", preferredStyle: .Alert)
        // Add the text field. You can configure it however you need.
        alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.text = ""
        })
        
        // Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            let textField = alert.textFields![0] as UITextField
            print("Text field: \(textField.text!)")
            // strange bug here, detects duplicates after removal
            for (index, lists) in self.todoListArray.enumerate() {
                if lists.name == textField.text {
                    // TODO: Insert alert of duplicate. OK to go to DetailView with
                    print("error: Duplicate list exists")
                    // pass todoLists[index] to DVC
                }
            }
            var newList = ToDoList(name: textField.text!, items: [""])
            
            self.todoListArray.append(newList)
            self.objects.insert(newList, atIndex: 0)
            let indexPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            print(self.todoListArray)
        }))
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
//            self.inputTodo.resignFirstResponder()
        }            // Present the alert.
        alert.addAction(cancelAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
        

    }

    func writeData() {
        //        if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
        //
        //            let path: String = directory + "/todoliststorage.txt"
        //            let text = todoArray.joinWithSeparator("^")
        //            do {
        //                try text.writeToFile(path, atomically: false, encoding: NSUTF8StringEncoding)
        //            }
        //            catch {
        //                // Error handling here.
        //                print("error while writing list to storage")
        //                print(path)
        //            }
        //          }
        let savedData = NSKeyedArchiver.archivedDataWithRootObject(todoListArray)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(savedData, forKey: "list")
    }
    
    func readData() {
        //        if let directory: String = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true).first {
        //
        //            let path: String = directory + "/todoliststorage.txt"
        //            print(path)
        //
        //            // Reading todo list from test.txt
        //            do {
        //                let loadedFile = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
        //                todoArray = loadedFile.characters.split{$0 == "^" || $0 == "\r\n"}.map(String.init)
        //
        //            } catch {
        //                // Error handling here.
        //                print("error while reading stored list")
        //            }
        //        } else {
        //            // Error handling here.
        //            print("error while reading stored list")
        //        }
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let savedLists = defaults.objectForKey("list") as? NSData {
            todoListArray = NSKeyedUnarchiver.unarchiveObjectWithData(savedLists) as! [ToDoList]
        }
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row] as! ToDoList
                let nav = segue.destinationViewController as! UINavigationController
                let svc = nav.topViewController as! DetailViewController
                svc.passedList = object
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.navigationItem.title = object.name
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row] as! ToDoList
        cell.textLabel!.text = object.name
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            self.todoListArray.removeAtIndex(indexPath.row)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    override func encodeRestorableStateWithCoder(coder: NSCoder) {
        //2

        super.encodeRestorableStateWithCoder(coder)
    }
    override func decodeRestorableStateWithCoder(coder: NSCoder) {
        super.decodeRestorableStateWithCoder(coder)
    }
    override func applicationFinishedRestoringState() {
    }
}

