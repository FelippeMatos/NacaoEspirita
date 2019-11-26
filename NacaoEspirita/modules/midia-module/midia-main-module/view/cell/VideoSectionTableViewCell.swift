//
//  CategoryRow.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import FirebaseUI

class VideoSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    var videoArray: [VideoModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionTableView()
    }
    //CONFIGURAR A COLLECTIONVIEW AQUI E FAZER O MESMO PROCESSO!!!!!!!! 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
        cell.testLabel.text = videoArray[indexPath.row].items?[0].snippet.title
        cell.channelLabel.text = videoArray[indexPath.row].items?[0].snippet.channelTitle
        let linkThumb = videoArray[indexPath.row].items?[0].snippet.thumbnails.medium.url
        print("$$$$$$ URL THUMB : \(linkThumb)")
        cell.videoImage.downloaded(from: linkThumb!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 1.25
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

