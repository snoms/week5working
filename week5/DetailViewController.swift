//
//  DetailViewController.swift
//  week5
//
//  Created by bob on 04/03/16.
//  Copyright © 2016 bob. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var todoTitle: UINavigationItem!
    
    var passedList: ToDoList?
    var todoArray = [String]()
    // Todo: make todoArray the list which belongs to the todoList identifier
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
    //    if let detail = self.detailItem {
    //        if let label = self.detailDescriptionLabel {
    //            label.text = detail.description
    //        }
    //    }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        restorationIdentifier = "DetailView"
        restorationClass = DetailViewController.self
        inputTodo.delegate = self
        //self.todoTitle.title = "test"
        //tableView.rowHeight = UITableViewAutomaticDimension
        // Do any additional setup after loading the view, typically from a nib.
        //readData()
        // todo: set title to todoList identifier
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            let savedData = NSKeyedArchiver.archivedDataWithRootObject(TodoLists)
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(savedData, forKey: "people")
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
            passedList = NSKeyedUnarchiver.unarchiveObjectWithData(savedLists) as? ToDoList
        }
    }

    func invalidChar() {
        let charAlert = UIAlertController(title: "Error", message: "Invalid character: '^'", preferredStyle: UIAlertControllerStyle.Alert)
        charAlert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(charAlert, animated: true, completion: nil)
    }
    
    @IBAction func clearAll(sender: AnyObject) {
        // Create the alert controller.
        let deleteAlert = UIAlertController(title: "Warning", message: "Are you sure you want to delete all To-dos? This can not be reverted.", preferredStyle: .Alert)
        
        // Grab the value from the text field, and print it when the user clicks OK.
        let okAction = UIAlertAction(title: "Delete All", style: UIAlertActionStyle.Destructive) {
            UIAlertAction in
            NSLog("OK Pressed")
            self.passedList!.items.removeAll()
            //self.writeData()
            //self.readData()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
            self.inputTodo.resignFirstResponder()
        }            // Present the alert.
        deleteAlert.addAction(okAction)
        deleteAlert.addAction(cancelAction)
        self.presentViewController(deleteAlert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var inputTodo: UITextField!
    
    @IBAction func enterTodo(sender: AnyObject) {
        if (inputTodo.text == "") {
            // Create the alert controller.
            let alert = UIAlertController(title: "You didn't enter anything!", message: "Insert your todo here or press OK to insert an empty row", preferredStyle: .Alert)
            
            // Add the text field. You can configure it however you need.
            alert.addTextFieldWithConfigurationHandler({ (textField) -> Void in
                textField.text = ""
            })
            
            // Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
                let textField = alert.textFields![0] as UITextField
                print("Text field: \(textField.text)")
                if (textField.text?.characters.contains("^") == false) {
                    self.passedList!.addItem(textField.text!)
                    self.tableView.reloadData()
                    //self.writeData()
                }
                else {
                    self.invalidChar()
                }
            }))
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
                UIAlertAction in
                NSLog("Cancel Pressed")
                self.inputTodo.resignFirstResponder()
            }            // Present the alert.
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else {
            // alert: you have entered an empty todo. do you want to insert a white line?
            // if yes --> continue, if no --> abort
            if (inputTodo.text?.characters.contains("^") == false) {
                self.passedList!.addItem(inputTodo.text!)
                print(passedList!.items)
                inputTodo.text = ""
                tableView.reloadData()
                self.inputTodo.resignFirstResponder()
            }
            else {
                invalidChar()
            }
        }
        //writeData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.passedList!.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! TodoCell
        cell.todoTextfield.text = self.passedList!.items[indexPath.row]
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    func textFieldShouldReturn(inputTodo: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            self.passedList!.items.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
            writeData()
        }
    }
    
//    override func encodeRestorableStateWithCoder(coder: NSCoder) {
//        if let passedList = passedList {
//            coder.encodeObject(passedList, forKey: "passedList")
//        }
//        //2
//        super.encodeRestorableStateWithCoder(coder)
//    }
//    
//    override func decodeRestorableStateWithCoder(coder: NSCoder) {
//     
//        passedList = coder.decodeObjectOfClass(ToDoList.self, forKey: "passedList")
//        super.decodeRestorableStateWithCoder(coder)
//    }
//
//    override func applicationFinishedRestoringState() {
//        guard let passedList = passedList else { return }
//        passedList = 
//    }
    
}

extension DetailViewController: UIViewControllerRestoration {
    static func viewControllerWithRestorationIdentifierPath(identifierComponents: [AnyObject],
        coder: NSCoder) -> UIViewController? {
            let vc = DetailViewController()
            return vc
    }
}

