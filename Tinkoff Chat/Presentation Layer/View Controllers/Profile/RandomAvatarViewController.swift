//
//  RandomAvatarViewController.swift
//  Tinkoff Chat
//
//  Created by Artem Pavlov on 14.05.17.
//  Copyright © 2017 Den prod. All rights reserved.
//

import UIKit

class RandomAvatarViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Properties 
    let pixabayImageProvider = PixabayImageProvider()
    
    // Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        pixabayImageProvider.getPicUrls()
    }
    
    // UI Events
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true,
                     completion: nil)
    }
}


extension RandomAvatarViewController: UICollectionViewDelegate {
    
}

extension RandomAvatarViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WebPic", for: indexPath)
        
        
        return cell
    }
}
