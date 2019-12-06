//
//  ProfileViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 06/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    var presenter: ProfileViewToPresenterProtocol?
    var handle: AuthStateDidChangeListenerHandle?
    
    var userName: String?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.userName = user.displayName
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = "Perfil"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.MAIN_BLUE,
             NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 21)!]
    }

}

//MARK: Interaction between Presenter and View
extension ProfileViewController: ProfilePresenterToViewProtocol {
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "HeaderProfileCell", bundle: nil), forCellReuseIdentifier: "HeaderProfileCell")
        self.tableView.register(UINib(nibName: "MessageProfileCell", bundle: nil), forCellReuseIdentifier: "MessageProfileCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderProfileCell", for: indexPath) as! HeaderProfileTableViewCell
            
            cell.userNameLabel.text = userName ?? "XUNDA"
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageProfileCell", for: indexPath) as! MessageProfileTableViewCell
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderProfileCell", for: indexPath) as! HeaderProfileTableViewCell
            
            cell.userNameLabel.text = userName ?? "XUNDA"
            
            return cell
        }
        
    }
    
    
}
