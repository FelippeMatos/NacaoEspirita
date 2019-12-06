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
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var collectionTableView: UICollectionView!
    var videoArray: [VideoModel] = []
    var navigationController: UINavigationController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionTableView()
    }
    
    func reloadCell(videoArrayList: [VideoModel]) {
        self.videoArray = videoArrayList
        collectionTableView.reloadData()
        loading.isHidden = true
    }
}

extension VideoSectionTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setCollectionTableView() {
        self.collectionTableView.delegate = self
        self.collectionTableView.dataSource = self
        self.collectionTableView.register(UINib(nibName: "VideoCollectionCell", bundle: nil), forCellWithReuseIdentifier: "VideoCollectionCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        pushToVideoDisplayScreen(navigationController: self.navigationController!, id: videoArray[indexPath.row].id!)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionCell", for: indexPath) as! VideoCollectionViewCell
        
        let video = videoArray[indexPath.row]
        
        cell.videoNamesLabel.text = video.title
        cell.channelLabel.text = video.channelTitle
        if let duration = video.duration {
            cell.videoDurationlabel.text = duration.getYoutubeFormattedDuration()
        }
        
        let urlThumb = URL(string: video.thumbnailHigh!)
        
        //MARK: TEMPORARIO PQ ESTA HORRIVEL ISSO!
        var channelImage = ""
        switch video.channelId {
        case AppKeys.YOUTUBE_CHANNEL1_KEY:
            channelImage = AppKeys.YOUTUBE_CHANNEL1_THUMB
        case AppKeys.YOUTUBE_CHANNEL2_KEY:
            channelImage = AppKeys.YOUTUBE_CHANNEL2_THUMB
        case AppKeys.YOUTUBE_CHANNEL3_KEY:
            channelImage = AppKeys.YOUTUBE_CHANNEL3_THUMB
        case AppKeys.YOUTUBE_CHANNEL4_KEY:
            channelImage = AppKeys.YOUTUBE_CHANNEL4_THUMB
        case AppKeys.YOUTUBE_CHANNEL5_KEY:
            channelImage = AppKeys.YOUTUBE_CHANNEL5_THUMB
        case AppKeys.YOUTUBE_CHANNEL6_KEY:
            channelImage = AppKeys.YOUTUBE_CHANNEL6_THUMB
        case AppKeys.YOUTUBE_CHANNEL7_KEY:
            channelImage = AppKeys.YOUTUBE_CHANNEL7_THUMB
        default:
            channelImage = AppKeys.YOUTUBE_CHANNEL1_THUMB
        }
        let urlChannel = URL(string: channelImage)
        
        cell.videoImage.kf.setImage(with: urlThumb)
        cell.channelImage.kf.setImage(with: urlChannel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let hardCodedPadding:CGFloat = 25
        let itemWidth = collectionView.bounds.width - hardCodedPadding
        let itemHeight = (itemWidth * 0.56) + 100
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func pushToVideoDisplayScreen(navigationController: UINavigationController, id: String) {
        hideProgressIndicator(view: self.navigationController!.view)
        
        let url = "https://www.youtube.com/watch?v=\(id)"
        let midiaVideoDisplayModule = MidiaVideoDisplayRouter.createModule(url: url)
        self.navigationController?.pushViewController(midiaVideoDisplayModule, animated: true)
    }
    
}

