//
//  HomeViewController.swift
//  LivestreamFails
//
//  Created by Scor Doan on 5/14/19.
//  Copyright © 2019 Scor Doan. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import RxSwift
import RxCocoa

class HomeViewController: BaseViewController, UIViewControllerConfigurable {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    let viewModel = HomeVideosViewModel()
    
    //MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupComponents()
        bindViewModel()
        getVideos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //Refresh control
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .subscribe(onNext: { _ in
                self.fetchFirstPage()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        if let currentCell = tableView.visibleCells.first as? HomeVideoTableViewCell {
            currentCell.play()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentCell = tableView.visibleCells.first as? HomeVideoTableViewCell {
            currentCell.pause()
        }
    }
    
    //MARK: -
    func setupComponents() {
        //CollectionView
        collectionView.register(R.nib.storyCollectionViewCell)
        let stories = [Story(username: "Feed", avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRxfXSnqYim1H9d4fZLrltirKtQJ45MsHxqICOLZhhmRwuIlRCKmg"),
                        Story(username: "Contest", avatar: "https://thumbs.dreamstime.com/z/cartoon-monster-face-vector-halloween-green-tired-cool-monster-avatar-great-print-97162970.jpg"),
                        Story(username: "Ninja", avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRi7FNgSVC2okWs910NZloOsw8tcMbq_bAjn0dtPgccj5sZomCbow"),
                        Story(username: "David", avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTKSBpx74RmQFv3bD59In2AKhxdkN95S3cy3SF8x44sYlfEl2PIJg"),
                        Story(username: "pokimane", avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSQTvO1vI-BtVqHAG_Ccpfjob8bVc8xiVuKOcjiF1Jh1sh0TCjd"),
                        Story(username: "DrLupo", avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRp3k7abEQyWIEb7t6QN0ZHvy4hvA9pc-PNtC9jMWrgHFUBKpUi"),
                        Story(username: "King", avatar: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTg6ZqSDwUEaSOpe5DKE80mom1uxLUCeHwLL-aNP8RhYKHKwRjPAA")]
        Observable.just(stories).asDriverOnErrorJustComplete().drive(self.collectionView.rx.items) { (collectionView, row, element) in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.storyCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
            cell.configure(item: element)
            return cell
        }.disposed(by: disposeBag)
        
        //TableView
        tableView.register(R.nib.homeVideoTableViewCell)
        tableView.dataSource = nil
        tableView.delegate = self
        
        tableView.rx.willDisplayCell
            .subscribe(onNext: { [weak self] cellInfo in
                guard let `self` = self else { return }
                let (cell, indexPath) = cellInfo
                if let videoCell = cell as? HomeVideoTableViewCell {
                    videoCell.play()
                }
                
                if self.viewModel.canLoadMore(with: indexPath) {
                    let spinner = UIActivityIndicatorView(style: .gray)
                    spinner.startAnimating()
                    spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(44))
                    
                    self.tableView.tableFooterView = spinner
                    self.tableView.tableFooterView?.isHidden = false
                    self.fetchNextPage()
                } else {
                    let label = UILabel(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: self.tableView.bounds.width, height: CGFloat(44)))
                    label.text = "You’re all caught up!"
                    label.textAlignment = .center
                    label.textColor = UIColor.white
                    label.font = UIFont.LSFonts.regS11
                    self.tableView.tableFooterView = label
                    self.tableView.tableFooterView?.isHidden = false
                }
            })
            .disposed(by: disposeBag)
        
        tableView.rx.didEndDisplayingCell.subscribe(onNext: { cellInfo in
            let (cell, _) = cellInfo
            guard let videoCell = cell as? HomeVideoTableViewCell else { return }
            videoCell.stop()
            
        }).disposed(by: disposeBag)
    }
    
    func bindViewModel() {
        let videosTrigger = rx.sentMessage(#selector(getVideos))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let input = HomeVideosViewModel.Input(loadVideosTrigger: videosTrigger)
        let output = viewModel.transform(input: input)
        
        //Update tableview
        output.dataSource.drive(tableView.rx.items) { tableView, row, item in
            let indexPath = IndexPath(row: row, section: 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.homeVideoTableViewCell, for: indexPath) as HomeVideoTableViewCell?
            cell?.selectionStyle = .none
            cell?.configure(item: item)
            return cell!
            }.disposed(by: disposeBag)
        
        //API error
        output.error.drive(onNext: { (error) in
            UIAlertController.presentOKAlertWithTitle(LSFailsError.ERROR_TITLE, message: error.localizedDescription)
        }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        //Loading
        output.loading.drive(onNext: {[weak self] (loading) in
            if !loading {
                SVProgressHUD.dismiss()
                self?.tableView.refreshControl?.endRefreshing()
            }
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
    
    func updateUI() {
        
    }
    
    func fetchFirstPage() {
        viewModel.reset()
        getVideos()
    }
    
    private func fetchNextPage() {
        self.getVideos()
    }
    
    @objc dynamic func getVideos() {
        if let refreshControl = tableView.refreshControl {
            refreshControl.beginRefreshing()
        } else {
            SVProgressHUD.show()
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let size = tableView.bounds.size
        return size.height
    }
}
