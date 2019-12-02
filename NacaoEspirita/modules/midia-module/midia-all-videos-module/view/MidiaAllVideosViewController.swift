//
//  MidiaAllVideosViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 27/11/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Kingfisher

class MidiaAllVideosViewController: UIViewController {

    var presenter: MidiaAllVideosViewToPresenterProtocol?
    
    var videoArray: [VideoModel] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredVideos: [VideoModel] = []
    var isFilteringByChannel: Bool = false
    var channelSelected = ""
    
    @IBOutlet weak var closeSearchOption: UIButton!
    @IBAction func closeSearchOptionAction(_ sender: Any) {
        self.searchController.searchBar.endEditing(true)
        closeSearchOption.isHidden = true
    }
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
        setSearchBar()
        presenter?.startFetchingVideos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = "Vídeos"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.MAIN_BLUE,
             NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 21)!]
    }
    
    func setSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Procure por um vídeo específico"
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        //        searchController.searchBar.scopeButtonTitles = Candy.Category.allCases.map { $0.rawValue }
        //        searchController.searchBar.delegate = self
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredVideos.removeAll()
        filteredVideos = videoArray.filter { (video: VideoModel) -> Bool in
            return ((video.title?.lowercased().contains(searchText.lowercased()))! || (video.channelTitle?.lowercased().contains(searchText.lowercased()))!)
        }
        
        tableView.reloadData()
    }
    
    func filterContentForChannel(_ channelText: String) {
        filteredVideos.removeAll()
        filteredVideos = videoArray.filter { (video: VideoModel) -> Bool in
            return (video.channelTitle?.lowercased().contains(channelText.lowercased()))!
        }
    }
    
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            view.layoutIfNeeded()
            return
        }
        
        guard let info = notification.userInfo, let _ = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.closeSearchOption.isHidden = false
            self.view.layoutIfNeeded()
        })
    }

}

//MARK: Interaction between Presenter and View
extension MidiaAllVideosViewController: MidiaAllVideosPresenterToViewProtocol {
    
    func showVideos(videosArray: [VideoModel]) {
        self.videoArray = videosArray
        self.tableView.reloadData()
    }
    
    func showError() {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "Problem Fetching Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MidiaAllVideosViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "VideoTableCell", bundle: nil), forCellReuseIdentifier: "VideoTableCell")
        self.tableView.register(UINib(nibName: "HeaderMidiaAllVideos", bundle: nil), forCellReuseIdentifier: HeaderMidiaAllVideosView.reuseIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredVideos.count
        }
        
        return videoArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderMidiaAllVideos", for: indexPath) as! HeaderMidiaAllVideosView
            cell.tableView = self.tableView
            if let channelSelected = cell.channelSelected {
                if self.channelSelected == channelSelected {
                    isFilteringByChannel = false
                    self.channelSelected = ""
                } else {
                    filterContentForChannel(channelSelected)
                    isFilteringByChannel = true
                    self.channelSelected = channelSelected
                }
                cell.channelSelected = nil
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoTableCell", for: indexPath) as! VideoTableViewCell
            
            let video: VideoModel
            
            if isFiltering || isFilteringByChannel {
                video = filteredVideos[indexPath.row-1]
            } else {
                video = self.videoArray[indexPath.row-1]
            }
            
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
            
            cell.videoTappedAction = { (cell) in
                self.presenter?.goToVideoDisplayScreen(navigationController: self.navigationController!, id: video.id!)
            }
            
            return cell
        }
    }
}

extension MidiaAllVideosViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
