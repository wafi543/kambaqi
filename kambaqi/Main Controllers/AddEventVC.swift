//
//  AddEventVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 20/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import CoreData

class AddEventVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet var EventName: UITextField!
    @IBOutlet var CalendarType: UISegmentedControl!
    @IBOutlet var EventDate: UITextField!
    @IBOutlet var EventTime: UITextField!
    @IBOutlet var colorsCollectionView: UICollectionView!
    @IBOutlet var StatusSegment: UISegmentedControl!
    
    var vcType : VCType = .Normal
    var myEvent : MyEvent!
    var lastIndex = -1
    var selectedColor = 0
    var selectedCalendar = 0
    var status = true
    
    let datePicker = UIDatePicker()
    
    let formatterStr = "yyyy/MM/dd , h:mm a"

    override func viewDidLoad() {
        super.viewDidLoad()
        colorsCollectionView.delegate = self
        colorsCollectionView.dataSource = self
        datePicker.datePickerMode = .dateAndTime; datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        EventName.setToolBar(""); EventDate.setToolBar("")
        EventDate.inputView = datePicker
        
        if vcType == .EditVC {
            EventName.text = myEvent.eventName
            EventDate.text = myEvent.date.toString(formatterStr, "en")
            selectedColor = myEvent.color
            colorsCollectionView.reloadData()
            CalendarType.selectedSegmentIndex = myEvent.calendarType
            if myEvent.status {StatusSegment.selectedSegmentIndex = 0}
            else {StatusSegment.selectedSegmentIndex = 1}
        }
    }
    
    @objc func dateChanged () {
        EventDate.text = datePicker.date.toString(formatterStr, "en")
    }
    
//
//    @objc func timeChanged () {
//        EventTime.text = core.timeFormatter.string(from: timePicker.date)
//    }
//
    
    @IBAction func add(_ sender: Any) {
        if vcType == .Normal {
            if lastIndex > -1 {
                if EventName.text == "" || EventDate.text == "" {
                    Helper.showBasicAlert(title: "Required ‼️", message: "هناك بيانات مفقودة", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
                }else {
                    if datePicker.date > Date() {
                        let minute = datePicker.date.toString("mm", "en").intValue
                        let hour = datePicker.date.toString("hh", "en").intValue
                        print("\(hour):\(minute)")
                        let date = Calendar.current.date(bySettingHour: hour, minute: minute, second: 00, of: datePicker.date)!
                        myEvent = MyEvent.init(id: lastIndex, eventName: EventName.text ?? "", calendarType: CalendarType.selectedSegmentIndex, date: date, color: selectedColor, status: status)
                        saveToCoreData()
                    }else {
                        Helper.showBasicAlert(title: "تنبيه ⚠️", message: "زمن المناسبة قد مضى", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
                    }
                }
            }else {
                Helper.showBasicAlert(title: "Error ❌", message: "هناك خطأ ماً، اذا تكرر الخطأ تواصل مع الدعم الفني", buttonTitle: "موافق", isBlue: false, vc: self, completion: nil)
            }
        }
    }
    
    @IBAction func statusChanged(_ sender: Any) {
        status = (StatusSegment.selectedSegmentIndex == 0)
        if status {
            StatusSegment.tintColor = colors.enabled
        }else {
            StatusSegment.tintColor = colors.disabled
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
        newObject.setValue(myEvent.status, forKey: "status")
        do {
            try context.save()
            Helper.showBasicAlert(title: "تم ✅", message: "تم حفظ المناسبة بنجاح", buttonTitle: "موافق", isBlue: true, vc: self) {
                self.navigationController?.popViewController(animated: true)
            }
        }
        catch {
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
    
}
