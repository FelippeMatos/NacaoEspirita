//
//  HomeScheduleViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 08/01/20.
//  Copyright © 2020 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import Firebase

class HomeScheduleViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var presenter: HomeScheduleViewToPresenterProtocol?
    let dateUtils = DateUtils()
    var selectedDay = ""
    var selectedHour = ""
    var selectedMinute = ""
    var dateTime = ""
    var toSave: Bool?
    var viewToUpdate: HomeViewController?
    
    @IBAction func saveScheduleButton(_ sender: Any) {
        showProgressIndicator(view: self.view)
        self.presenter?.sendScheduleToPresenter(date: dateTime)
    }
    
    @IBAction func deleteScheduleButton(_ sender: Any) {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_CONFIRM, message: "Deseja realmente excluir o agendamento?", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: deleteSchedule))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deleteButton.isHidden = true
        
        setupPickerView()
        
        if !toSave! {
            self.modifyScreen()
        }
    }
    
    func deleteSchedule(action: UIAlertAction) {
        showProgressIndicator(view: self.view)
        self.presenter?.deleteScheduleToPresenter()
    }
    
    fileprivate func setupPickerView() {
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let hour = dateUtils.currentHour() - 1
        let weekDay = dateUtils.getPositionWeekDay(dateUtils.getTodayWeekDay())
        self.dateTime = "\(AppDate.DATE_WEEK_DAYS[weekDay])-feira às \(dateUtils.currentHour()):00h"
        
        pickerView.selectRow(weekDay, inComponent: 0, animated: true)
        pickerView.selectRow(hour, inComponent: 1, animated: true)
    }
    
    func modifyScreen() {
        deleteButton.isHidden = false
        descriptionLabel.text = "Se deseja alterar a data do culto é só mudar para o dia e hora desejada e clicar em modificar, mas caso por algum motivo precise excluir o agendamento, nós iremos entender."
        saveButton.setTitle("Modificar", for: .normal)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if component == 0 {
            return AppDate.DATE_WEEK_DAYS.count
        } else if component == 1 {
            return AppDate.DATE_TIME_HOURS.count
        } else {
            return AppDate.DATE_TIME_MINUTES.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return AppDate.DATE_WEEK_DAYS[row]
        } else if component == 1{
            return AppDate.DATE_TIME_HOURS[row]
        } else {
            return AppDate.DATE_TIME_MINUTES[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        let selectedDay = AppDate.DATE_WEEK_DAYS[pickerView.selectedRow(inComponent: 0)]
        let selectedHour = AppDate.DATE_TIME_HOURS[pickerView.selectedRow(inComponent: 1)]
        let selectedMinute = AppDate.DATE_TIME_MINUTES[pickerView.selectedRow(inComponent: 2)]
        
        self.dateTime = "\(selectedDay)-feira às \(selectedHour):\(selectedMinute)h"
    }
}

//MARK: Interaction between Presenter and View
extension HomeScheduleViewController: HomeSchedulePresenterToViewProtocol {
    func showMessageOfSuccessAndDismiss() {
        hideProgressIndicator(view: self.view)
        
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_CONFIRM, message: "Deu boa!!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: dismissModalScreen))
        self.present(alert, animated: true, completion: nil)
    }
    
    func dismissModalScreen(action: UIAlertAction) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.viewToUpdate?.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
    
    func showError() {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "Problem Save Schedule", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
