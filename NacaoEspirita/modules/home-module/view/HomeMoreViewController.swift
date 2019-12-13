//
//  HomeMoreViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 12/12/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class HomeMoreViewController: UIViewController {

    var tableViewData = [cellData]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setTableViewData()
        setTableView()
    }

}

extension HomeMoreViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableViewData() {
    
        tableViewData = [cellData(opened: true, title: "Significado", sectionData: ["“Quando o ensinamento do Mestre vibra entre quatro paredes de um templo doméstico, os pequeninos sacrifícios tecem a felicidade comum.” \n\n\n Psicografia de Francisco C. Xavier, Luz no lar, Autores diversos, 85. ed.\nRio de Janeiro: FEB, 1997. Cap. 1, p. 11 e 12."]),
                         cellData(opened: false, title: "Fundamentação Doutrinária", sectionData: ["Cell1", "Cell2", "Cell3"]),
                         cellData(opened: false, title: "Finalidade e importância", sectionData: ["Cell1", "Cell2", "Cell3"]),
                         cellData(opened: false, title: "Como fazer", sectionData: ["Cell1", "Cell2", "Cell3"]),
                         cellData(opened: false, title: "Livros indicados", sectionData: ["Cell1", "Cell2", "Cell3"])]
    }
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "MoreInfoHeaderCell", bundle: nil), forCellReuseIdentifier: "MoreInfoHeaderCell")
        self.tableView.register(UINib(nibName: "MoreInfoCell", bundle: nil), forCellReuseIdentifier: "MoreInfoCell")
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true {
            return tableViewData[section].sectionData.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataIndex = indexPath.row - 1 
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoHeaderCell", for: indexPath) as! MoreInfoHeaderTableViewCell
            cell.titleLabel.text = tableViewData[indexPath.section].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MoreInfoCell", for: indexPath) as! MoreInfoTableViewCell
            cell.infosLabel.text = tableViewData[indexPath.section].sectionData[dataIndex]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if tableViewData[indexPath.section].opened == true {
                tableViewData[indexPath.section].opened = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            } else {
                tableViewData[indexPath.section].opened = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
    
}
