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
    
    var categories = ["Livros", "Videos", "Podcasts"]
    var bookArray = ["Evangelho", "Espiritos", "Medium", "A genese"]
    var videoArray = ["Divaldo", "Chico", "Haroldo"]
    var podcastArray = ["Nao sei", "Preciso", "Pesquisar", "he he"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }

}

//MARK: Interaction between Presenter and View
extension MidiaViewController: MidiaPresenterToViewProtocol {
    
}

extension MidiaViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "BookSectionCell", bundle: nil), forCellReuseIdentifier: "BookSectionCell")
        self.tableView.register(UINib(nibName: "VideoSectionCell", bundle: nil), forCellReuseIdentifier: "VideoSectionCell")
        self.tableView.register(UINib(nibName: "PodcastSectionCell", bundle: nil), forCellReuseIdentifier: "PodcastSectionCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BookSectionCell", for: indexPath) as! BookSectionTableViewCell
            cell.bookArray = self.bookArray
            cell.navigationController = navigationController
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "VideoSectionCell", for: indexPath) as! VideoSectionTableViewCell
            cell.videoArray = self.videoArray
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastSectionCell", for: indexPath) as! PodcastSectionTableViewCell
            cell.podcastArray = self.podcastArray
            return cell
        }
        
        

    }

}
