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
    var pinQuestions: [Bool] = []
    let searchController = UISearchController(searchResultsController: nil)
    var filteredQuestions: [QuestionModel] = []
    var allQuestions = true
    
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
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                     #selector(QuestionsViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor(named: "color-answer-background")
        
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presenter?.startFetchingNumberOfQuestionsInFB()
        
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
            self.searchFooterBottomConstraint.constant = keyboardHeight
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
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
       
        presenter?.startFetchingQuestions(allQuestions)
        refreshControl.endRefreshing()
    }
}

//MARK: Interaction between Presenter and View
extension QuestionsViewController: QuestionsPresenterToViewProtocol {
    
    func showQuestions(questionsArray: [QuestionModel], statusUserLikeArray: [Int], topAnswerArray: [AnswerModel], pinQuestionsArray: [Bool], newIndexPathsToReload: [IndexPath]?) {
        self.questions = questionsArray
        self.userLike = statusUserLikeArray
        self.topAnswer = topAnswerArray
        self.pinQuestions = pinQuestionsArray
        
        guard let newIndexPathsToReload = newIndexPathsToReload else {
          loading.isHidden = true
          tableView.reloadData()
          return
        }
        tableView.reloadData()
        // 2
//        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
//        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSuccess() {
        //TODO: Arrumar esse alerta / - retirar os textos fixos
        let alert = UIAlertController(title: AppAlert.ALERT_ERROR, message: "BOAAAAAA Fetching Cards", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: AppAlert.ALERT_CONFIRM, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: Setup tableview
extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func setTableView() {
        self.tableView.prefetchDataSource = self
        self.tableView.addSubview(self.refreshControl)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "QuestionAnswerCell", bundle: nil), forCellReuseIdentifier: "QuestionAnswerCell")
        self.tableView.register(UINib(nibName: "QuestionSegmentedCell", bundle: nil), forCellReuseIdentifier: "QuestionSegmentedCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredQuestions.count, of: questions.count)
            return filteredQuestions.count + 1
        }
        
        searchFooter.setNotFiltering()
        let number = (presenter?.getNumberOfQuestions())! + 1
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionSegmentedCell", for: indexPath) as! QuestionSegmentedTableViewCell
            
            cell.allTappedAction = { (cell) in
                self.loading.isHidden = false
                self.allQuestions = true
                self.presenter?.startFetchingQuestions(self.allQuestions)
            }
            
            cell.savedTappedAction = { (cell) in
                self.loading.isHidden = false
                self.presenter?.startFetchingSavedQuestions()
            }
            
            cell.mineTappedAction = { (cell) in
                self.loading.isHidden = false
                self.allQuestions = false
                self.presenter?.startFetchingQuestions(self.allQuestions)
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionAnswerCell", for: indexPath) as! QuestionAnswerTableViewCell
                
            let question: QuestionModel
            let index = indexPath.row - 1
            
            if isFiltering {
                question = filteredQuestions[index]
            } else {
                question = questions[index]
            }
            
            if self.userLike[index] == 1 {
                cell.setLikeButton()
            } else if self.userLike[index] == 2 {
                cell.setDislikeButton()
            } else {
                cell.turnOffButtons()
            }
            
            if self.pinQuestions[index] {
                cell.pinButton.setImage(UIImage(named: "icon-pin-on"), for: .normal)
            } else {
                cell.pinButton.setImage(UIImage(named: "icon-pin-off"), for: .normal)
            }
            
            if topAnswer[index].id == nil {
                cell.answerViewHeightConstraint.constant = 0
            } else {
                cell.answerViewHeightConstraint.constant = 104
                
                cell.answerNameLabel.text = topAnswer[index].name
                cell.answerLabel.text = topAnswer[index].answer
            }
            
            cell.questionView.roundCorners(.allCorners, radius: 12)
            
            cell.nameLabel.text = question.name
            cell.titleLabel.text = question.question
            cell.descriptionLabel.text = question.category
            cell.numberOfLikesLabel.text = "\(question.like ?? 0) likes"
            
            cell.answerTappedWithFocusAction = { (cell) in
                self.answerThe(question: question, focus: true, likeStatus: self.userLike[index])
            }
            
            cell.answerTappedWithoutFocusAction = { (cell) in
                self.answerThe(question: question, focus: false, likeStatus: self.userLike[index])
            }
            
            cell.buttonLikeTappedAction = { (cell) in
                self.likeActionTapped(true, questionId: question.id!)
                
                var likeOrDislike : Int
                var newValueForStatusLike : Int
                switch self.userLike[index] {
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
                self.updateQuestionLike(likeOrDislike: likeOrDislike, indexQuestion: index, newValueForStatusLike: newValueForStatusLike)
            }
            
            cell.buttonDislikeTappedAction = { (cell) in
                self.likeActionTapped(false, questionId: question.id!)
                
                var likeOrDislike : Int
                var newValueForStatusLike : Int
                switch self.userLike[index] {
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
                self.updateQuestionLike(likeOrDislike: likeOrDislike, indexQuestion: index, newValueForStatusLike: newValueForStatusLike)
            }
            
            cell.pinSaveTappedAction = { (cell) in
                self.pinButtonTapped(question.id!, toSave: true)
            }

            cell.pinDeleteTappedAction = { (cell) in
                self.pinButtonTapped(question.id!, toSave: false)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            print("$$$$$$ ACIONOU O PREFETCH")
            presenter?.startFetchingQuestions(allQuestions)
        }
    }
    
    func likeActionTapped(_ like: Bool, questionId: String) {
        presenter?.sendLikeAction(like, questionId: questionId)
    }
    
    func pinButtonTapped(_ questionId: String, toSave: Bool) {
        presenter?.sendPinAction(questionId, toSave: toSave)
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

private extension QuestionsViewController {
  func isLoadingCell(for indexPath: IndexPath) -> Bool {
    return indexPath.row >= questions.count
  }
  
  func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
    let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
    let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
    return Array(indexPathsIntersection)
  }
}
