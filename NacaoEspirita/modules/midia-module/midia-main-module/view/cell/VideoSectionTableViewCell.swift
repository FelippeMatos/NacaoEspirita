//
//  CategoryRow.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import FirebaseUI
import Kingfisher

class VideoSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    var videoArray: [VideoModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionTableView()
    }
    
    func reloadCell(videoArrayList: [VideoModel]) {
        self.videoArray = videoArrayList
        collectionTableView.reloadData()
    }
}

extension VideoSectionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setCollectionTableView() {
        self.collectionTableView.delegate = self
        self.collectionTableView.dataSource = self
        self.collectionTableView.register(UINib(nibName: "VideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionCell", for: indexPath) as! VideoCollectionViewCell
        
        cell.testLabel.text = videoArray[indexPath.row].title
        cell.channelLabel.text = videoArray[indexPath.row].channelTitle
        
        let urlThumb = URL(string: videoArray[indexPath.row].thumbnailHigh!)
        cell.videoImage.kf.setImage(with: urlThumb)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hardCodedPadding:CGFloat = 25
        let itemWidth = collectionView.bounds.width - hardCodedPadding
        let itemHeight = (itemWidth * 0.56) + 76
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

