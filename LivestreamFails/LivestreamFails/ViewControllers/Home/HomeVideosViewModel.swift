//
//  HomeVideosViewModel.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/20/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

//MARK: AirportSchedulesViewModel
final class HomeVideosViewModel: ViewModelType {

    private var paginationInfo = PaginationInfo()
    private var videos = [VideoPost]()
    private var reachedBottom = false

    func transform(input: Input) -> Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let getVideos = input.loadVideosTrigger
            .flatMapLatest { _ -> SharedSequence<DriverSharingStrategy, [VideoPost]> in
                return self.loadVideos()
                    .trackActivity(activityIndicator)
                    .trackError(errorTracker)
                    .asDriverOnErrorJustComplete()
            }.flatMap { (videos) -> SharedSequence<DriverSharingStrategy, [VideoPost]> in
                self.reachedBottom = videos.isEmpty
                self.videos.append(contentsOf: videos)
                return Observable.just(self.videos)
                    .asDriverOnErrorJustComplete()
        }
        
        
        return Output(dataSource: getVideos,
                      error: errorTracker.asDriver(),
                      loading: activityIndicator.asDriver())
    }
    
    func reset() {
        videos = []
        paginationInfo = PaginationInfo()
        reachedBottom = false
    }
    
    func video(at index: Int) -> VideoPost {
        return videos[index]
    }
    
    func canLoadMore(with indexPath: IndexPath) -> Bool {
        guard indexPath.row == videos.count - 1 else { return false }
        
        return true
    }
    
    private func loadVideos() -> Observable<[VideoPost]> {
        return Observable.create({ observer -> Disposable in
            liveStreamFailsAPI.request(.loadPosts(self.paginationInfo)) { (result) in
                do {
                    let response = try result.get()
                    let posts = try response.mapPosts()
                    self.paginationInfo.page += 1
                    observer.onNext(posts)
                    observer.onCompleted()
                } catch let error {
                    //error
                    observer.onError(LSFailsError.Unknown)
                    
                }
            }
            return Disposables.create()
        })
    }
}

extension HomeVideosViewModel {
    struct Input {
        let loadVideosTrigger: Driver<Void>
    }
    
    struct Output {
        let dataSource: Driver<[VideoPost]>
        let error: Driver<Error>
        let loading:Driver<Bool>
    }
}
