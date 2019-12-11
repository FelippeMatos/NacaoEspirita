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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    @objc func logout() {
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

}

