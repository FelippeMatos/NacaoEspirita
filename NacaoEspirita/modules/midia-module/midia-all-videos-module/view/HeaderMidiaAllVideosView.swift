//
//  HeaderMidiaView.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/19/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Kingfisher

protocol HeaderMidiaAllVideosViewDelegate: class {
    func headerMidiaAllVideosView(_ headerMidiaAllVideosView: HeaderMidiaAllVideosView, didTapButtonInSection section: Int)
}

class HeaderMidiaAllVideosView: UITableViewCell {
    static let reuseIdentifier = "HeaderMidiaAllVideos"
    
    weak var delegate: HeaderMidiaAllVideosViewDelegate?
    let userDefaults = UserDefaults.standard
    
    var channelSelected: String?
    var channelId: Int?
    var tableView: UITableView?
    @IBOutlet weak var collectionTableView: UICollectionView!
    @IBOutlet weak var dashedView: UIView! {
        didSet {
            self.dashedView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: false)
        }
    }
    var channelArray = AppKeys.YOUTUBE_CHANNEL_THUMBS
    
    var sectionNumber: Int!  // you don't have to do this, but it can be useful to have reference back to the section number so that when you tap on a button, you know which section you came from; obviously this is problematic if you insert/delete sections after the table is loaded; always reload in that case
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setCollectionTableView()
        collectionTableView.reloadData()
    }
    
    @IBAction func didTapButton(_ sender: AnyObject) {
        delegate?.headerMidiaAllVideosView(self, didTapButtonInSection: sectionNumber)
    }
    
    func selectedChannel(_ number: Int) {
        
        if channelId == number {
            channelSelected = nil
            channelId = nil
            
            userDefaults.set(channelSelected, forKey: "channelSelected")
            userDefaults.set(false, forKey: "filterByChannel")
            userDefaults.synchronize()
            
            self.tableView?.reloadData()
            return
        }
        channelId = number
        
        switch number {
        case 0:
            channelSelected = AppKeys.YOUTUBE_CHANNEL1_TITLE
        case 1:
            channelSelected = AppKeys.YOUTUBE_CHANNEL2_TITLE
        case 2:
            channelSelected = AppKeys.YOUTUBE_CHANNEL3_TITLE
        case 3:
            channelSelected = AppKeys.YOUTUBE_CHANNEL4_TITLE
        case 4:
            channelSelected = AppKeys.YOUTUBE_CHANNEL5_TITLE
        case 5:
            channelSelected = AppKeys.YOUTUBE_CHANNEL6_TITLE
        case 6:
            channelSelected = AppKeys.YOUTUBE_CHANNEL7_TITLE
        default:
            channelSelected = AppKeys.YOUTUBE_CHANNEL1_TITLE
        }
        
        userDefaults.set(channelSelected, forKey: "channelSelected")
        userDefaults.set(true, forKey: "filterByChannel")
        userDefaults.synchronize()
        
        self.tableView?.reloadData()
    }
}

extension HeaderMidiaAllVideosView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedChannel(indexPath.row)
    }
    
    func setCollectionTableView() {
        self.collectionTableView.delegate = self
        self.collectionTableView.dataSource = self
        self.collectionTableView.register(UINib(nibName: "ChannelCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ChannelCollectionCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCollectionCell", for: indexPath) as! ChannelCollectionViewCell
        
        
        //MARK: TEMPORARIO PQ ESTA HORRIVEL ISSO!
        var channelImage = ""
        var channelName = ""
        switch indexPath.row {
        case 0:
            channelImage = AppKeys.YOUTUBE_CHANNEL1_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL1_TITLE
        case 1:
            channelImage = AppKeys.YOUTUBE_CHANNEL2_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL2_TITLE
        case 2:
            channelImage = AppKeys.YOUTUBE_CHANNEL3_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL3_TITLE
        case 3:
            channelImage = AppKeys.YOUTUBE_CHANNEL4_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL4_TITLE
        case 4:
            channelImage = AppKeys.YOUTUBE_CHANNEL5_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL5_TITLE
        case 5:
            channelImage = AppKeys.YOUTUBE_CHANNEL6_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL6_TITLE
        case 6:
            channelImage = AppKeys.YOUTUBE_CHANNEL7_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL7_TITLE
        default:
            channelImage = AppKeys.YOUTUBE_CHANNEL1_THUMB
            channelName = AppKeys.YOUTUBE_CHANNEL1_TITLE
        }
        let urlChannel = URL(string: channelImage)
        
        cell.channelNameLabel.text = channelName
        cell.channelImageView.kf.setImage(with: urlChannel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channelArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = 100
        let itemHeight: CGFloat = 130
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}
