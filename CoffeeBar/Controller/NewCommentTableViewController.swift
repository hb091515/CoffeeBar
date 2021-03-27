//
//  NewCommentTableViewController.swift
//  CoffeeBar
//
//  Created by yacheng on 2021/3/17.
//

import UIKit
import CoreData
import CloudKit

class NewCommentTableViewController: UITableViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var newComment: CommentModel!

    @IBAction func dismissBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var nameTextField: RoundedTextField!{
        didSet{
            nameTextField.tag = 1
            nameTextField.becomeFirstResponder()
            nameTextField.delegate = self
        }
    }
    @IBOutlet weak var descriptionTextView: UITextView!{
        didSet{
            descriptionTextView.tag = 2
            descriptionTextView.layer.cornerRadius = 5.0
            descriptionTextView.layer.masksToBounds = true
        }
    }
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
        
        if nameTextField.text == "" || descriptionTextView.text == ""{
            let alert = UIAlertController(title: "錯誤", message: "有爛位未填入", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
        }
        
        
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            newComment = CommentModel(context: appDelegate.persistentContainer.viewContext)
            newComment.name = nameTextField.text
            newComment.desc = descriptionTextView.text

            if let image = photoImage.image{
                newComment.image = image.pngData()
            }
            

        }
            
        saveRecordToCloud(comment: newComment)
        
        dismiss(animated: true, completion: nil)
        
    }
    @IBOutlet weak var photoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationControllersetting()

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //將目前標籤值+1，取得下一個文字欄位
        if let nextTextField = view.viewWithTag(textField.tag + 1){
            //移除目前對文字欄位的焦點
            textField.resignFirstResponder()
            nextTextField.becomeFirstResponder()
        }
        return true
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2{
            let photoSourceController = UIAlertController(title: "", message: "請選擇照片來源", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "相機", style: .default, handler: {
                (action) in
                //選擇相片來源 .camera(啟動相機) or .photoLibrary(從手機圖片庫裡)
                if UIImagePickerController.isSourceTypeAvailable(.camera){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .camera
                    imagePicker.delegate = self

                    self.present(imagePicker, animated: true, completion: nil)
                }
                
            })
            
            let photoLibraryAction = UIAlertAction(title: "圖片庫", style: .default, handler: {
                (action) in
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let imagePicker = UIImagePickerController()
                    imagePicker.allowsEditing = false
                    imagePicker.sourceType = .photoLibrary
                    imagePicker.delegate = self
                    
                    self.present(imagePicker, animated: true, completion: nil)
                }
                
                
            })
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            
            photoSourceController.addAction(cameraAction)
            photoSourceController.addAction(photoLibraryAction)
            photoSourceController.addAction(cancelAction)
            
            //針對iPad
            if let popoverController = photoSourceController.popoverPresentationController{
                if let cell = tableView.cellForRow(at: indexPath){
                    popoverController.sourceView = cell
                    popoverController.sourceRect = cell.bounds
                }
                
            }
            
            present(photoSourceController, animated: true, completion: nil)

        }
        
    }
    
    
    //使用者從照片庫選擇照片後，會呼叫方法
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            photoImage.image = selectedImage
            photoImage.contentMode = .scaleAspectFill
            photoImage.clipsToBounds = true
        }
        
        let leading = NSLayoutConstraint(item: photoImage, attribute: .leading, relatedBy: .equal, toItem: photoImage.superview, attribute: .leading, multiplier: 1, constant: 0)
        leading.isActive = true
        
        let trailing = NSLayoutConstraint(item: photoImage, attribute: .trailing, relatedBy: .equal, toItem: photoImage.superview, attribute: .trailing, multiplier: 1, constant: 0)
        trailing.isActive = true
        
        let top = NSLayoutConstraint(item: photoImage, attribute: .top, relatedBy: .equal, toItem: photoImage.superview, attribute: .top, multiplier: 1, constant: 0)
        top.isActive = true
        
        let bottom = NSLayoutConstraint(item: photoImage, attribute: .bottom, relatedBy: .equal, toItem: photoImage.superview, attribute: .bottom, multiplier: 1, constant: 0)
        bottom.isActive = true
        
        dismiss(animated: true, completion: nil)
    }

    func navigationControllersetting(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 255.0/255.0, green: 0, blue: 0, alpha: 1.0)]
    }

    
    //儲存資料到iCloud方法
    func saveRecordToCloud(comment:CommentModel){
        
        let record = CKRecord(recordType: "Comment")
        
        record.setValue(comment.name, forKey: "name")
        record.setValue(comment.desc, forKey: "description")
        
        let imageData = comment.image! as Data
        
        //調整圖片大小
        let originalImage = UIImage(data: imageData)!
        let scalingFactor = (originalImage.size.width > 1024) ? 1024 / originalImage.size.width : 1.0
        let scaledImage = UIImage(data: imageData, scale: scalingFactor)!
        
        //將圖片寫進本地端作為暫時使用
        let imageFilePath = NSTemporaryDirectory() + comment.name! //取得暫時目錄的路徑
        let imageFileURL = URL(fileURLWithPath: imageFilePath)
        try? scaledImage.jpegData(compressionQuality: 0.8)?.write(to: imageFileURL)
        
        //建立要上傳的圖片素材
        let imageAsset = CKAsset(fileURL: imageFileURL)
        record.setValue(imageAsset, forKey: "image")
        
        //讀取iCloud公共資料庫
        let publicDatabase = CKContainer(identifier: "iCloud.cofeBarContainer").publicCloudDatabase
        
        //儲存資料到iCloud
        
        publicDatabase.save(record, completionHandler: {
            (record, completionHandler) in
            try? FileManager.default.removeItem(at: imageFileURL)
        })
    }
}
