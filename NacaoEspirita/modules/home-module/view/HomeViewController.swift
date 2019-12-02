//
//  HomeViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/18/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    var presenter: HomeViewToPresenterProtocol?
    var handle: AuthStateDidChangeListenerHandle?
    
    //TEMP
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func logoutAction(_ sender: Any) {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func actionShowAlert(_ sender: Any) {
        presenter?.chamarAlerta()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                self.nameLabel.text = user.displayName
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.topItem?.title = "Nação Espírita"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.MAIN_BLUE,
             NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 21)!]
    }
}

//MARK: Interaction between Presenter and View
extension HomeViewController: HomePresenterToViewProtocol {
    func mostrarAlerta() {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "APENAS UMA MENSAGEM", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

