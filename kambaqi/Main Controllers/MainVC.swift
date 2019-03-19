//
//  MainVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import Firebase
import CoreData

class MainVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet var mainCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        getData()
    }
    
    func getData () {
        dbEvents.observe(.value, with: { (snapshot) in
            for snp in snapshot.children {
                guard let document = snp as? DataSnapshot else {
                    print("Something wrong with Firebase DataSnapshot")
                    return
                }
                let snapValue = document.value as? NSDictionary
                let id = document.key
                let calendarType = snapValue?.value(forKey: "calendarType") as? Int ?? 0
                let eventInterval = snapValue?.value(forKey: "eventInterval") as? Int ?? 0
                let eventName = snapValue?.value(forKey: "eventName") as? String ?? ""
                let day = snapValue?.value(forKey: "day") as? Int ?? 0
                let month = snapValue?.value(forKey: "month") as? Int ?? 0
                let year = snapValue?.value(forKey: "year") as? Int ?? 0
                
                guard let date = core.generateDate(calendarType, day, month, year) else {return}
                let event = Event.init(id: id, calendarType: calendarType, eventInterval: eventInterval, eventName: eventName, date: date)
                
                self.saveToCoreData(event)
            }
        })
    }
    
    func saveToCoreData (_ event : Event) {
        print("saveToCoreData")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Events", in: context)
        let newObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newObject.setValue(event.id, forKey: "id")
        newObject.setValue(event.calendarType, forKey: "calendarType")
        newObject.setValue(event.eventInterval, forKey: "eventInterval")
        newObject.setValue(event.eventName, forKey: "eventName")
        newObject.setValue(event.date, forKey: "date")
        do {try context.save()} catch {print("Error. vc: \(self.description ) Line: \(#line)")}
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.mainTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCell", for: indexPath) as! MainCell
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowRadius = 2
        cell.layer.masksToBounds = false
        
        cell.Icon.image = names.mainIcons[indexPath.row]
        cell.Title.text = names.mainTitles[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = core.mainVCs(names.mainTitles[indexPath.row]) else {return}
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
