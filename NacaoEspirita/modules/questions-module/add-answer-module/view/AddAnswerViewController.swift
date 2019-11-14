//
//  AddAnswerViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/25/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class AddAnswerViewController: UIViewController {

    var presenter: AddAnswerViewToPresenterProtocol?
    var question: QuestionModel?
    var previousRect = CGRect.zero
    var questionId: String?
    var focus: Bool?
    var likeStatus : Int?
    var answerLikeStatus: [Bool] = []
    var answers: [AnswerModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerAnswerView: UIView!
    @IBOutlet weak var containerAnswerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerView: UIView!
    @IBOutlet weak var answerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var containerAnswerViewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var sendAnswerButton: UIButton!
    
    @IBAction func sendAnswerAction(_ sender: Any) {
        guard let answer = answerTextView.text, !answerTextView.text.isEmpty else {
            return
        }
        
        presenter?.saveViewController(navigationController: navigationController!)
        presenter?.sendAnswerToPresenter(answer: answer, id: questionId!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let questionId = self.question?.id, !questionId.isEmpty else {
            return
        }
        self.questionId = questionId
        presenter?.startFetchingAnswers(questionId: questionId)
        
        configureTextView()
        hideKeyboardWhenTappedAround()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        
        self.setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let focus = focus, focus else {
            return
        }
        
        if focus {
            answerTextView.becomeFirstResponder()
        }
    }
    
    fileprivate func configureTextView() {
        answerTextView.text = AppText.ADD_ANSWER_PLACEHOLDER
        answerTextView.textColor = UIColor.lightGray
        answerTextView.delegate = self
    }
    
    func handleKeyboard(notification: Notification) {
        guard notification.name == UIResponder.keyboardWillChangeFrameNotification else {
            containerAnswerViewBottonConstraint.constant = 0
            view.layoutIfNeeded()
            return
        }
        
        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.containerAnswerViewBottonConstraint.constant = keyboardHeight
            self.view.layoutIfNeeded()
        })
    }
    
    func updateQuestionLike(likeOrDislike: Int, newValueForStatusLike: Int) {
        self.likeStatus = newValueForStatusLike
        self.question?.like! += likeOrDislike
        
        let indexPath = IndexPath(item: 0, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? QuestionTableViewCell
        cell?.numberOfLikesLabel.text = "\(self.question!.like ?? 0) likes"
        
        switch self.likeStatus {
        case 1:
            cell?.setLikeButton()
        case 2:
            cell?.setDislikeButton()
        default:
            cell?.turnOffButtons()
        }
    }
    
    func updateAnswerLike(indexAnswer: Int) {
        var like = 1
        if !self.answerLikeStatus[indexAnswer-1] {
            like = -1
        }
        self.answers[indexAnswer-1].like! += like
        
        let indexPath = IndexPath(item: indexAnswer, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? AnswerTableViewCell
        cell?.numberOfLikesLabel.text = "\(self.answers[indexAnswer-1].like ?? 0) likes"
        cell?.setLikeButton(isTrue: self.answerLikeStatus[indexAnswer-1])
    }

}

//MARK: Result of PRESENTER
extension AddAnswerViewController: AddAnswerPresenterToViewProtocol {
    
    func showAnswers(answersArray: [AnswerModel], statusUserLikeArray: [Bool]) {
        self.answers = answersArray
        self.answerLikeStatus = statusUserLikeArray
        self.tableView.reloadData()
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func updateAnswers() {
        presenter?.startFetchingAnswers(questionId: questionId!)
        self.answerTextView.text = nil
    }
}

//MARK: TextView configuration
extension AddAnswerViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = AppText.ADD_ANSWER_PLACEHOLDER
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        self.previousRect = self.previousRect.origin.y == 0.0 ? currentRect : self.previousRect
        
        if currentRect.origin.y > self.previousRect.origin.y {
            if self.containerAnswerViewHeightConstraint.constant < 148 {
                self.containerAnswerViewHeightConstraint.constant += 12
                self.answerViewHeightConstraint.constant += 12
            }
        }
        self.previousRect = currentRect
        
        if textView.text.isEmpty {
            self.sendAnswerButton.isEnabled = false
            self.sendAnswerButton.setTitleColor(AppColor.GRAY_BUTTON_DISABLED, for: .normal)
        } else if textView.text.count > 12 {
            self.sendAnswerButton.isEnabled = true
            self.sendAnswerButton.setTitleColor(AppColor.MAIN_BLUE, for: .normal)
        }
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let pos = textView.endOfDocument
        let currentRect = textView.caretRect(for: pos)
        self.previousRect = self.previousRect.origin.y == 0.0 ? currentRect : self.previousRect
        
        if let char = text.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92)  && (currentRect.origin.x == 4) {
                if self.containerAnswerViewHeightConstraint.constant > 96 {
                    self.containerAnswerViewHeightConstraint.constant -= 12
                    self.answerViewHeightConstraint.constant -= 12
                }
            }
        }
        return true
    }
    
}

