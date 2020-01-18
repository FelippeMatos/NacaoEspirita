//
//  QuestionsViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 10/22/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit

class QuestionsViewController: LoginBaseViewController, UISearchBarDelegate {
    
    var presenter: QuestionsViewToPresenterProtocol?
    var questions: [QuestionModel] = []
    var userLike: [Int] = []
    var topAnswer: [AnswerModel] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredQuestions: [QuestionModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var searchFooterBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var closeSearchOption: UIButton!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBAction func closeSearchOptionAction(_ sender: Any) {
       configureScreenAfterKeyboardDisappear()
    }
    
    @IBOutlet weak var addQuestionButton: UIButton! {
        didSet {
            self.addQuestionButton.roundCorners(.allCorners, radius: 25)
        }
    }
    
    @IBAction func addQuestionAction(_ sender: Any) {
        guard let view = navigationController, navigationController != nil else {
            return
        }
        presenter?.showAddQuestionController(navigationController: view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.startFetchingQuestions()
        
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Procure por perguntas"

        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillHideNotification,
                                       object: nil, queue: .main) { (notification) in
                                        self.handleKeyboard(notification: notification) }
        notificationCenter.addObserver(forName: UIResponder.keyboardWillShowNotification,
                                        object: nil, queue: .main) { (notification) in
                                         self.handleKeyboard(notification: notification) }
        
        setTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureNavigationBar()
    }
    
    fileprivate func configureNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes = [.foregroundColor: AppColor.MAIN_BLUE]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: AppColor.MAIN_BLUE]
            navBarAppearance.backgroundColor = UIColor(named: "color-navigation-background")
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        }
        
        navigationController?.navigationBar.topItem?.title = "Questões"
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: AppColor.MAIN_BLUE,
             NSAttributedString.Key.font: UIFont(name: "Noteworthy-Bold", size: 21)!]
    }
    
    fileprivate func configureScreenAfterKeyboardDisappear() {
        self.searchController.searchBar.endEditing(true)
        closeSearchOption.isHidden = true
        
        let screenHight: CGFloat = UIScreen.main.bounds.height
        self.view.frame.size.height = screenHight - (self.searchController.searchBar.frame.size.height)
        self.view.frame.origin.y = self.searchController.searchBar.frame.size.height
        
        view.layoutIfNeeded()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        configureScreenAfterKeyboardDisappear()
        searchBar.resignFirstResponder()
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredQuestions = questions.filter { (question: QuestionModel) -> Bool in
            return ((question.name?.lowercased().contains(searchText.lowercased()))! || (question.question?.lowercased().contains(searchText.lowercased()))!)
        }
        
        tableView.reloadData()
    }
    
//    func filterContentForSearchText(_ searchText: String, category: QuestionModel.Category? = nil) {
//        filteredCandies = questions.filter { (question: QuestionModel) -> Bool in
//            let doesCategoryMatch = category == .allanKardec || question.category == category
//
//            if isSearchBarEmpty {
//                return doesCategoryMatch
//            } else {
//                return doesCategoryMatch && (question.name?.lowercased().contains(searchText.lowercased()))!
//            }
//        }
//
//        tableView.reloadData()
//    }
    
    func handleKeyboard(notification: Notification) {
        if notification.name == UIResponder.keyboardWillHideNotification {
            searchFooterBottomConstraint.constant = -49
            tableView.frame.origin.y = tableView.frame.origin.y - 72
            self.view.frame.origin.y = self.view.frame.origin.y - 72
            view.layoutIfNeeded()
            return
        }
        
        guard let info = notification.userInfo, let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let keyboardHeight = keyboardFrame.cgRectValue.size.height
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            print("$$$$$$ valor apareceu antes: \(self.searchFooterBottomConstraint.constant)")
            self.searchFooterBottomConstraint.constant = keyboardHeight
            print("$$$$$$ valor apareceu: \(self.searchFooterBottomConstraint.constant)")
            view.layoutIfNeeded()
            return
        }
        
        UIView.animate(withDuration: 0.1, animations: { () -> Void in
            self.searchFooterBottomConstraint.constant = keyboardHeight
            self.closeSearchOption.isHidden = false
            self.view.layoutIfNeeded()
        })
    }
    
    func updateQuestionLike(likeOrDislike: Int, indexQuestion: Int, newValueForStatusLike: Int) {
        self.userLike[indexQuestion] = newValueForStatusLike
        self.questions[indexQuestion].like! += likeOrDislike
        
        let indexPath = IndexPath(item: indexQuestion, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as? QuestionAnswerTableViewCell
        cell?.numberOfLikesLabel.text = "\(self.questions[indexQuestion].like ?? 0) likes"
        
        switch self.userLike[indexQuestion] {
        case 1:
            cell?.setLikeButton()
        case 2:
            cell?.setDislikeButton()
        default:
            cell?.turnOffButtons()
        }
    }
}

