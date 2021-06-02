
import UIKit
import BFKit
import SwiftBasicKit

class ZUserPhotoEditViewController: ZZBaseViewController {
    
    private var dragingIndexPath: IndexPath?
    private lazy var z_viewmain: ZBaseCV = {
        let z_templayout = UICollectionViewFlowLayout.init()
        z_templayout.itemSize = CGSize.init(width: kScreenWidth/2, height: 250.scale)
        z_templayout.scrollDirection = .vertical
        z_templayout.minimumLineSpacing = 0
        z_templayout.minimumInteritemSpacing = 0
        z_templayout.sectionFootersPinToVisibleBounds = true
        
        let z_temp = ZBaseCV.init(frame: CGRect.mainRemoveTop(), collectionViewLayout: z_templayout)
        z_temp.addRefreshHeader()
        z_temp.showsVerticalScrollIndicator = false
        z_temp.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            z_temp.dragInteractionEnabled = true
        } else {
            
        }
        z_temp.register(ZUserPhotoEditCVC.classForCoder(), forCellWithReuseIdentifier: kCellId)
        z_temp.register(ZUserPhotoEditAddView.classForCoder(), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kCellFooterId)
        return z_temp
    }()
    private let z_viewmodel: ZUserEditViewModel = ZUserEditViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        z_viewmodel.vc = self
        self.title = ZString.lbEditProfilePhotos.text
        self.view.addSubview(z_viewmain)
        
        z_viewmodel.delegate = self
        z_viewmain.delegate = self
        z_viewmain.dataSource = self
        if #available(iOS 11.0, *) {
            z_viewmain.dragDelegate = self
            z_viewmain.dropDelegate = self
        } else {
            
        }
        z_viewmodel.func_requestuserphotos()
        z_viewmain.onRefreshHeader = {
            self.z_viewmodel.func_requestuserphotos(loadlocal: false)
        }
    }
    deinit {
        z_viewmodel.delegate = nil
        z_viewmain.delegate = nil
        z_viewmain.dataSource = nil
        if #available(iOS 11.0, *) {
            z_viewmain.dragDelegate = nil
            z_viewmain.dropDelegate = nil
        } else {
            
        }
    }
    override func btnNavBarLeftButtonEvent() {
        if self.z_viewmodel.z_changeduser {
            self.view.endEditing(true)
            ZAlertView.showAlertView(vc: self, message: ZString.alertPleasesavethechangephotos.text, button: ZString.btnSave.text, completeBlock: { tag in
                if tag == 1 {
                    self.z_viewmodel.func_changeuserphotos()
                } else {
                    ZRouterKit.pop(fromVC: self)
                }
            })
            return
        }
        ZRouterKit.pop(fromVC: self)
    }
    private func func_showcamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let z_tempvc = ZImageSelectViewController()
            
            z_tempvc.delegate = self
            z_tempvc.allowsEditing = true
            z_tempvc.modalPresentationStyle = .fullScreen
            z_tempvc.sourceType = UIImagePickerController.SourceType.camera
            
            ZRouterKit.present(toVC: z_tempvc, fromVC: self, animated: true, completion: nil)
        } else {
            ZProgressHUD.showMessage(vc: self, text: ZString.errorDeviceNotCameraPrompt.text)
        }
    }
    private func func_showalbum() {
        let z_tempvc = ZImageSelectViewController()
        
        z_tempvc.delegate = self
        z_tempvc.allowsEditing = true
        z_tempvc.modalPresentationStyle = .fullScreen
        z_tempvc.sourceType = UIImagePickerController.SourceType.photoLibrary
        
        ZRouterKit.present(toVC: z_tempvc, fromVC: self, animated: true, completion: nil)
    }
    private func func_showactionsheetview() {
        ZAlertView.showActionSheetView(vc: self, message: ZString.lbSelectPhoto.text, buttons: [ZString.btnAlbum.text, ZString.btnCamera.text], completeBlock: { row in
            switch row {
            case 0: self.func_showalbum()
            case 1: self.func_showcamera()
            default: break
            }
        })
    }
}
extension ZUserPhotoEditViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: kScreenWidth, height: 90.scale)
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: kCellFooterId, for: indexPath) as! ZUserPhotoEditAddView
        view.z_onbtnaddphotoclick = {
            if self.z_viewmodel.z_photos.count >= kMaxPhotos {
                ZAlertView.showAlertView(vc: self, message: ZString.alertUploadphotossmaxcount.text)
            } else {
                self.func_showactionsheetview()
            }
        }
        return view
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.z_viewmodel.z_photos.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellId, for: indexPath) as! ZUserPhotoEditCVC
        cell.tag = indexPath.row
        cell.z_imageavatarpath = self.z_viewmodel.z_photos[indexPath.row]
        cell.z_onbuttonevent = { opt, tag in
            switch opt {
            case .delete:
                if self.z_viewmodel.z_photos.count > 1 {
                    ZAlertView.showAlertView(vc: self, message: ZString.alertAreyousuredeletecurrentselectedphoto.text, completeBlock: { row in
                        if row == 1 {
                            self.z_viewmodel.func_deleteuserphotos(row: tag)
                        }
                    })
                } else {
                    ZAlertView.showAlertView(vc: self, message: ZString.alertDeleteuserphotosoneleast.text)
                }
            case .cover:
                if tag > 0 {
                    ZAlertView.showActionSheetView(vc: self, message: ZString.lbAvatar.text, buttons: [ZString.lbSetavatar.text, ZString.lbMoveUp.text, ZString.lbMoveDown.text], completeBlock: { row in
                        switch row {
                        case 0: self.z_viewmodel.func_changephototohead(row: tag)
                        case 1: self.z_viewmodel.func_changephotomoveup(row: tag)
                        case 2: self.z_viewmodel.func_changephotomovedown(row: tag)
                        default: break
                        }
                    })
                }
            default: break
            }
        }
        return cell
    }
}
@available(iOS 11.0, *)
extension ZUserPhotoEditViewController: UICollectionViewDragDelegate, UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        guard let destinationIndexPath = coordinator.destinationIndexPath, let dragingIndexPath = dragingIndexPath else { return }
        switch coordinator.proposal.operation {
        case .move:
            let items = coordinator.items
            if items.contains(where: { $0.sourceIndexPath != nil }) {
                if items.count == 1, let item = items.first, let path = item.sourceIndexPath {
                    let old = self.z_viewmodel.z_photos[path.row]
                    self.z_viewmodel.z_photos.remove(at: path.row)
                    self.z_viewmodel.z_photos.insert(old, at: destinationIndexPath.row)
                    self.z_viewmodel.z_changeduser = true
                    collectionView.performBatchUpdates({
                        collectionView.deleteItems(at: [path])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })
                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
        default: break
        }
    }
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        guard let _ = destinationIndexPath, let _ = dragingIndexPath else {
            return UICollectionViewDropProposal(operation: .cancel, intent: .unspecified)
        }
        if let _ = session.localDragSession {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UICollectionViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return nil
    }
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = self.z_viewmodel.z_photos[indexPath.row]
        let itemProvider = NSItemProvider(object: NSString.init(string: item))
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        dragingIndexPath = indexPath
        return [dragItem]
    }
}
extension ZUserPhotoEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.z_viewmodel.func_uploaduserphoto(image: image)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        ZRouterKit.dismiss(fromVC: picker, animated: true, completion: nil)
    }
}
extension ZUserPhotoEditViewController: ZUserEditViewModelDelegate {
    func func_photochange() {
        self.z_viewmain.reloadData()
    }
    func func_changeuserinfosuccess() {
        ZRouterKit.pop(fromVC: self)
    }
    func func_requesstuserinfosuccess() {
        self.z_viewmain.reloadData()
        self.z_viewmain.endRefreshHeader()
    }
}
