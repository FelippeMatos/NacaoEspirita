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
    var toSave: Bool?
    let dateUtils = DateUtils()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.presenter?.startFetchingMessageOfTheDay()
        
        checkDayOfEvangelho()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
        tableView.reloadData()
    }
    
    func checkDayOfEvangelho() {
        self.presenter?.checkIfIsNeedFetchMessage()
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
    
    func showMessageOfTheEvangelho() {
        let sections = IndexSet.init(integer: 1)
        tableView.reloadSections(sections, with: .none)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: message, preferredStyle: UIAlertController.Style.alert)
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
        self.tableView.register(UINib(nibName: "EvangelhoNoLarScheduledCell", bundle: nil), forCellReuseIdentifier: "EvangelhoNoLarScheduledCell")
        self.tableView.register(UINib(nibName: "EvangelhoNoLarDayCell", bundle: nil), forCellReuseIdentifier: "EvangelhoNoLarDayCell")
        
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
            if UserDefaults.standard.dateSchedulingOfEvangelhoNoLar != nil {
                if (presenter?.compareDateScheduledWithDateNow())! {
                    self.toSave = false
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "EvangelhoNoLarDayCell", for: indexPath) as! EvangelhoNoLarDayTableViewCell
                    
                    cell.messageLabel.text = UserDefaults.standard.messageOfTheEvangelho!
                    cell.authorLabel.text = "- " + UserDefaults.standard.authorMessageOfTheEvangelho!
                    
                    cell.modifyScheduleAction = { (cell) in
                        self.createScreenScheduleEvangelho()
                    }
                    
                    return cell
                }
                self.toSave = false
        
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvangelhoNoLarScheduledCell", for: indexPath) as! EvangelhoNoLarScheduledTableViewCell

                cell.dateLabel.text = UserDefaults.standard.dateSchedulingOfEvangelhoNoLar
                cell.modifyScheduleAction = { (cell) in
                    self.createScreenScheduleEvangelho()
                }
                
                return cell
            } else {
                self.toSave = true
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "EvangelhoNoLarCell", for: indexPath) as! EvangelhoNoLarTableViewCell
                
                cell.moreAction = { (cell) in
                    self.createScreenMoreInfoEvangelho()
                }
                cell.scheduleAction = { (cell) in
                    self.createScreenScheduleEvangelho()
                }
                
                return cell
            }
            
        }
        
    }
    
    
    
    fileprivate func createScreenMoreInfoEvangelho() {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: String(describing: HomeMoreViewController.self)) as? HomeMoreViewController {
            viewController.modalPresentationStyle = .formSheet
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                
                self.navigationController?.pushViewController(viewController, animated: true)
                self.present(viewController, animated: true, completion: nil)
            }, completion: nil)
            
        }
    }
    
    fileprivate func createScreenScheduleEvangelho() {
        presenter?.goToScheduleEvangelhoScreen(view: self, toSave: self.toSave!)
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
