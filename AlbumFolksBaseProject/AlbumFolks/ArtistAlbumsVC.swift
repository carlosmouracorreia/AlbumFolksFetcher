//
//  AlbumsViewController.swift
//  AlbumFolks
//
//  Created by Carlos Correia on 02/02/18.
//  Copyright © 2018 carlosmouracorreia. All rights reserved.
//

import UIKit
import PopupDialog
import AlamofireImage

class ArtistAlbumsVC : UIViewController {
    
    @objc(ArtistAlbumsVC_UIPopulator) class UIPopulator : NSObject, UIEntryPointProtocol {
        func rootViewController() -> UIViewController {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ArtistAlbumsVC") as! ArtistAlbumsVC
            vc.artist = Artist(ArtistPopulator(name: "Mac DeMarco", mbid: "f2492c31-54a8-4347-a1fc-f81f72873bbf", photoUrl: URL(string: "https://lastfm-img2.akamaized.net/i/u/174s/d329b2d3ce7e47b1c77bbb54c2c0dbbb.png"), lastFmUrl: URL(string: "https://www.last.fm/music/Mac+DeMarco")))
            let navigationVc = UINavigationController(rootViewController: vc)
            
            return navigationVc
        }
    }
    
    static let MAX_ALBUMS_TO_SHOW = 12
    
    fileprivate var noFetchedAlbums = false
    fileprivate var seeMoreLinkFooterActivated = false
    fileprivate var selectedAlbumIndexPath : IndexPath?
    fileprivate let imageDownloader = ImageDownloader()
    
    fileprivate var artistCell : ArtistInfoHeaderCell?
    
    var passingDelegate : TrackChosenDelegate?
    
    var dismissToAlbumCallback : (() -> ())? {
        didSet {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Exit", style: .plain, target: self, action: #selector(dismissToAlbum))
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.register(UINib(nibName: AlbumCell.REUSE_ID, bundle: Bundle.main), forCellWithReuseIdentifier: AlbumCell.REUSE_ID)
            collectionView.register(UINib(nibName: ArtistInfoHeaderCell.REUSE_ID, bundle: Bundle.main), forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ArtistInfoHeaderCell.REUSE_ID)
            
        }
    }
    
