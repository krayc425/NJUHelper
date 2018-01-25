//
//  MainCollectionViewController.swift
//  NJUHelper
//
//  Created by 宋 奎熹 on 2017/12/20.
//  Copyright © 2017年 宋 奎熹. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MainCollectionViewCell"

class MainCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellColors = [UIColor.pnju, UIColor.gpa, UIColor.website, UIColor.course]
    private let cellTitles = ["PNJU", "GPA", "Websites", "Courses"]
    private let cellSegues = ["PNJUSegue", "GPASegue", "WebsiteSegue", "CourseSegue"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "南大老司机"
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        hideBottomLine(under: (self.navigationController?.navigationBar)!)
    }
    
    private func hideBottomLine(under view: UIView) {
        
        func findBottomLine(under view: UIView) -> UIImageView? {
            if view is UIImageView && view.bounds.size.height <= 1.0 {
                return view as? UIImageView
            }
            for subview in view.subviews {
                let imageView = findBottomLine(under: subview)
                if imageView != nil {
                    return imageView
                }
            }
            return nil
        }
        
        findBottomLine(under: view)?.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            switch segueId {
            default:
                break
            }
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellColors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MainCollectionViewCell {
        let cell: MainCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MainCollectionViewCell
    
        cell.titleLabel?.text = cellTitles[indexPath.row]
        cell.corneredView?.backgroundColor = cellColors[indexPath.row]
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: cellSegues[indexPath.row], sender: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth - 30) / 2.0, height: (kScreenWidth - 30) / 2.0)
    }
    
}