//MARK: TableView
extension AddAnswerViewController: UITableViewDelegate, UITableViewDataSource {

    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
        self.tableView.register(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  answers.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionTableViewCell
            
            switch likeStatus {
            case 1: cell.setLikeButton()
            case 2: cell.setDislikeButton()
            default: cell.turnOffButtons()
            }
            
            cell.nameLabel.text = self.question!.name
            cell.questionLabel.text = self.question!.question
            cell.categoryLabel.text = self.question!.category
            cell.numberOfLikesLabel.text = "\(self.question!.like ?? 0) likes"
            
            cell.buttonLikeTappedAction = { (cell) in
                self.buttonLikeTapped(true, questionId: (self.question?.id)!)
                
                var likeOrDislike : Int
                var newValueForStatusLike : Int
                switch self.likeStatus {
                case 1:
                    likeOrDislike = -1
                    newValueForStatusLike = 0
                case 2:
                    likeOrDislike = 2
                    newValueForStatusLike = 1
                default:
                    likeOrDislike = 1
                    newValueForStatusLike = 1
                }
                self.updateQuestionLike(likeOrDislike: likeOrDislike, newValueForStatusLike: newValueForStatusLike)
            }
            
            cell.buttonDislikeTappedAction = { (cell) in
                self.buttonLikeTapped(false, questionId: (self.question?.id)!)
                
                var likeOrDislike : Int
                var newValueForStatusLike : Int
                switch self.likeStatus {
                case 1:
                    likeOrDislike = -2
                    newValueForStatusLike = 2
                case 2:
                    likeOrDislike = 1
                    newValueForStatusLike = 0
                default:
                    likeOrDislike = -1
                    newValueForStatusLike = 2
                }
                self.updateQuestionLike(likeOrDislike: likeOrDislike, newValueForStatusLike: newValueForStatusLike)
            }
            
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerTableViewCell
            
            let answer: AnswerModel = answers[indexPath.row-1]
            let likeStatus = self.answerLikeStatus[indexPath.row-1]
            
            cell.containerView.roundCorners(.allCorners, radius: 12)
            cell.topBorderView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: true)
            cell.bottomBorderView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: true)
            cell.centerBorderView.addDashedBorder(width: 1, color: UIColor.lightGray, isVertical: false)
            
            cell.nameLabel.text = answer.name
            cell.answerLabel.text = answer.answer
            cell.numberOfLikesLabel.text = "\(answer.like ?? 0) likes"
        
            if self.answerLikeStatus.count == answers.count {
                cell.setLikeButton(isTrue: likeStatus)
            }
            
            cell.buttonLikeTappedAction = { (cell) in
                if self.answerLikeStatus[indexPath.row-1] {
                    self.answerLikeStatus[indexPath.row-1] = false
                } else {
                    self.answerLikeStatus[indexPath.row-1] = true
                }
                self.buttonLikeAnswerTapped(self.answerLikeStatus[indexPath.row-1], questionId: (self.question?.id)!, answerId: answer.id!)
                self.updateAnswerLike(indexAnswer: indexPath.row)
            }
            
            cell.bottomBorderView.isHidden = false
            if indexPath.row == answers.count {
                cell.bottomBorderView.isHidden = true
            }
            
            return cell
        }
    }
    
    func buttonLikeTapped(_ like: Bool, questionId: String) {
        presenter?.sendActionLike(like, questionId: questionId)
    }
    
    func buttonLikeAnswerTapped(_ like: Bool, questionId: String, answerId: String) {
        presenter?.sendActionLikeAnswer(like, questionId: questionId, answerId: answerId)
    }
    
}
