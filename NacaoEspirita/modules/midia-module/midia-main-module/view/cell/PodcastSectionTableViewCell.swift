//
//  CategoryRow.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class PodcastSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionTableView: UICollectionView!
    var podcastArray: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionTableView()
    }
    //CONFIGURAR A COLLECTIONVIEW AQUI E FAZER O MESMO PROCESSO!!!!!!!! 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}

extension PodcastSectionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setCollectionTableView() {
        self.collectionTableView.delegate = self
        self.collectionTableView.dataSource = self
        self.collectionTableView.register(UINib(nibName: "PodcastCollectionCell", bundle: nil), forCellWithReuseIdentifier: "PodcastCollectionCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PodcastCollectionCell", for: indexPath) as! PodcastCollectionViewCell
        cell.testLabel.text = podcastArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return podcastArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 3
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}

