//
//  MainVC.swift
//  kambaqi
//
//  Created by Wafi Alshammari on 19/3/19.
//  Copyright © 2019 Wafi AlShammari. All rights reserved.
//

import UIKit

class MainVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override var preferredStatusBarStyle: UIStatusBarStyle {return .lightContent}
    @IBOutlet var mainCollectionView: UICollectionView!
    @IBOutlet var containerView: UIView!
    
    let shadowView : UIButton = {let tmp = UIButton();tmp.setTitle("", for: .normal); tmp.backgroundColor = UIColor.black; tmp.alpha = 0.3; return tmp}()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        containerView.frame.origin = CGPoint(x: view.frame.width, y: 0)
    }
    
    @IBAction func showMenu(_ sender: Any) {
        shadowView.frame = view.frame; view.addSubview(shadowView)
        shadowView.addTarget(self, action: #selector(removeShadow), for: .touchUpInside)
        view.bringSubviewToFront(containerView)
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.frame.origin = CGPoint(x: 80, y: 0)
        })
    }
    
    @objc func removeShadow () {
        shadowView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.frame.origin = CGPoint(x: self.view.frame.width, y: 0)
        })
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

}
