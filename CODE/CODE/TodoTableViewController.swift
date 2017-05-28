//
//  TodoTableViewController.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 02/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//
//
//  TodoTableViewController.swift
//  LocalNotificationsTutorial
//
//  Credits by Jason Newell on 1/30/15.
//
// Class to show a table with the alarms

import UIKit
import AVKit
import AVFoundation

var firstAppear = false
class TodoTableViewController: UITableViewController {
    var todoItems: [TodoItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList", name: "TodoListShouldRefresh", object: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print(todoItems[indexPath.row].title)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewControllerWithIdentifier("TodoSchedulingViewController") as! TodoSchedulingViewController
        viewController.CurrentTodoITem(todoItems[indexPath.row])
        navigationController?.pushViewController(viewController, animated: true);

    }
    
    
    @IBAction func setDeleting(sender: AnyObject) {
        setEditing(!editing, animated: true);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    func refreshList() {
        todoItems = TodoList.sharedInstance.allItems()
        if (todoItems.count >= 64) {
            self.navigationItem.rightBarButtonItem!.enabled = false // disable 'add' button
        }
        tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("todoCell", forIndexPath: indexPath) // retrieve the prototype cell (subtitle style)
        let todoItem = todoItems[indexPath.row] as TodoItem
        
        cell.textLabel?.text = todoItem.title as String!
        if (todoItem.isOverdue && repeating(todoItem)) { // the current time is later than the to-do item's deadline
            cell.detailTextLabel?.textColor = UIColor.redColor()
        } else {
            cell.detailTextLabel?.textColor = UIColor.blackColor() // we need to reset this because a cell with red subtitle may be returned by dequeueReusableCellWithIdentifier:indexPath:
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a" // example: "Due Jan 01 at 12:00 PM"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(todoItem.deadline)
        
        let v = UIView()
        v.backgroundColor = UIColor( red:0.00, green:0.65, blue: 0.90, alpha: 1.0)
        //self.darkerColor(UIColor.blueColor())
        cell.selectedBackgroundView = v;
        
        
        
        return cell
    }
    
    func repeating(item:TodoItem) -> Bool
    {
        for notification in (UIApplication.sharedApplication().scheduledLocalNotifications as [UILocalNotification]?)! { // loop through notifications...
            if (notification.userInfo!["UUID"] as! String == item.UUID) { // ...and
                if(notification.repeatInterval == NSCalendarUnit.Era){
                    return true
                }
                
            }
        }
        return false
    }
    
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true // all cells are editable
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete { // the only editing style we'll support
            // Delete the row from the data source
            let item = todoItems.removeAtIndex(indexPath.row) // remove TodoItem from notifications array, assign removed item to 'item'
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            TodoList.sharedInstance.removeItem(item,force: true) // delete backing property list entry and unschedule local notification (if it still exists)
            self.navigationItem.rightBarButtonItem!.enabled = true // we definitely have under 64 notifications scheduled now, make sure 'add' button is enabled
        }
    }
    
    
    
    @IBAction func leftButtonPressed(sender: AnyObject) {
        /* let centerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as!    HomeViewController
         let centerNavController = UINavigationController(rootViewController: centerViewController)
         let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         appDelegate.centerContainer!.centerViewController = centerNavController*/
        let appDelegate:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.centerContainer!.toggleDrawerSide(MMDrawerSide.Left, animated: true, completion: nil)
    }
    
}

enum AppError : ErrorType {
    case InvalidResource(String, String)
    
    
    
}
