//
//  AddQuestionViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/24/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class AddQuestionViewController: UIViewController {

    var presenter: AddQuestionViewToPresenterProtocol?
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            self.containerView.roundCorners(.allCorners, radius: 16)
        }
    }
    @IBOutlet weak var sendQuestionButton: UIButton! {
        didSet {
            self.sendQuestionButton.roundCorners(.allCorners, radius: 16)
        }
    }
    
    @IBOutlet weak var questionTextView: UITextView! {
        didSet {
            self.questionTextView.roundCorners(.allCorners, radius: 16, borderWidth: 1, borderColor: .darkGray)
        }
    }
    
    @IBAction func sendQuestionAction(_ sender: Any) {
        guard let question = self.questionTextView.text, !question.isEmpty else {
            return
        }
        presenter?.saveViewController(navigationController: navigationController!)
        presenter?.sendQuestionToPresenter(question: question)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextView()
        hideKeyboardWhenTappedAround()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    fileprivate func configureTextView() {
        questionTextView.text = AppText.ADD_QUESTION_PLACEHOLDER
        questionTextView.textColor = UIColor.lightGray
        questionTextView.delegate = self
    }

}

extension AddQuestionViewController: AddQuestionPresenterToViewProtocol {
    
    func showError(message: String) {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
}

extension AddQuestionViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = AppText.ADD_QUESTION_PLACEHOLDER
            textView.textColor = UIColor.lightGray
        }
    }
    
}