//MARK: Interaction between Presenter and View
extension QuestionsViewController: QuestionsPresenterToViewProtocol {
    
    func showQuestions(questionsArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel]) {
        self.questions = questionsArray
        self.userLike = statusUserLikeArray
        self.topAnswer = topAnswerArray
        tableView.reloadData()
        loading.isHidden = true
    }
    
    func showError() {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "Problem Fetching Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}

//MARK: Setup tableview
extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "QuestionAnswerCell", bundle: nil), forCellReuseIdentifier: "QuestionAnswerCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredQuestions.count, of: questions.count)
            return filteredQuestions.count
        }
        
        searchFooter.setNotFiltering()
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerCell", for: indexPath) as! QuestionAnswerTableViewCell
        
        let question: QuestionModel
    
        if isFiltering {
            question = filteredQuestions[indexPath.row]
        } else {
            question = questions[indexPath.row]
        }
        
        if self.userLike[indexPath.row] == 1 {
            cell.setLikeButton()
        } else if self.userLike[indexPath.row] == 2 {
            cell.setDislikeButton()
        } else {
            cell.turnOffButtons()
        }
        
        if topAnswer[indexPath.row].id == nil {
            cell.answerViewHeightConstraint.constant = 0
        } else {
            cell.answerViewHeightConstraint.constant = 104
            
            cell.answerNameLabel.text = topAnswer[indexPath.row].name
            cell.answerLabel.text = topAnswer[indexPath.row].answer
        }
        
        cell.questionView.roundCorners(.allCorners, radius: 12)
        
        cell.nameLabel.text = question.name
        cell.titleLabel.text = question.question
        cell.descriptionLabel.text = question.category
        cell.numberOfLikesLabel.text = "\(question.like ?? 0) likes"
        
        cell.answerTappedWithFocusAction = { (cell) in
            self.answerThe(question: question, focus: true, likeStatus: self.userLike[indexPath.row])
        }
        
        cell.answerTappedWithoutFocusAction = { (cell) in
            self.answerThe(question: question, focus: false, likeStatus: self.userLike[indexPath.row])
        }
        
        cell.buttonLikeTappedAction = { (cell) in
            self.buttonLikeTapped(true, questionId: question.id!)
            
            var likeOrDislike : Int
            var newValueForStatusLike : Int
            switch self.userLike[indexPath.row] {
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
            self.updateQuestionLike(likeOrDislike: likeOrDislike, indexQuestion: indexPath.row, newValueForStatusLike: newValueForStatusLike)
        }
        
        cell.buttonDislikeTappedAction = { (cell) in
            self.buttonLikeTapped(false, questionId: question.id!)
            
            var likeOrDislike : Int
            var newValueForStatusLike : Int
            switch self.userLike[indexPath.row] {
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
            self.updateQuestionLike(likeOrDislike: likeOrDislike, indexQuestion: indexPath.row, newValueForStatusLike: newValueForStatusLike)
        }
        
        return cell
    }
    
    func buttonLikeTapped(_ like: Bool, questionId: String) {
        presenter?.sendActionLike(like, questionId: questionId)
    }
    
    func answerThe(question: QuestionModel, focus: Bool, likeStatus: Int) {
        guard let view = navigationController, navigationController != nil else {
            return
        }
        presenter?.goToAddAnswerScreen(question: question, navigationController: view, focus: focus, likeStatus: likeStatus)
    }
}

extension QuestionsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