    /**
     * I'm not super sure about this (artist attribution) being called imediately before (just in time) the view is loaded. Still, it's for me the best way to do a request before the view initializes. One could issue a notification from viewDidLoad and make the network callback wait until the notification is triggered. I have to test it with more time :-)
    **/
    var artist : Artist! {
        didSet {
            self.navigationItem.title = artist.name
            
            if artist.detail == nil {
                
                ArtistDetail.fetchNetworkData(artistId: self.artist.mbid, successCallback: { [weak self] artistDetail in
                    
                    guard let _self = self else {
                        return
                    }
                    
                    _self.artist.detail = artistDetail
                    _self.collectionView.reloadData()
                    _self.albumRequest(_self.artist)
                    
                    }, errorCallback: { [weak self] error in
                        
                        guard let _self = self else {
                            return
                        }
                        
                        let errorTitleDesc = CoreNetwork.messageFromError(error)
                        
                        AlertDialog.present(title: errorTitleDesc.title, message: errorTitleDesc.desc, vController: _self, action: { _ in
                            if _self.dismissToAlbumCallback != nil {
                                _self.dismissToAlbum(sender: _self.navigationItem.leftBarButtonItem!)
                            } else {
                                _self.navigationController!.popViewController(animated: true)
                            }
                        })
                        
                        
                })
                
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.accessibilityIdentifier = "ArtistAlbumsView"
        
        if #available(iOS 11.0, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
      

    }
    

    
    
    private func albumRequest(_ artist: Artist) {
      
        Album.fetchTopAlbums(artist: artist, successCallback: { [weak self] albums in
            
            guard let _self = self else {
                return
            }
            
            _self.artist.albums = Array(albums.prefix(ArtistAlbumsVC.MAX_ALBUMS_TO_SHOW))
            _self.seeMoreLinkFooterActivated = albums.count > ArtistAlbumsVC.MAX_ALBUMS_TO_SHOW && artist.lastFmUrl != nil
            _self.artist.requestedAlbumDetails = Dictionary<Album,Bool>()
            
            _self.collectionView.reloadData(completion: {
                _self.requestAlbumDetail()
                
                
                guard let albums = _self.artist.albums, albums.count > 0 else {
                    return
                }
                //request all non visible images
                let lastVisibleAlbumIndex = _self.collectionView.indexPathsForVisibleItems.last?.row ?? 0
                
                for i in lastVisibleAlbumIndex+1...albums.count-1 {
                    AlbumCell.fetchPhoto(albums[i], downloader: _self.imageDownloader, completion: {})
                }
                
            })
            
            
            }, errorCallback: { [weak self] error in
                
                defer {
                    self?.noFetchedAlbums = true
                    self?.collectionView.reloadData()
                }
                
                guard let _self = self else {
                    return
                }
                
                let errorTitleDesc = CoreNetwork.messageFromError(error)
                AlertDialog.present(title: errorTitleDesc.title, message: errorTitleDesc.desc, vController: _self, action: { _ in
                    
                    return
                    
                })
                
                
        })
        
    }
    
    
    /**
     * Would be easier/cleaner to have a hashmap/dictionary (to keep track of the album detail requests)
       instead of an array (manipulating keys instead of indexes) -
     - yet I thought first of adopting equatable protocol and it seems to flow right :-)
    **/
    private func requestAlbumDetail() {
        
        
        if let albums = artist.albums {
            
            let visibleAlbums = collectionView.indexPathsForVisibleItems
            
            for indexPath in visibleAlbums {
                let album = albums[indexPath.row]
                
                AlbumCell.fetchPhoto(album, downloader: self.imageDownloader, completion: {
                    self.collectionView.reloadItems(at: [indexPath])
                })
                
                if let index = self.artist.albums!.index(of: album), let _ = self.artist.albums![index].albumDetail {
                    //We're sure that upon this function call, we have requestAlbums initialized, and album object->references within the artist object
                    continue
                } else if self.artist.requestedAlbumDetails![album] == true {
                    continue
                }
                
                self.artist.requestedAlbumDetails![album] = true
                
                requestSingleAlbumDetail(indexPath: indexPath)

                
            }
            
        }
    }
    
    
    private func requestSingleAlbumDetail(indexPath: IndexPath) {
        if let albums = artist.albums {
            let album = albums[indexPath.row]
            
            AlbumDetail.fetchNetworkData(album: album, successCallback: { [weak self] albumDetail in
                album.albumDetail = albumDetail
                
                guard let _self = self else {
                    return
                }
                
                //If still visible items, we reload them
                if _self.collectionView.indexPathsForVisibleItems.contains(indexPath) {
                    _self.collectionView.reloadItems(at: [indexPath])
                }
                
                }, errorCallback: { error in
                    print("error fetching detail for album name: \(album.name!)")
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier ?? "" {
        case "presentAlbumFromArtist":
            let backItem = UIBarButtonItem()
            backItem.title = "Artist"
            navigationItem.backBarButtonItem = backItem
            
            let destination = segue.destination as! AlbumVC
            destination.trackChosenDelegate = self.passingDelegate
            let indexPath = collectionView.indexPathsForSelectedItems![0]
           
            if let _ = artist.albums![indexPath.row].albumDetail {
                destination.albumViewPopulator = AlbumViewPopulator(album: artist.albums![indexPath.row], image: artist.albums![indexPath.row].loadedImage)
            }
            
            self.selectedAlbumIndexPath = collectionView.indexPathsForSelectedItems![0]
            
        default:
            if let id = segue.identifier {
                print("Unknown segue: \(id)")
            }
        }
    }
    
    @objc func dismissToAlbum(sender : UIBarButtonItem) {
        if let callback = dismissToAlbumCallback {
            callback()
        }
        self.dismiss(animated: true, completion: nil)
    }
}



extension ArtistAlbumsVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCell.REUSE_ID, for: indexPath) as! AlbumCell

        
        guard let album = artist.albums?[indexPath.row] else {
            fatalError("Invalid application state while fetching albums.")
        }
        
       
            
        cell.hasDetail = album.albumDetail != nil
        album.hadDetail = album.albumDetail != nil
        
        
        cell.setContent(album)
        
        if let loadedImage = album.loadedImage {
            cell.setImageFrom(image: loadedImage, hadDetail: album.hadDetail)
        } else {
            cell.setNoMediaImage(hadDetail: album.hadDetail)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artist.albums?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionElementKindSectionHeader {
            
            
            if artistCell == nil {
                artistCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: ArtistInfoHeaderCell.REUSE_ID, for: indexPath) as? ArtistInfoHeaderCell
                
                artistCell!.setArtistInfoCallback(artistInfoCallback)
                artistCell!.setContent(artist)
            }
            

            if let detail = artist.detail {
                artistCell!.setDetailContent(detail)
            } else {
                artistCell!.setActivityIndicatorView()
            }
            
            return artistCell!
        } else {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "AlbumsGenericFooterCell", for: indexPath)
            
            for view in cell.subviews {
                view.removeFromSuperview()
            }
            
            
            /**
            * There's three possible situations for footer being shown. One is the loading process, second is not having albums (network error or simply no album info) and third is to see more albums on the LastFM Website
            **/
            
            if noFetchedAlbums || seeMoreLinkFooterActivated {
                
                let label = UILabel(frame: CGRect(x:0,y: 10,width: 250,height: 25))
                label.textAlignment = .center
                label.textColor = .black
                label.font = UIFont.systemFont(ofSize: 19.0, weight: UIFont.Weight.light)
                
                if seeMoreLinkFooterActivated {
                    
                    let tapFooterLink = UITapGestureRecognizer(target: self, action: #selector(openArtistPage))
                    cell.addGestureRecognizer(tapFooterLink)
                    
                    let text = "See more albums on Last FM"
                    let textRange = NSMakeRange(0, text.count)
                    let attributedText = NSMutableAttributedString(string: text)
                    attributedText.addAttribute(NSAttributedStringKey.underlineStyle , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
                    label.attributedText = attributedText
                    label.textColor = UIColor.blue
                    
                } else {
                    label.text = "No Fetched Albums"
                }
                
                cell.addSubview(label)
            
                
            } else {
                let loadingView = LoadingIndicatorView.create(centerX: cell.center.x, originY: 8, size: cell.frame.size.height * 0.8)
                cell.addSubview(loadingView)
            }
     
            return cell
        }
        
    }
    
}

extension ArtistAlbumsVC : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    // MARK : UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if let _ = artist.requestedAlbumDetails {
            requestAlbumDetail()
        }
        
    }
    
