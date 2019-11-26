//
//  MidiaViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class MidiaViewController: UIViewController {

    var presenter: MidiaViewToPresenterProtocol?
    @IBOutlet weak var tableView: UITableView!
    
    var categories = ["LIVROS", "VÍDEOS"]
    var bookArray: [BookModel] = []
    var videoArray: [VideoModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
        presenter?.startFetchingVideos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
        presenter?.startFetchingBooks()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = "Nação Espírita"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.MAIN_BLUE,
             NSAttributedString.Key.font: UIFont(name: "AmericanTypewriter-Bold", size: 21)!]
    }

}

//MARK: Interaction between Presenter and View
extension MidiaViewController: MidiaPresenterToViewProtocol {
    
    func showBooks(booksArray: [BookModel]) {
        self.bookArray = booksArray
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? BookSectionTableViewCell
        cell?.reloadCell(bookArrayList: booksArray)
        
    }
    
    func showVideos(videosArray: [VideoModel]) {
        self.videoArray = videosArray
        
        let indexPath = IndexPath(item: 0, section: 1)
        let cell = tableView.cellForRow(at: indexPath) as? VideoSectionTableViewCell
        cell?.reloadCell(videoArrayList: videoArray)
    }
    
    func showError() {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "Problem Fetching Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension MidiaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "BookSectionCell", bundle: nil), forCellReuseIdentifier: "BookSectionCell")
        self.tableView.register(UINib(nibName: "VideoSectionCell", bundle: nil), forCellReuseIdentifier: "VideoSectionCell")
        self.tableView.register(UINib(nibName: "PodcastSectionCell", bundle: nil), forCellReuseIdentifier: "PodcastSectionCell")
        self.tableView.register(UINib(nibName: "HeaderMidiaView", bundle: nil), forHeaderFooterViewReuseIdentifier: HeaderMidiaView.reuseIdentifier)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderMidiaView") as! HeaderMidiaView
        
        headerView.categoryTitleLabel.text = categories[section]
        headerView.sectionNumber = section
        headerView.delegate = self
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookSectionCell", for: indexPath) as! BookSectionTableViewCell
            cell.bookArray = self.bookArray
            cell.navigationController = navigationController
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoSectionCell", for: indexPath) as! VideoSectionTableViewCell
            cell.videoArray = self.videoArray
            return cell
        }
    }
}

extension MidiaViewController: HeaderMidiaDelegate {
    func headerMidiaView(_ headerMidiaView: HeaderMidiaView, didTapButtonInSection section: Int) {
        if section == 0 {
            presenter?.goToMidiaAllBooksScreen(navigationController: navigationController!)
        }
    }
}
