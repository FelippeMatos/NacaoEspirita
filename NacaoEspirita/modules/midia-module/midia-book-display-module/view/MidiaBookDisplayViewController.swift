//
//  MidiaBookDisplayViewController.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/8/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import UIKit
import PDFKit
import MessageUI
import UIKit.UIGestureRecognizerSubclass

class MidiaBookDisplayViewController: UIViewController, UIPopoverPresentationControllerDelegate, PDFViewDelegate, SearchViewControllerDelegate, ThumbnailGridViewControllerDelegate, OutlineViewControllerDelegate, BookmarkViewControllerDelegate {

    var presenter: MidiaBookDisplayViewToPresenterProtocol?
    var pdfUrl: URL!
    var document: PDFDocument!
    var outline: PDFOutline?
    var pdfView = PDFView()
    var bookmarkButton: UIBarButtonItem!
    var searchNavigationController: UINavigationController?
    
    let barHideOnTapGestureRecognizer = UITapGestureRecognizer()
    let pdfViewGestureRecognizer = PDFViewGestureRecognizer()
    
    @IBOutlet weak var thumbnailGridViewConainer: UIView!
    @IBOutlet weak var outlineViewConainer: UIView!
    @IBOutlet weak var bookmarkViewConainer: UIView!
    
    let tableOfContentsToggleSegmentedControl = UISegmentedControl(items: [#imageLiteral(resourceName: "icon-grid"), #imageLiteral(resourceName: "icon-list"), #imageLiteral(resourceName: "icon-bookmark-off")])
    
    private var thumbnailView = PDFThumbnailView()
    private var outlineButton = UIButton()
    private var dismissButton = UIButton()
    
    @IBOutlet weak var pageNumberLabel: UILabel!
    @IBOutlet weak var pageNumberLabelContainer: UIView! {
        didSet {
            self.pageNumberLabelContainer.roundCorners(.allCorners, radius: 12)
        }
    }
    
    @IBOutlet private var doubleTapGesture: UITapGestureRecognizer!
    @IBAction private func doubleTapAction(_ sender: UITapGestureRecognizer) {
        print("DOUBLE TAP")
        pdfView.autoZoomInOrOut(location: sender.location(in: pdfView), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationViewPage()
        
        tableOfContentsToggleSegmentedControl.selectedSegmentIndex = 0
        tableOfContentsToggleSegmentedControl.addTarget(self, action: #selector(toggleTableOfContentsView(_:)), for: .valueChanged)
        
        setupPDFView()
        setupThumbnailView()
        
        resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? ThumbnailGridViewController {
            viewController.pdfDocument = document
            viewController.delegate = self
        } else if let viewController = segue.destination as? OutlineViewController {
            viewController.pdfDocument = document
            viewController.delegate = self
        } else if let viewController = segue.destination as? BookmarkViewController {
            viewController.pdfDocument = document
            viewController.delegate = self
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        pdfView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let thumbanilHeight: CGFloat = 80
        thumbnailView.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: thumbnailView)
        view.addConstraintsWithFormat(format: "V:[v0(\(thumbanilHeight))]|", views: thumbnailView)
    }
    
    func searchViewController(_ searchViewController: SearchViewController, didSelectSearchResult selection: PDFSelection) {
        selection.color = .yellow
        pdfView.currentSelection = selection
        pdfView.go(to: selection)
        showBars()
    }
    
    func thumbnailGridViewController(_ thumbnailGridViewController: ThumbnailGridViewController, didSelectPage page: PDFPage) {
        resume()
        pdfView.go(to: page)
    }
    
    func outlineViewController(_ outlineViewController: OutlineViewController, didSelectOutlineAt destination: PDFDestination) {
        resume()
        pdfView.go(to: destination)
    }
    
    func bookmarkViewController(_ bookmarkViewController: BookmarkViewController, didSelectPage page: PDFPage) {
        resume()
        pdfView.go(to: page)
    }
    
    private func resume() {
        let backButton = UIBarButtonItem(image: UIImage(named: "icon-back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back(_:)))
        let tableOfContentsButton = UIBarButtonItem(image: UIImage(named: "icon-list")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showTableOfContents(_:)))
        //        let actionButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showActionMenu(_:)))
        navigationItem.leftBarButtonItems = [backButton, tableOfContentsButton]
        
        let brightnessButton = UIBarButtonItem(image: UIImage(named: "icon-brightness")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showAppearanceMenu(_:)))
        let searchButton = UIBarButtonItem(image: UIImage(named: "icon-search")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(showSearchView(_:)))
        bookmarkButton = UIBarButtonItem(image: UIImage(named: "icon-bookmark-off")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addOrRemoveBookmark(_:)))
        navigationItem.rightBarButtonItems = [bookmarkButton, searchButton, brightnessButton]
        
        thumbnailView.alpha = 1
        
        pdfView.isHidden = false
        pageNumberLabelContainer.alpha = 1
        
        barHideOnTapGestureRecognizer.isEnabled = true
        
//        updateBookmarkStatus()
        updatePageNumberLabel()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @objc func resume(_ sender: UIBarButtonItem) {
        resume()
    }
    
    @objc func back(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    private func showTableOfContents() {
        view.exchangeSubview(at: 0, withSubviewAt: 1)
        view.exchangeSubview(at: 0, withSubviewAt: 2)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "icon-back")!.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(back(_:)))
        let tableOfContentsToggleBarButton = UIBarButtonItem(customView: tableOfContentsToggleSegmentedControl)
        let resumeBarButton = UIBarButtonItem(title: NSLocalizedString("Resume", comment: ""), style: .plain, target: self, action: #selector(resume(_:)))
        navigationItem.leftBarButtonItems = [backButton, tableOfContentsToggleBarButton]
        navigationItem.rightBarButtonItems = [resumeBarButton]
        
        thumbnailView.alpha = 0
        
        toggleTableOfContentsView(tableOfContentsToggleSegmentedControl)
        
        barHideOnTapGestureRecognizer.isEnabled = false
    }
    
    @objc func toggleTableOfContentsView(_ sender: UISegmentedControl) {
        pdfView.isHidden = true
        pageNumberLabelContainer.alpha = 0
        
        if tableOfContentsToggleSegmentedControl.selectedSegmentIndex == 0 {
            thumbnailGridViewConainer.isHidden = false
            outlineViewConainer.isHidden = true
            bookmarkViewConainer.isHidden = true
        } else if tableOfContentsToggleSegmentedControl.selectedSegmentIndex == 1 {
            thumbnailGridViewConainer.isHidden = true
            outlineViewConainer.isHidden = false
            bookmarkViewConainer.isHidden = true
        } else {
            thumbnailGridViewConainer.isHidden = true
            outlineViewConainer.isHidden = true
            bookmarkViewConainer.isHidden = false
        }
    }
    
    @objc func showTableOfContents(_ sender: UIBarButtonItem) {
        showTableOfContents()
    }
    
    @objc func showAppearanceMenu(_ sender: UIBarButtonItem) {
        if let viewController = storyboard?.instantiateViewController(withIdentifier: String(describing: AppearanceViewController.self)) as? AppearanceViewController {
            viewController.modalPresentationStyle = .popover
            viewController.preferredContentSize = CGSize(width: 300, height: 44)
            viewController.popoverPresentationController?.barButtonItem = sender
            viewController.popoverPresentationController?.permittedArrowDirections = .up
            viewController.popoverPresentationController?.delegate = self
            present(viewController, animated: true, completion: nil)
        }
    }
    
    @objc func showSearchView(_ sender: UIBarButtonItem) {
        if let searchNavigationController = self.searchNavigationController {
            present(searchNavigationController, animated: true, completion: nil)
        } else if let navigationController = storyboard?.instantiateViewController(withIdentifier: String(describing: SearchViewController.self)) as? UINavigationController,
            let searchViewController = navigationController.topViewController as? SearchViewController {
            searchViewController.pdfDocument = document
            searchViewController.delegate = self
            present(navigationController, animated: true, completion: nil)
            
            searchNavigationController = navigationController
        }
    }
    
    @objc func addOrRemoveBookmark(_ sender: UIBarButtonItem) {
        if let documentURL = document?.documentURL?.absoluteString {
            var bookmarks = UserDefaults.standard.array(forKey: documentURL) as? [Int] ?? [Int]()
            if let currentPage = pdfView.currentPage,
                let pageIndex = document?.index(for: currentPage) {
                if let index = bookmarks.firstIndex(of: pageIndex) {
                    bookmarks.remove(at: index)
                    UserDefaults.standard.set(bookmarks, forKey: documentURL)
                    bookmarkButton.image = UIImage(named: "icon-bookmark-off")!.withRenderingMode(.alwaysOriginal)
                } else {
                    UserDefaults.standard.set((bookmarks + [pageIndex]).sorted(), forKey: documentURL)
                    bookmarkButton.image = UIImage(named: "icon-bookmark-on")!.withRenderingMode(.alwaysOriginal)
                }
            }
        }
    }

    private func notificationViewPage() {
        NotificationCenter.default.addObserver(self, selector: #selector(pdfViewPageChanged(_:)), name: .PDFViewPageChanged, object: nil)
    }
    
    private func setupPDFView() {
        view.addSubview(pdfView)
        pdfView.displayDirection = .horizontal
        pdfView.pageBreakMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true

        barHideOnTapGestureRecognizer.addTarget(self, action: #selector(gestureRecognizedToggleVisibility(_:)))
        view.addGestureRecognizer(barHideOnTapGestureRecognizer)
        
        pdfView.addGestureRecognizer(doubleTapGesture)
        
        pdfView.scrollView?.contentInsetAdjustmentBehavior = .scrollableAxes
        pdfView.getScaleFactorForSizeToFit()
        pdfView.setMinScaleFactorForSizeToFit()
        pdfView.setScaleFactorForUser()
    }
    
    private func setupThumbnailView() {
        thumbnailView.pdfView = pdfView
        thumbnailView.backgroundColor = UIColor(displayP3Red: 179/255, green: 179/255, blue: 179/255, alpha: 0.5)
        thumbnailView.layoutMode = .horizontal
        thumbnailView.thumbnailSize = CGSize(width: 40, height: 60)
        thumbnailView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        view.addSubview(thumbnailView)
    }
    
    @objc func pdfViewPageChanged(_ notification: Notification) {
        if pdfViewGestureRecognizer.isTracking {
            hideBars()
        }
//        updateBookmarkStatus()
        updatePageNumberLabel()
    }
    
    @objc func gestureRecognizedToggleVisibility(_ gestureRecognizer: UITapGestureRecognizer) {
        if let navigationController = navigationController {
            if navigationController.navigationBar.alpha > 0 {
                hideBars()
            } else {
                showBars()
            }
        }
    }
    
    private func updatePageNumberLabel() {
        if let currentPage = pdfView.currentPage, let index = document?.index(for: currentPage), let pageCount = document?.pageCount {
            pageNumberLabel.text = String(format: "%d/%d", index + 1, pageCount)
        } else {
            pageNumberLabel.text = nil
        }
    }
    
    private func showBars() {
        if let navigationController = navigationController {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                navigationController.navigationBar.alpha = 1
//                self.pdfThumbnailViewContainer.alpha = 1
                self.thumbnailView.alpha = 1
                self.pageNumberLabelContainer.alpha = 1
            }
        }
    }
    
    private func hideBars() {
        if let navigationController = navigationController {
            UIView.animate(withDuration: CATransaction.animationDuration()) {
                navigationController.navigationBar.alpha = 0
//                self.pdfThumbnailViewContainer.alpha = 0
                self.thumbnailView.alpha = 0
                self.pageNumberLabelContainer.alpha = 0
            }
        }
    }
    
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

//MARK: Interaction between Presenter and View
extension MidiaBookDisplayViewController: MidiaBookDisplayPresenterToViewProtocol {
    
}

class PDFViewGestureRecognizer: UIGestureRecognizer {
    var isTracking = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        isTracking = false
    }
}
