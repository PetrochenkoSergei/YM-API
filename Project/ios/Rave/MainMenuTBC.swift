//
//  MainMenuTBC.swift
//  Rave
//
//  Created by Developer on 10.08.2021.
//

import UIKit
import YmuzApi

class MainMenuTBC: UITabBarController {
    
    var playerWidget: PlayerWidgetView!

    override func viewDidLoad() {
        super.viewDidLoad()
            
        client.getLikedTracks(modifiedRevision: nil) { result in
            do {
                appService.likedLibrary = try result.get()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
        
        client.getDislikedTracks(modifiedRevision: nil) { result in
            do {
                appService.dislikedLibrary = try result.get()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
        }
        localeUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let playerHeight: CGFloat = 64
        let frame = CGRect(x: 0, y: self.tabBar.frame.minY - playerHeight, width: self.view.bounds.width, height: playerHeight)
        playerWidget = PlayerWidgetView(frame: frame)
        playerWidget.setData(coverImg: UIImage(named: "ic_track_template"), trackName: AppService.localizedString(.player_not_playing), artist: "")
        playerQueue.setPlayerWidgetDelegateHandler(self)
        let tapRec = UITapGestureRecognizer(target: self, action: #selector(playerWidgetTap))
        let scroller = UIPanGestureRecognizer(target: self, action: #selector(playerWidgetUpGesture(with:)))
        scroller.cancelsTouchesInView = false
        scroller.delaysTouchesBegan = false
        scroller.delaysTouchesEnded = false
        view.addGestureRecognizer(scroller)
        playerWidget.addGestureRecognizer(tapRec)
        self.view.addSubview(playerWidget)
        let subs = self.view.subviews
        for i in 0 ... subs.count - 1 {
            let sub = subs[i]
            if !(sub is UITabBar) && !(sub is PlayerWidgetView) {
                sub.translatesAutoresizingMaskIntoConstraints = false
                sub.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
                sub.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
                sub.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
                sub.bottomAnchor.constraint(equalTo: playerWidget.bottomAnchor, constant: -16).isActive = true
                break
            }
        }
    }
    
    @objc fileprivate func playerWidgetUpGesture(with scroller: UIPanGestureRecognizer) {
        let transitionPoint = scroller.translation(in: view)
        let abs_x = abs(transitionPoint.x)
        let abs_y = abs(transitionPoint.y)
        if (abs_y > abs_x)
        {
            //horizontal scroll prevent
            if (transitionPoint.y < -50 && playerQueue.tracks.count > 0)
            {
                let vc = UIStoryboard(name: "Content", bundle: nil).instantiateViewController(withIdentifier: AudioPlayerVC.className) as! AudioPlayerVC
                self.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    @objc fileprivate func playerWidgetTap() {
        let oldColor = playerWidget.contentView.backgroundColor
        playerWidget.contentView.backgroundColor = UIColor.lightGray
        UIView.animate(withDuration: 0.5, animations: {
            self.playerWidget.contentView.layer.backgroundColor = oldColor?.cgColor
        }) {
            (finished) in
            if (finished) {
                self.playerWidget.contentView.backgroundColor = oldColor
            }
        }
        if (playerQueue.tracks.count > 0) {
            let vc = UIStoryboard(name: "Content", bundle: nil).instantiateViewController(withIdentifier: AudioPlayerVC.className) as! AudioPlayerVC
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    fileprivate func localeUI()
    {
        if let viewControllers = self.viewControllers
        {
            if (viewControllers.count < 4)
            {
                return
            }
            viewControllers[0].tabBarItem.title = AppService.localizedString(.landing_title)
            viewControllers[1].tabBarItem.title = AppService.localizedString(.radio_title)
            viewControllers[2].tabBarItem.title = AppService.localizedString(.favourite_title)
            viewControllers[3].tabBarItem.title = AppService.localizedString(.search_title)
        }
    }
}

extension MainMenuTBC: PlayerQueueDelegate {
    func trackChanged(_ track: Track, queueIndex: Int) {
        DispatchQueue.main.async {
            self.playerWidget.setData(coverImg: UIImage(named: "ic_track_template"), trackName: track.trackTitle, artist: track.artistsName.joined(separator: ","))
        }
    }
    
    func playStateChanged(playing: Bool) {
        DispatchQueue.main.async {
            self.playerWidget.btn_playPause.isSelected = playing
        }
    }
    
    func playbackPositionChanged(_ position: TimeInterval) {}
}
