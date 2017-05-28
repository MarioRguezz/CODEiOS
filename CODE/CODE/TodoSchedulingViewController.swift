//
//  TodoSchedulingViewController.swift
//  CODE
//
//  Created by Mario Alberto Negrete Rodríguez  & Oscar Barrera Casillas on 02/06/16.
//  Copyright © 2016 CODE. All rights reserved.
//  Class to choose title and date for the alarm

import UIKit


class TodoSchedulingViewController: UIViewController, UITextFieldDelegate ,UIPickerViewDataSource,UIPickerViewDelegate{
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var deadlinePicker: UIDatePicker!
    @IBOutlet weak var repeatingPicker: UIPickerView!
    
    @IBOutlet weak var alarmaButton: UIButton!
    var repeatInterval : NSCalendarUnit = NSCalendarUnit.Era
    
    let pickerData = ["Nunca","Minuto","Hora","Diario","Semanalmente","Mensualmente"]
    
    var todoItem : TodoItem?
    
    func CurrentTodoITem(item:TodoItem) {
        todoItem = item;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        self.alarmaButton.backgroundColor = UIColor(red:0.23, green:0.33, blue:0.61, alpha:1.0)
        repeatingPicker.dataSource = self
        repeatingPicker.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("dismissKeyboard")))
        
        if(todoItem != nil){
            titleField.text = todoItem!.title
            deadlinePicker.date = todoItem!.deadline
            print(todoItem!.repeatInterval)
            let row = getIntFromInterval(todoItem!.repeatInterval);
            repeatingPicker.selectRow(row, inComponent: 0, animated: true)
        }
        
    }
    
    func dismissKeyboard() {
        titleField.resignFirstResponder()
       
    }
    
    
    @IBAction func savePressed(sender: AnyObject) {
        let todoItem = TodoItem(deadline: deadlinePicker.date, title: titleField.text!, UUID: NSUUID().UUIDString,Repeating:repeatInterval)
        if(self.todoItem != nil){
            TodoList.sharedInstance.removeItem(self.todoItem!,force: true);
        }
        TodoList.sharedInstance.addItem(todoItem) // schedule a local notification to persist this item
        self.navigationController?.popToRootViewControllerAnimated(true) // return to list view
        
    }
    
    //hide the keyboard when the uitexfield lost the focus
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        self.view.endEditing(true)
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        myLabel.text = pickerData[row]
        
        switch row {
        case 0:
            repeatInterval = NSCalendarUnit.Era
            break
            //        case 1:
            //            repeatInterval = NSCalendarUnit.Day
            //            break
            //        case 2:
            //            repeatInterval = NSCalendarUnit.NSWeekCalendarUnit
            //            break
            //        case 3:
            //            repeatInterval = NSCalendarUnit.Month
        //            break
        case 1:
            repeatInterval = NSCalendarUnit.Minute
            break
        case 2:
            repeatInterval = NSCalendarUnit.Hour
            break
        case 3:
            repeatInterval = NSCalendarUnit.Day
            break
        case 4:
            repeatInterval = NSCalendarUnit.WeekOfMonth
            break
        case 5:
            repeatInterval = NSCalendarUnit.Month
            break
        default:
            
            
            break
        }
    }
    
    func getIntFromInterval(interval:NSCalendarUnit) -> Int{
        switch interval {
        case NSCalendarUnit.Era:
            return 0;
        case NSCalendarUnit.Minute:
            return 1;
        case NSCalendarUnit.Hour:
            return 2;
        case NSCalendarUnit.Day:
            return 3;
        case NSCalendarUnit.WeekOfMonth:
            return 4;
        case NSCalendarUnit.Month:
            return 5;
        default:
            return 0;
        }

    }
    
    
}