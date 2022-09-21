//
//  PhotoCollectionViewController.swift
//  PhotoGamut
//
//  Created by e.b.olson on 9/16/22.
//

import Photos
import UIKit

class PhotoCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var collectionViewFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var noPhotosView: UIView!
    
    var photos: PHFetchResult<PHAsset>?
    
    let imageManager = PHCachingImageManager()
    var thumbnailSize: CGSize!
    
    var currentCollectionViewWidth: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Manage Photo Permissions
        managePhotoPermissions()
        
        // Fetch Photos
        fetchPhotos()
        
        // Process Photos
        processPhotos()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let scale = UIScreen.main.scale
        let cellSize = collectionViewFlowLayout.itemSize
        thumbnailSize = CGSize(width: cellSize.width * scale, height: cellSize.height * scale)
        thumbnailSize = CGSize(width: cellSize.width, height: cellSize.height)
        
        noPhotosView.isHidden = ((photos?.count ?? 0) > 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let permissionStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        if [PHAuthorizationStatus.denied].contains(permissionStatus) {
            presentPermissionsAlert()
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let newCollectionViewWidth = view.bounds.inset(by: view.safeAreaInsets).width
        
        if currentCollectionViewWidth != newCollectionViewWidth {
            currentCollectionViewWidth = newCollectionViewWidth
            
            let columnCount = (currentCollectionViewWidth / 80).rounded(.towardZero)
            let itemWidth = currentCollectionViewWidth / columnCount
            collectionViewFlowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // TODO: handle this more gracefully
        guard let photoAsset = photos?.object(at: indexPath.item)
            else { fatalError("ERROR: Unable to fetch photo!") }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as? PhotoCollectionViewCell
            else { fatalError("ERROR: Unable to get or create PhotoCollectionViewCell") }
        
        cell.photoIdentifier = photoAsset.localIdentifier
        imageManager.requestImage(for: photoAsset, targetSize: thumbnailSize, contentMode: .aspectFill, options: nil, resultHandler: { image, _ in
            if cell.photoIdentifier == photoAsset.localIdentifier {
                cell.thumbnailImage = image
            }
        })
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos?.count ?? 0
    }
}


// MARK: - Photo Permissions & Fetching

extension PhotoCollectionViewController {
    func managePhotoPermissions() {
        let permissionStatus = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        debugPrint("Permissions: \(permissionStatus)")
        
        if [PHAuthorizationStatus.notDetermined, PHAuthorizationStatus.denied].contains(permissionStatus) {
            // Need to request permissions
            requestPermissions()
        }
    }
    
    func requestPermissions() {
        // Request read-write access to the user's photo library.
        PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
            switch status {
            case .notDetermined:
                debugPrint("WARNING: Photo Permissions still not determined.")
            case .restricted:
                self?.fetchPhotos()
                self?.processPhotos()
                debugPrint("Photo Permissions: Restricted")
            case .denied:
                debugPrint("WARNING: Photo Permissions DENIED!")
            case .authorized:
                self?.fetchPhotos()
                self?.processPhotos()
                debugPrint("Photo Permissions: Authorized!")
            case .limited:
                self?.fetchPhotos()
                self?.processPhotos()
                debugPrint("Photo Permissions: Limited")
            @unknown default:
                fatalError()
            }
        }
    }
    
    func presentPermissionsAlert() {
        let alert = UIAlertController(title: "Photo Permissions", message: "To create the photo gamut, this app needs permission to access your photo library.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"), style: .default, handler: { _ in }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Open Settings"), style: .default, handler: { [weak self] _ in
            self?.openAppSettings()
        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString) {
            Task {
                await UIApplication.shared.open(settingsUrl)
            }
        }
    }
    
    func fetchPhotos() {
        let photoFetchOptions = PHFetchOptions()
        photos = PHAsset.fetchAssets(with: photoFetchOptions)
    }
}

// MARK: - Photo Processing

extension PhotoCollectionViewController {
    func processPhotos() {
        // TODO: This is the secret sauce!
        
        
        // When the photo processing is done, refresh the view
        DispatchQueue.main.async { [weak self] in
            self?.collectionViewFlowLayout.collectionView?.reloadData()
        }
    }
}
