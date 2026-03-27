//
//  ChatPannelView.swift
//
//  Created by Sera on 2022/7/26.
//

import Foundation
import SnapKit
import UIKit
import BasicKit
import BasicUIKit
import AlbumUIKit

final class ChatPannelView: UIView {

    enum InputStyle {
        case text
        case emoji
    }

    static let pannelHeight: CGFloat = 52
    fileprivate var inputStyle: InputStyle = .text
    fileprivate var hasSubmit = false
    
    static let pannelMarginBottom: CGFloat = UIManager.shared.isNotchScreen ? 34 : 0
    
    let inputBar = UIView()
    let textView = RSKPlaceholderTextView()
    
    // send handler
    var didSubmitTextHandler: ((String) -> Void)?
    var didKeyboardChangeFrameHandler: PureCompletionHandler?
    var didSubmitAssetsHandler: (([PHAsset]) -> Void)?

    fileprivate lazy var emojisList: [String] = {
        var emojisList = [String]()
        let emojiPath = Bundle.main.path(forResource: "CommentsEmoji", ofType: "json")
        do {
            let data = try Data.init(contentsOf: URL(fileURLWithPath: emojiPath.nonnull), options: .mappedIfSafe)
            let list = try JSONDecoder().decode([String].self, from: data)
            emojisList.append(contentsOf: list)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return emojisList
    }()
    
    fileprivate lazy var emojiCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let margin = floor(UIManager.shared.screenWidth - 7*30 - 15*2)/6.0
        flowLayout.minimumLineSpacing = margin
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.itemSize = CGSize(width: 30, height: 30)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 15, bottom: UIManager.shared.isNotchScreen ? 45 : 15, right: 15)
        collectionView.register(cellWithClass: CommentsEmojiCollectionViewCell.self)
        addSubview(collectionView)
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotificationKeyboardFrameChange(notification:)), name: UIApplication.keyboardWillChangeFrameNotification, object: nil)
        
        inputBar.do {
            $0.backgroundColor = .white
            addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.height.equalTo(ChatPannelView.pannelHeight)
                make.bottom.equalTo(-ChatPannelView.pannelMarginBottom)
            }
        }
        
        let emojiBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_chat_emoji"), for: .normal)
            $0.contentMode = .scaleAspectFit
            $0.addAction(UIAction() {[unowned self] _ in
                if inputStyle == .text {
                    inputStyle = .emoji
                    
                    if textView.isFirstResponder {
                        textView.resignFirstResponder()
                        
                        emojiCollectionView.isHidden = false
                        emojiCollectionView.snp.remakeConstraints { make in
                            make.top.equalTo(inputBar.snp.bottom)
                            make.left.right.bottom.equalToSuperview()
                        }
                    } else {
                        inputBar.snp.updateConstraints { make in
                            make.bottom.equalTo(-360)
                        }
                        
                        UIView.animate(withDuration: 0.25) {
                            self.inputBar.superview?.layoutIfNeeded()
                        } completion: { _ in
                            self.emojiCollectionView.isHidden = false
                            self.emojiCollectionView.snp.remakeConstraints { make in
                                make.top.equalTo(self.inputBar.snp.bottom)
                                make.left.right.bottom.equalToSuperview()
                            }
                            
                            self.didKeyboardChangeFrameHandler?()
                        }
                    }
                } else {
                    textView.becomeFirstResponder()
                    inputStyle = .text
                }
            }, for: .touchUpInside)
            inputBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.left.equalTo(14)
                make.centerY.equalToSuperview()
            }
        }
        
        let photoBtn = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_chat_photo"), for: .normal)
            $0.addTarget(self, action: #selector(imageBtnTapHandler), for: .touchUpInside)
            inputBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(24)
                make.left.equalTo(emojiBtn.snp.right).offset(16)
                make.centerY.equalTo(emojiBtn)
            }
        }

        let inputBackView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 18
            inputBar.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(photoBtn.snp.right).offset(6)
                make.right.equalTo(-16)
                make.height.equalTo(36)
                make.centerY.equalTo(photoBtn)
            }
        }
        
        let sendBtn = UIButton().then {
            $0.backgroundColor = .black
            $0.layer.cornerRadius = 14.0
            $0.setTitle("发送", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = .regularPingFangSCFont(ofSize: 12)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.addTarget(self, action: #selector(sendBtnTapHandler), for: .touchUpInside)
            inputBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.equalTo(56)
                make.height.equalTo(28)
                make.right.equalTo(-4)
                make.centerY.equalToSuperview()
            }
        }
        
        textView.do {
            $0.textContainerInset = .zero
            $0.backgroundColor = .clear
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.placeholder = "说点什么吧..."
            $0.placeholderColor = color(0, 0, 0, 0.4)
            $0.textAlignment = .left
            $0.keyboardType = .default
            inputBackView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.height.equalTo(20)
                make.centerY.equalToSuperview()
                make.right.equalTo(sendBtn.snp.left).offset(-16)
            }
        }
        
        layoutIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        dPrint("IM输入框释放")
    }
    
    //点击事件穿透
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        if view == self {
            return nil
        }

        if view == inputBar {
            return textView
        }

        return super.hitTest(point, with: event)
    }
    
    
    @objc fileprivate func handleNotificationKeyboardFrameChange(notification: NSNotification) {
        if textView.isFirstResponder {
            if inputStyle == .text,
               let keyboardFrame = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect,
               let duration = notification.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? Double
            {
                if keyboardFrame.origin.y >= UIManager.shared.screenHeight { //隐藏键盘
                    scrollToBottom(duration: duration)
                }
                else {
                    inputBar.snp.updateConstraints { make in
                        make.bottom.equalTo(keyboardFrame.minY - UIManager.shared.screenHeight)
                    }
                    
                    UIView.animate(withDuration: duration) {
                        self.inputBar.superview?.layoutIfNeeded()
                    } completion: { _ in
                        self.didKeyboardChangeFrameHandler?()
                    }
                }
            }
        } else {
            inputStyle = .text
            emojiCollectionView.isHidden = true
        }
    }
    
    fileprivate func scrollToBottom(duration: TimeInterval = 0.25) {
        inputBar.snp.updateConstraints { make in
            make.bottom.equalTo(-ChatPannelView.pannelMarginBottom)
        }
        
        UIView.animate(withDuration: duration) {
            self.superview?.layoutIfNeeded()
        } completion: { _ in
            self.emojiCollectionView.isHidden = true
        }
    }
    
    func resetPannelToInitilize() {
        inputStyle = .text

        if textView.isFirstResponder {
            textView.resignFirstResponder()
        } else {
            scrollToBottom()
        }
    }
    
    @objc fileprivate func imageBtnTapHandler() {
        resetPannelToInitilize()
        
        let assetsVC = AssetsListViewController()
        assetsVC.maxSelectCount = 3
        assetsVC.minSelectCount = 1
        assetsVC.type = .photo
        assetsVC.didSubmitHandler = {[unowned self, unowned assetsVC] assets in
            didSubmitAssetsHandler?(assets)
            assetsVC.dismiss(animated: true)
        }
        UIManager.present(modal: assetsVC)
    }
}

//MARK: - Emoji
extension ChatPannelView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return emojisList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withClass: CommentsEmojiCollectionViewCell.self, for: indexPath)
        cell.textLabel.text = emojisList[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textView.insertText(emojisList[indexPath.item])
    }
}

extension ChatPannelView: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            sendBtnTapHandler()
            return false
        }

        return true
    }
    
    @objc fileprivate func sendBtnTapHandler() {
        guard textView.text.isNotEmpty else {
            return
        }
        
        didSubmitTextHandler?(textView.text)
        textView.text = ""
    }
}
