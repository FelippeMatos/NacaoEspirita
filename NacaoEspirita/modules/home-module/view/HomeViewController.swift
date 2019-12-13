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
    
    var transparentView = UIView()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.presenter?.startFetchingMessageOfTheDay()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
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
    func showMessageOfTheDay() {
        let sections = IndexSet.init(integer: 0)
        tableView.reloadSections(sections, with: .none)
    }
    
    func showError() {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "Problem Fetching Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MessageProfileCell", bundle: nil), forCellReuseIdentifier: "MessageProfileCell")
        self.tableView.register(UINib(nibName: "EvangelhoNoLarCell", bundle: nil), forCellReuseIdentifier: "EvangelhoNoLarCell")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageProfileCell", for: indexPath) as! MessageProfileTableViewCell
            
            cell.myInit(message: UserDefaults.standard.messageOfTheDay ?? "", author: UserDefaults.standard.authorMessageOfTheDay ?? "", numberOfLines: 4, padding: 16, profile: false)
             
             cell.delegate = self
            
             return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "EvangelhoNoLarCell", for: indexPath) as! EvangelhoNoLarTableViewCell
            
            cell.moreAction = { (cell) in
                if let viewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: HomeMoreViewController.self)) as? HomeMoreViewController {
                    viewController.modalPresentationStyle = .formSheet
                    viewController.popoverPresentationController?.sourceView = self.view
                    viewController.popoverPresentationController?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: self.view.frame.width - 90, height: self.view.frame.height - 100)
                    viewController.popoverPresentationController?.delegate = self
                    viewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
                    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                        self.present(viewController, animated: true, completion: nil)
                    }, completion: nil)
                   
                }
            }
            cell.scheduleAction = { (cell) in
                print("$$$$$$ AGENDAR!")
            }
            
            return cell
        }
        
    }
}

extension HomeViewController: MessageProfileCellDelegate {
    func moreTapped(cell: MessageProfileTableViewCell) {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        })
    }
}

extension HomeViewController: UIPopoverPresentationControllerDelegate{
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
}
