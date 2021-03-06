//
//  AddEventVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 20/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddEventVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate {
    
    @IBOutlet var EventName: UITextField!
    @IBOutlet var CalendarType: UISegmentedControl!
    @IBOutlet var EventDate: UITextField!
    @IBOutlet var EventTime: UITextField!
    @IBOutlet var colorsCollectionView: UICollectionView!
    @IBOutlet var StatusSegment: UISegmentedControl!
    @IBOutlet var addButton: CustomButton!
    
    var vcType : VCType = .Normal
    var myEvent : MyEvent!
    var lastIndex = -1
    var selectedColor = 0
    var selectedCalendar = 0
    var alertStatus = true
    
    let datePicker = UIDatePicker()
    let formatterStr = "yyyy/MM/dd , h:mm a"

    override func viewDidLoad() {
        super.viewDidLoad()
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        datePicker.datePickerMode = .dateAndTime; datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        EventName.setToolBar(""); EventDate.setToolBar("")
        EventDate.inputView = datePicker
        EventDate.delegate = self
        
        if vcType == .EditVC {
            var identifier = "en"; if myEvent.calendarType == 0 {identifier = "en_SA"}
            if myEvent.alertStatus {StatusSegment.tintColor = colors.enabled} else {StatusSegment.tintColor = colors.disabled}
            EventName.text = myEvent.eventName
            EventDate.text = myEvent.date.toString(formatterStr, identifier)
            selectedColor = myEvent.color
            colorsCollectionView.reloadData()
            CalendarType.selectedSegmentIndex = myEvent.calendarType
            if myEvent.alertStatus {StatusSegment.selectedSegmentIndex = 0}
            else {StatusSegment.selectedSegmentIndex = 1}
            addButton.setTitle("تعديل", for: .normal)
            datePicker.date = myEvent.date
        }
    }
    
    @objc func dateChanged () {
        var identifier = "en"; if CalendarType.selectedSegmentIndex == 0 {identifier = "en_SA"}
        EventDate.text = datePicker.date.toString(formatterStr, identifier)
    }
    
    @IBAction func add(_ sender: Any) {
        if vcType == .Normal {
            if lastIndex > -1 {
                if EventName.text == "" || EventDate.text == "" {
                    Helper.showBasicAlert(title: "Required ‼️", message: "هناك بيانات مفقودة", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
                }else {
                    if datePicker.date > Date() {
                        let minute = datePicker.date.toString("mm", "en").intValue
                        let hour = datePicker.date.toString("HH", "en").intValue
                        let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 00, of: datePicker.date)!
                        myEvent = MyEvent.init(id: lastIndex, eventName: EventName.text ?? "", calendarType: CalendarType.selectedSegmentIndex, date: date, color: selectedColor, alertStatus: alertStatus)
                        saveToCoreData()
                        if myEvent.alertStatus {core.configureNotification(myEvent: myEvent, vc: self)}
                    }else {
                        Helper.showBasicAlert(title: "تنبيه ⚠️", message: "زمن المناسبة قد مضى", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
                    }
                }
            }else {
                Helper.showBasicAlert(title: "Error ❌", message: "هناك خطأ ماً، اذا تكرر الخطأ تواصل مع الدعم الفني", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
            }
        }else {
            func editEvent(myEvent : MyEvent, completion: (() -> ())?) {
                let delegate = UIApplication.shared.delegate as! AppDelegate
                let context = delegate.persistentContainer.viewContext
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MyEvents")
                fetchRequest.predicate = NSPredicate.init(format: "id==\(myEvent.id)")
                
                do {
                    let results = try context.fetch(fetchRequest) as? [NSManagedObject]
                    if results?.count != 0 { // Atleast one was returned
                        // In my case, I only updated the first item in results
                        results?[0].setValue(myEvent.id, forKey: "id")
                        results?[0].setValue(myEvent.calendarType, forKey: "calendarType")
                        results?[0].setValue(myEvent.eventName, forKey: "eventName")
                        results?[0].setValue(myEvent.date, forKey: "date")
                        results?[0].setValue(myEvent.color, forKey: "color")
                        results?[0].setValue(myEvent.alertStatus, forKey: "alertStatus")
                        do {
                            try context.save()
                            completion?()
                        } catch {
                            print ("There was an error")
                        }
                    }else {
                        print("error fetch object")
                    }
                } catch {
                    print ("There was an error")
                }
            }
            
            if EventName.text == "" || EventDate.text == "" {
                Helper.showBasicAlert(title: "Required ‼️", message: "هناك بيانات مفقودة", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
            }else {
                if datePicker.date > Date() {
                    let minute = datePicker.date.toString("mm", "en").intValue
                    let hour = datePicker.date.toString("HH", "en").intValue
                    let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 00, of: datePicker.date)!
                    let newEvent = MyEvent.init(id: self.myEvent.id, eventName: EventName.text ?? "", calendarType: CalendarType.selectedSegmentIndex, date: date, color: selectedColor, alertStatus: alertStatus)
                    editEvent(myEvent: newEvent) {
                        Helper.showBasicAlert(title: "تم ✅", message: "تم تعديل البيانات بنجاح", buttonTitle: "موافق", isBlue: true, vc: self, completion: {
                            self.navigationController?.popViewController(animated: true)
                        })
                        if newEvent.alertStatus {core.configureNotification(myEvent: newEvent, vc: self)}
                        else {core.removePendingNotification(newEvent)}
                    }
                }else {
                    Helper.showBasicAlert(title: "تنبيه ⚠️", message: "زمن المناسبة قد مضى", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
                }
            }
        }
    }
    
    @IBAction func statusChanged(_ sender: Any) {
        alertStatus = (StatusSegment.selectedSegmentIndex == 0)
        if alertStatus {StatusSegment.tintColor = colors.enabled} else {StatusSegment.tintColor = colors.disabled}
    }
    
    @IBAction func calendarChanged(_ sender: Any) {
        selectedCalendar = CalendarType.selectedSegmentIndex
        configureDatePicker()
        if EventDate.text != "" {
            var identifier = "en"; if CalendarType.selectedSegmentIndex == 0 {identifier = "en_SA"}
            EventDate.text = datePicker.date.toString(formatterStr, identifier)
        }
    }
    
    func configureDatePicker () {
        if CalendarType.selectedSegmentIndex == 0 {
            datePicker.locale = Locale(identifier: "ar")
            datePicker.calendar = Calendar(identifier: .islamicUmmAlQura)
        }else {
            datePicker.locale = Locale(identifier: "en")
            datePicker.calendar = Calendar(identifier: .gregorian)
        }
    }
    
    func saveToCoreData () {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "MyEvents", in: context)
        let newObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newObject.setValue(myEvent.id, forKey: "id")
        newObject.setValue(myEvent.calendarType, forKey: "calendarType")
        newObject.setValue(myEvent.eventName, forKey: "eventName")
        newObject.setValue(myEvent.date, forKey: "date")
        newObject.setValue(myEvent.color, forKey: "color")
        newObject.setValue(myEvent.alertStatus, forKey: "alertStatus")
        do {
            try context.save()
            Helper.showBasicAlert(title: "تم ✅", message: "تم حفظ المناسبة بنجاح", buttonTitle: "موافق", isBlue: true, vc: self) {
                self.navigationController?.popViewController(animated: true)
            }
        }catch {
            self.showToast("Error. vc: \(self.description ) Line: \(#line)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return names.colorNames.count}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath) as! ColorCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = cell.selectedView.backgroundColor?.cgColor
        if selectedColor == indexPath.row {cell.selectedView.isHidden = false} else {cell.selectedView.isHidden = true}
        cell.backgroundColor = core.decColor(names.colorNames[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = indexPath.row
        colorsCollectionView.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        configureDatePicker()
    }
}
