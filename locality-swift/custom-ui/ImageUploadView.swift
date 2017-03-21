//
//  ImageUploadView.swift
//  locality-swift
//
//  Created by Chelsea Power on 3/9/17.
//  Copyright © 2017 Brian Maci. All rights reserved.
//

import UIKit

protocol ImageUploadViewDelegate {
    func takePhotoTapped()
    func uploadPhotoTapped()
}
class ImageUploadView: UIView {
    
    @IBOutlet weak var view:UIView!
    
    @IBOutlet weak var takePhotoView:UIView!
    @IBOutlet weak var uploadPhotoView:UIView!
    @IBOutlet weak var takePhotoButton:UIButton!
    @IBOutlet weak var uploadPhotoButton:UIButton!
    @IBOutlet weak var selectedPhoto:SelectedPhotoView!
    
    var delegate:ImageUploadViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        Bundle.main.loadNibNamed(K.NIBName.ImageUploadView, owner: self, options: nil)
        self.addSubview(view)
        view.frame = self.bounds
        
        initView()
    }
    
    func initView() {
        takePhotoButton.addTarget(self, action: #selector(takePhotoDidTouch), for: .touchUpInside)
        uploadPhotoButton.addTarget(self, action: #selector(uploadPhotoDidTouch), for: .touchUpInside)
        
        selectedPhoto.set(hidden:true)
    }

    func setLocationImage(image:UIImage) {
        selectedPhoto.populateImage(img: image)
    }
    
    func hasImage() -> Bool {
        return selectedPhoto.imgView.image == nil ? false : true
    }
    
    func getImage() -> UIImage {
        return selectedPhoto.imgView.image!
    }
    
    //CTA
    func takePhotoDidTouch(sender:UIButton) {
        delegate?.takePhotoTapped()
    }
    
    func uploadPhotoDidTouch(sender:UIButton) {
        delegate?.uploadPhotoTapped()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