    // MARK : UICollectionViewDelegate
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // TODO _ Loading Screen if we don't have it yet. Show message if no info
        if artist.albums![indexPath.row].albumDetail != nil {
            self.performSegue(withIdentifier: "presentAlbumFromArtist", sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 265)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 80, height: artist.albums != nil && !seeMoreLinkFooterActivated ? 0 : 80)
    }
    
    
    // MARK : UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2.0
        let cellHeight = cellWidth * (20/15) // ratio as explicitly defined in the AlbumView Layout
        
        return CGSize(width: cellWidth - 8, height: cellHeight)
    }
}

extension ArtistAlbumsVC {
    // MARK : Supplementary methods to handle navigation
    
    
    /**
    Concerning the reusableCell LifeCycle and because it's easier to load things at once from a method invocation, I prefered to keep a callback reference on there (ArtistInfoHeaderCell) rather that having another reference to the ArtistDetail and another to this viewController
    **/
    func artistInfoCallback() {
        if let detail = artist.detail {
            let popup = PopupDialog(title: nil, message: detail.description.trim(to: 500))
            
            if let _ = artist.lastFmUrl {
                let buttonMore = DefaultButton(title: "See more on LastFm") {
                   self.openArtistPage()
                }
                
                popup.addButton(buttonMore)
            }
            
            let buttonDismiss = DefaultButton(title: "OK") {}
            popup.addButton(buttonDismiss)
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    // LastFMUrl will never be nil here.
    @objc func openArtistPage(_ sender: UIGestureRecognizer? = nil) {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(self.artist.lastFmUrl!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(self.artist.lastFmUrl!)
        }
    }
}

extension UICollectionView {
    func reloadData(completion: @escaping ()->()) {
        UIView.animate(withDuration: 0, animations: { self.reloadData() })
        { _ in completion() }
    }
}

