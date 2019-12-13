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
    var transparentView = UIView()
    var userName: String?
    
    let height: CGFloat = 70
    var settingArray = ["Logout"]
    
    @IBOutlet weak var tableView: UITableView!
    var menuTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 100
        
        setTableView()
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
        let logoutButton = UIBarButtonItem(image: UIImage(named: "icon-menu")!.imageWithSize(CGSize(width: 30, height: 30)), style: .plain, target: self, action: #selector(openMenu))
        navigationItem.rightBarButtonItems = [logoutButton]
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = "Perfil"
        navigationController?.navigationItem.rightBarButtonItem = logoutButton
        navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.MAIN_BLUE,
             NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 21)!]
    }

    @objc func openMenu() {
        let window = UIApplication.shared.keyWindow
        let screenSize = UIScreen.main.bounds.size
        
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = CGRect(x: 0, y: -45, width: screenSize.width, height: screenSize.height + 45)
        window?.addSubview(transparentView)
        
        menuTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        menuTableView.backgroundColor = UIColor(named: "color-background")
        menuTableView.layer.cornerRadius = 12
        window?.addSubview(menuTableView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        transparentView.addGestureRecognizer(tapGesture)
        transparentView.alpha = 0
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0.7
            self.menuTableView.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func onClickTransparentView() {
        let screenSize = UIScreen.main.bounds.size

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transparentView.alpha = 0
            self.menuTableView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    func logout() {
        do{
           try Auth.auth().signOut()
           
           let loginVC = LoginRouter.createModule()
           let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
           let navigationController = UINavigationController()
           
           navigationController.viewControllers = [loginVC]
           appDelegate.window!.rootViewController = navigationController

       }catch{
       }
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
        
        self.menuTableView.isScrollEnabled = false
        self.menuTableView.delegate = self
        self.menuTableView.dataSource = self
        self.menuTableView.register(UINib(nibName: "MenuOptionCell", bundle: nil), forCellReuseIdentifier: "MenuOptionCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === menuTableView {
            return settingArray.count
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView === menuTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuOptionCell") as! MenuOptionTableViewCell
            cell.titleLabel.text = settingArray[indexPath.row]
            return cell
        } else {
            switch indexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderProfileCell", for: indexPath) as! HeaderProfileTableViewCell
                
                cell.userNameLabel.text = userName ?? "XUNDA"
                
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "MessageProfileCell", for: indexPath) as! MessageProfileTableViewCell
                cell.myInit(message: "Podeis, sim, ser feliz. \nMas isso tem um preço.\n\nAceita-te como és,\nSem esperar destaque. \n\nConserva a disciplina\nDe teus próprios impulsos.", numberOfLines: 2, padding: 9, profile: true)
                
                cell.delegate = self
               
                return cell
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderProfileCell", for: indexPath) as! HeaderProfileTableViewCell
                
                cell.userNameLabel.text = userName ?? "-"
                
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === menuTableView {
            if indexPath.row == 0 {
                logout()
            }
        }
        
    }
}

extension ProfileViewController: MessageProfileCellDelegate {
    func moreTapped(cell: MessageProfileTableViewCell) {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        })
    }
}
