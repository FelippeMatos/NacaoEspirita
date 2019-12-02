//
//  MidiaInteractor.swift
//  NacaoEspirita
//
//  Created by Felippe Matos Francoski on 11/7/19.
//  Copyright © 2019 Felippe Matos Francoski. All rights reserved.
//

import Foundation
import Firebase
import Alamofire

class MidiaInteractor: MidiaPresenterToInteractorProtocol {
    
    var presenter: MidiaInteractorToPresenterProtocol?
    var bookArrayList = [BookModel]()
    var videoArrayList = [VideoModel]()
    let db = Firestore.firestore()
    var ref: DocumentReference? = nil
    
    let dateUtils = DateUtils()
    var currentDateString: String?

    //MARK: BOOKS
    func fetchBooks() {
      
        guard let id = Auth.auth().currentUser?.uid, !id.isEmpty else {
            return
        }
        
        var bookArray = [BookModel]()
        
        db.collection("books").order(by: "name", descending: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchBooks : ERROR = \(err)")
                self.presenter?.booksFetchFailed()
            } else {
                for document in querySnapshot!.documents {
                    bookArray.append(BookModel(document: document)!)
                }
                self.bookArrayList = bookArray
                self.presenter?.booksFetchedSuccess(bookModelArray: self.bookArrayList)
            }
        }
    }
    
    //MARK: VIDEOS
    func checkStatusVideos() {
        let currentHour = dateUtils.currentHour()
        
        /* TABELA DE HORARIOS PARA ATUALIZAR:
         // 15 vezes ao dia: (GMT - 3 horas para estar de acordo com o Brasil)
         // BR  GMT     - STATUS
         // 1   (4)     - X
         // 2   (5)     - X
         // 3   (6)     - X
         // 4   (7)     - X
         // 5   (8)     - X
         // 6   (9)     - 1
         // 7   (10)    - X
         // 8   (11)    - 1
         // 9   (12)    - 1
         // 10  (13)    - X
         // 11  (14)    - X
         // 12  (15)    - 1
         // 13  (16)    - 1
         // 14  (17)    - X
         // 15  (18)    - 1
         // 16  (19)    - X
         // 17  (20)    - 1
         // 18  (21)    - 1
         // 19  (22)    - 1
         // 20  (23)    - X
         // 21  (00)    - 1
         // 22  (1)     - 1
         // 23  (2)     - X
         // 00  (3)     - 1
        */

        switch currentHour {
        case 0, 1, 3, 9, 11, 12, 15, 16, 18, 20, 21, 22:
            compareLastUpdateDateWithCurrentDate()
            debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/checkStatusVideos : STATUS = DENTRO DA HORA DE ATUALIZAR OS VIDEOS")
        default:
            debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/checkStatusVideos : STATUS = FORA DA HORA DE ATUALIZAR OS VIDEOS")
            self.fetchVideosInFirebase()
        }
    }
    
    func compareLastUpdateDateWithCurrentDate() {
        
        currentDateString = dateUtils.currentDateString()
        let currentDate = dateUtils.stringToDate(currentDateString!)
        
        db.collection("videosLastUpdate").document("01").getDocument() { (querySnapshot, err) in
            if let err = err {
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/compareLastUpdateDateWithCurrentDate : ERROR = \(err)")
            } else {
                if querySnapshot!.exists {
                    let data = querySnapshot!.data()
                    let lastUpdate = data!["lastUpdate"] as? String
                    let lastUpdateDate = self.dateUtils.stringToDate(lastUpdate!)
                    
                    if currentDate <= lastUpdateDate {
                        debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/compareLastUpdateDateWithCurrentDate : STATUS = ATUALIZAR PELO FIREBASE")
                        self.fetchVideosInFirebase()
                    } else {
                        debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/compareLastUpdateDateWithCurrentDate : STATUS = ATUALIZAR PELA API DO YOUTUBE")
                        self.fetchVideosInYoutube()
                    }
                } else {
                    debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/compareLastUpdateDateWithCurrentDate : ERROR = VERIFICAR OBJETO NO FIREBASE")
                }
            }
        }
    }
    
    func fetchVideosInFirebase() {
        
        var videoArray = [VideoModel]()

        db.collection("videos").order(by: "publishedAt", descending: true).limit(to: 5).getDocuments() { (querySnapshot, err) in
            if let err = err {
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchVideosInFirebase : ERROR = \(err)")
                self.presenter?.videosFetchFailed()
            } else {
                for document in querySnapshot!.documents {
                    videoArray.append(VideoModel(document: document)!)
                }
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchVideosInFirebase : STATUS = VIDEOS RESGATADOS DO FB")
                self.videoArrayList = videoArray
                self.presenter?.videosFetchedSuccess(videoModelArray: self.videoArrayList)
            }
        }
    }
    
    func fetchVideosInYoutube() {
        var videoArray = [VideoModel]()
        var count = [Int]()
        for channel in AppKeys.YOUTUBE_CHANNEL_KEYS {
            let youtubeQuery = "https://www.googleapis.com/youtube/v3/search?key=\(AppKeys.YOUTUBE_API_KEY)&channelId=\(channel)&part=snippet,id&order=date&maxResults=5"
            AF.request(youtubeQuery).responseJSON { response in
                if let data = response.data {
                    do {
                        let videoParser = try JSONDecoder().decode(VideoParser.self, from: data)
                        for video in videoParser.items {
                            if video.snippet?.liveBroadcastContent == "none" {
                                videoArray.append(VideoModel(videoParser: video)!)
                            }
                        }
                        count.append(0)
                        if count.count == AppKeys.YOUTUBE_CHANNEL_KEYS.count {
                            self.saveVideosInFirebase(videoArrayList: videoArray)
                            debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchVideosInYoutube : STATUS = VIDEOS PARSEADOS")
                        }
                    } catch let err {
                        debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchVideosInYoutube : ERROR = \(err)")
                        self.fetchVideosInFirebase()
                    }
                }
            }
        }
    }
    
    func saveVideosInFirebase(videoArrayList: [VideoModel]) {

        var count = [Int]()
        for video in videoArrayList {
            db.collection("videos").document(video.id!).setData([
                "channelId": video.channelId!,
                "channelTitle": video.channelTitle!,
                "description": video.description!,
                "publishedAt": video.publishedAt!,
                "thumbnailHigh": video.thumbnailHigh!,
                "thumbnailMedium": video.thumbnailMedium!,
                "title": video.title!
            ]) { err in
                if let err = err {
                    debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/saveVideosInFirebase : ERROR = \(err)")
                } else {
                    count.append(0)
                    if count.count == videoArrayList.count {
                        self.fetchDurationVideos(videoArrayList: videoArrayList)
                        self.updateStatusVideos()
                        self.fetchVideosInFirebase()
                        debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/saveVideosInFirebase : STATUS = VIDEOS SALVOS NO FIREBASE")
                    }
                }
            }
        }
    }
    
    func updateStatusVideos() {
        let updateRef = db.collection("videosLastUpdate").document("01")
        
        updateRef.updateData([
            "lastUpdate": self.currentDateString!
        ]) { err in
            if let err = err {
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/updateStatusVideos : ERROR = \(err)")
            } else {
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/updateStatusVideos : STATUS = ATUALIZADO")
            }
        }
    }
    
    func fetchDurationVideos(videoArrayList: [VideoModel]) {
        var videoArray = [VideoModel]()
        var count = [Int]()
        for video in videoArrayList {
            let youtubeQuery = "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=\(video.id!)&key=\(AppKeys.YOUTUBE_API_KEY)"
            AF.request(youtubeQuery).responseJSON { response in
                if let data = response.data {
                    do {
                        let videoParser = try JSONDecoder().decode(VideoParserDuration.self, from: data)
                        for video in videoParser.items {
                            videoArray.append(VideoModel(videoParserDuration: video)!)
                        }
                        count.append(0)
                        if count.count == videoArrayList.count {
                            self.updateVideosInFirebase(videoArrayList: videoArray)
                            debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchDurationVideos : STATUS = DURACAO PARSEADA")
                        }
                    } catch let err {
                        debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchDurationVideos : ERROR = \(err)")
                    }
                }
            }
        }
    }
    
    func updateVideosInFirebase(videoArrayList: [VideoModel]) {
        for video in videoArrayList {
            let updateRef = db.collection("videos").document(video.id!)
            
            updateRef.updateData([
                "duration": video.duration!
            ]) { err in
                if let err = err {
                    debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/updateVideosInFirebase : ERROR = \(err)")
                } else {
                    debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/updateVideosInFirebase : STATUS = ATUALIZADO")
                }
            }
        }
    }
    
    //MARK: Funcao de apoio a cadastro de informacoes
    /*
    func TEMPinsertDurationInAllVideos() {
        var videoArray = [VideoModel]()
        
        db.collection("videos").order(by: "publishedAt", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchVideosInFirebase : ERROR = \(err)")
                self.presenter?.videosFetchFailed()
            } else {
                print("$$$$$$$$$$ NUMERO DE VIDEOS: \(querySnapshot!.documents.count)")
                for document in querySnapshot!.documents {
                    videoArray.append(VideoModel(document: document)!)
                }
                debugPrint("======>> DEBUG INFORMATION: MidiaInteractor/fetchVideosInFirebase : STATUS = VIDEOS RESGATADOS DO FB")
                self.fetchDurationVideos(videoArrayList: videoArray)
            }
        }
    }
    */
}
