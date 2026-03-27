//
//  CommentInputViewController.swift
//  CodeLabApp
//
//  Created by Sera on 2023/7/18.
//

import Foundation
import BasicUIKit
import Combine
import APIKit

final class CommentInputViewController: UIViewController {
    
    enum InputStyle {
        case text
        case emoji
    }
    
    var feedItem: FeedItem?
    var commentItem: CommentItem?
    var toUser: UserInfo?
    var didSubmitHandler: ((CommentItem) -> Void)?
    
    private var isSubmit = false
    private var inputStyle: InputStyle = .text
    private var cancelables = Set<AnyCancellable>()
    private let contentView = UIView(frame: CGRect(x: 0, y: UIManager.shared.screenHeight, width: UIManager.shared.screenWidth, height: 52))
    private let textView = RSKPlaceholderTextView()
    
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
        view.addSubview(collectionView)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = color(0, 0, 0, 0.6)
        
        contentView.do {
            $0.backgroundColor = .white
            view.addSubview($0)
        }
        
        let emojiView = UIButton().then {
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.setImage(UIImage(named: "ge_icon_chat_emoji"), for: .normal)
            $0.addAction(UIAction() {[unowned self] _ in
                if inputStyle == .text {
                    inputStyle = .emoji
                    textView.resignFirstResponder()
                    emojiCollectionView.isHidden = false
                    emojiCollectionView.snp.remakeConstraints { make in
                        make.top.equalTo(contentView.snp.bottom)
                        make.left.right.bottom.equalToSuperview()
                    }
                }
                else {
                    textView.becomeFirstResponder()
                    inputStyle = .text
                }
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(10)
                make.width.height.equalTo(32)
                make.centerY.equalToSuperview()
            }
        }
        
        let sendBtn = UIButton().then {
            $0.setImage(UIImage(named: "lab_comment_input_send"), for: .normal)
            $0.hitTestEdgeInsets = UIEdgeInsets(top: -10, left: -10, bottom: -10, right: -10)
            $0.addAction(UIAction() {[unowned self] _ in
                if !textView.text.isEmpty {
                    guard !isSubmit else { return }
                    isSubmit = true
                    
                    HUD.show()
                    let para = ["feedId": (feedItem?.id).nonnull,
                                "content": textView.text.nonnull,
                                "toUid": (toUser?.userID).nonnull,
                                "toContent": (commentItem?.content).nonnull,
                                "toCommentId": (commentItem?.id).nonnull]
                    Network.request(FeedAPI.commentPublish, parameters: para).responseData { response in
                        HUD.hide()
                        if let error = response.error {
                            Toast.toast(title: error.localizedDescription)
                        } else if let data = response.data?.jsonData(), let commentItem = try? JSONDecoder().decode(CommentItem.self, from: data) {
                            commentItem.replyUser = self.toUser
                            Toast.toast(title: "评论成功")
                            self.didSubmitHandler?(commentItem)
                            self.dismiss()
                        }
                    }
                } else {
                    view.endEditing(true)
                }
            }, for: .touchUpInside)
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.width.height.equalTo(25)
                make.right.equalTo(-10)
                make.centerY.equalToSuperview()
            }
        }
        
        let backView = UIView().then {
            $0.backgroundColor = color(245, 245, 245)
            $0.layer.cornerRadius = 18
            contentView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(emojiView.snp.right).offset(10)
                make.right.equalTo(sendBtn.snp.left).offset(-15)
                make.height.equalTo(36)
                make.centerY.equalTo(emojiView)
            }
        }
        
        textView.do {
            $0.textContainerInset = .zero
            $0.backgroundColor = .clear
            $0.font = UIFont.regularPingFangSCFont(ofSize: 14)
            $0.textColor = .black
            $0.placeholder = NSString(string: toUser == nil ? "说点什么吧" : "回复 \((toUser?.userName).nonnull)")
            $0.placeholderColor = color(0, 0, 0, 0.4)
            $0.textAlignment = .left
            $0.keyboardType = .default
            backView.addSubview($0)
            $0.snp.makeConstraints { make in
                make.left.equalTo(16)
                make.height.equalTo(20)
                make.centerY.equalToSuperview()
                make.right.equalTo(-16)
            }
        }
        
        textView.becomeFirstResponder()
        
        NotificationCenter.default.publisher(for: UIApplication.keyboardWillChangeFrameNotification).sink {[weak self] notification in
            guard let strongSelf = self else { return }
            if strongSelf.textView.isFirstResponder,
               let keyboardFrame = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect,
                let duration = notification.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? Double {
                if keyboardFrame.origin.y >= UIManager.shared.screenHeight { //隐藏键盘
                    if strongSelf.inputStyle == .text {
                        UIView.animate(withDuration: duration) {
                            strongSelf.contentView.top = UIManager.shared.screenHeight
                        } completion: { _ in
                            strongSelf.dismiss(animated: false, completion: nil)
                        }
                    }
                } else {
                    strongSelf.inputStyle = .text
                    UIView.animate(withDuration: duration) {
                        strongSelf.contentView.bottom = keyboardFrame.minY
                    }
                }
            }
        }.store(in: &cancelables)
    }
    
    fileprivate func dismiss() {
        view.backgroundColor = .clear
        if inputStyle == .text {
            view.endEditing(true)
        } else {
            UIView.animate(withDuration: 0.25) {
                self.contentView.top = UIManager.shared.screenHeight
            } completion: { _ in
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.location(in: view).y < contentView.top {
            dismiss()
        }
    }
}

//MARK: - Emoji
extension CommentInputViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

class CommentsEmojiCollectionViewCell: UICollectionViewCell {
    lazy var textLabel = UILabel().then {
        $0.font = UIFont.regularPingFangSCFont(ofSize: 25)
        $0.textAlignment = .center
        contentView.addSubview($0)
        $0.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
}
