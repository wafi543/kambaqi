//
//  AdsVC.swift
//  Kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit
import Firebase
import CoreData
import ARSLineProgress

class AdsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var mainTableView: UITableView!
    
    var photos : [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.delegate = self; mainTableView.dataSource = self
        getDataOffline()
        getData()
    }
    
    func getDataOffline() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Photos")
        request.returnsObjectsAsFaults = false
        do {
            self.photos.removeAll()
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as? String ?? ""
                let mName = data.value(forKey: "mName") as? String ?? ""
                let mUri = data.value(forKey: "mUri") as? String ?? ""
                
                let photo = Photo.init(id: id, mUri: mUri, mName: mName)
                self.photos.append(photo)
            }
            DispatchQueue.main.async {self.mainTableView.reloadData(); ARSLineProgress.hide()}
        } catch {print("Failed")}
    }
    
    func saveToCoreData (_ photo : Photo) {
        print("saveToCoreData")
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Photos", in: context)
        let newObject = NSManagedObject(entity: entity!, insertInto: context)
        
        newObject.setValue(photo.id, forKey: "id")
        newObject.setValue(photo.mName, forKey: "mName")
        newObject.setValue(photo.mUri, forKey: "mUri")
        print(newObject)
        do {try context.save()} catch {print("Error. vc: \(self.description ) Line: \(#line)")}
    }
    
    func getData () {
        ARSLineProgress.show()
        dbPhotos.observe(.value, with: { (snapshot) in
            self.photos.removeAll()
            core.deleteEntity("Photos")
            for snp in snapshot.children {
                guard let document = snp as? DataSnapshot else {
                    print("Something wrong with Firebase DataSnapshot")
                    return
                }
                let snapValue = document.value as? NSDictionary
                let id = document.key
                let mName = snapValue?.value(forKey: "mName") as? String ?? ""
                let mUri = snapValue?.value(forKey: "mUri") as? String ?? ""
                
                let photo = Photo.init(id: id, mUri: mUri, mName: mName)
                self.photos.append(photo)
                self.saveToCoreData(photo)
                
                DispatchQueue.main.async {
                    self.mainTableView.reloadData(); ARSLineProgress.hide()
                    self.showToast("تم تحديث القائمة")
                }
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {return photos.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AdCell", for: indexPath) as! AdCell
        let photo = photos[indexPath.row]
        cell.Photo.loadImageUsingCache(photo.mUri, nil, nil)
        return cell
    }
    
    override func viewWillDisappear(_ animated: Bool) {ARSLineProgress.hide()}
}
