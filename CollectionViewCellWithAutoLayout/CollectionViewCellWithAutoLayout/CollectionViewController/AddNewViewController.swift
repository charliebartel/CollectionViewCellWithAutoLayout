//
//  AddNewViewController.swift
//  CollectionViewCellWithAutoLayout
//
//  Created by Charlie Bartel on 2/6/15.
//  Copyright (c) 2015 CharlieBartel. All rights reserved.
//

import Foundation

class AddNewViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    var collectionView: UICollectionView?
    var model = Model()
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Internal Methods
    // --------------------------------------------------------------------------------
    
    // This function will be called when the Dynamic Type user setting changes (from the system Settings app)
    func contentSizeCategoryChanged(notification: NSNotification) {
        collectionView?.reloadData()
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Private Methods
    // --------------------------------------------------------------------------------
    
    private func updateViews() {
        collectionView?.frame = getCollectionViewFrame()
        collectionView?.reloadData()
    }
    
    private func cellCount() -> Int {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return orientation.isPortrait ? 18 : 16
    }
    
    private func rowCellCount() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return orientation.isPortrait ? 4 : 7
    }
    
    private func isHorizontalCell(indexPath: NSIndexPath) -> Bool {
        return indexPath.row >= (cellCount() - 2)
    }
    
    private func isHiddenCell(indexPath: NSIndexPath) -> Bool {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return (orientation.isPortrait && (indexPath.row == cellCount() - 4 || indexPath.row == cellCount() - 3))
    }
    
    private func getRow(indexPath: NSIndexPath) -> Int {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        return (orientation.isPortrait && isHorizontalCell(indexPath)) ? indexPath.row - 2 : indexPath.row
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: Private Size Methods
    // --------------------------------------------------------------------------------
    
    private func horizontalCellSize() -> CGSize {
        return CGSize(width: horizontalCellWidth(), height: 50.0)
    }
    
    private func horizontalCellWidth() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation.isPortrait {
            return getCollectionViewWidth() - (leftRightInset() * 2)
        } else {
            return (getCollectionViewWidth() - verticalCellWidth() - (leftRightInset() * 4)) / 2
        }
    }
    
    private func verticalCellSize() -> CGSize {
        return CGSize(width: verticalCellWidth(), height: 75.0)
    }
    
    private func verticalCellWidth() -> CGFloat {
        return (getCollectionViewWidth() - (leftRightInset() * (rowCellCount() + 1)))  / rowCellCount()
    }
    
    private func getCollectionViewWidth() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return view.frame.size.width
        } else {
            return orientation.isPortrait ? 414 : 736
        }
    }
    
    private func getCollectionViewHeight() -> CGFloat {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return view.frame.size.height
        } else {
            return orientation.isPortrait ? 736 : 414
        }
    }
    
    private func getCollectionViewFrame() -> CGRect {
        if (UIDevice.currentDevice().userInterfaceIdiom == .Phone) {
            return CGRectMake(0, 0, getCollectionViewWidth(), getCollectionViewHeight())
        } else {
            return CGRectMake(view.frame.size.width / 2 - getCollectionViewWidth() / 2, 0, getCollectionViewWidth(), getCollectionViewHeight())
        }
    }
    
    private func headerHeight() -> CGFloat {
        return 40.0
    }
    
    private func leftRightInset() -> CGFloat {
        return 4.0
    }
    
    private func bottomInset() -> CGFloat {
        return 4.0
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UIViewController Methods
    // --------------------------------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        updateViews()
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.All.rawValue)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "contentSizeCategoryChanged:", name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIContentSizeCategoryDidChangeNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        model.populate()
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: leftRightInset(), bottom: bottomInset(), right: leftRightInset())
        layout.minimumInteritemSpacing = leftRightInset()
        layout.minimumLineSpacing = bottomInset()
        
        collectionView = UICollectionView(frame: getCollectionViewFrame(), collectionViewLayout: layout)
        if let collection = collectionView {
            collection.dataSource = self
            collection.delegate = self
            collection.registerClass(AddNewCell.self, forCellWithReuseIdentifier: "CellVertical")
            collection.registerClass(AddNewCell.self, forCellWithReuseIdentifier: "CellHorizontal")
            collection.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView")
            collection.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(collection)
        }
        
        view.backgroundColor = UIColor.lightGrayColor()
        edgesForExtendedLayout = .None
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UICollectionViewDataSource Methods
    // --------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount()
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let identifier = isHorizontalCell(indexPath) ? "CellHorizontal" : "CellVertical"
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as? AddNewCell {
            
            cell.hidden = isHiddenCell(indexPath)
            let insets = (verticalCellWidth() - cell.imageSize) / 2
            isHorizontalCell(indexPath) ? cell.updateCell(.Horizontal, horizontalInsets: insets) : cell.updateCell(.Vertical, horizontalInsets: insets)
            
            let modelItem = model.dataArray[getRow(indexPath)]
            cell.titleLabel.text = modelItem.title
            cell.imageView.image = UIImage(named: "star")
            cell.isAccessibilityElement = true
            cell.accessibilityLabel = cell.titleLabel.text
            
            // Make sure the constraints have been added to this cell, since it may have just been created from scratch
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            
            return cell
        }
        
        assert(false, "The dequeued cell was of an unknown type")
        return UICollectionViewCell()
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        if (kind == UICollectionElementKindSectionHeader) {
            if let reusableview = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderView", forIndexPath: indexPath) as? UICollectionReusableView {
                if (reusableview.subviews.count > 0) {
                    if let view = reusableview.subviews[0] as? UIView {
                        view.removeFromSuperview()
                    }
                }
                
                let sectionLabel = UILabel(frame: CGRectMake(0, 0, collectionView.frame.size.width, headerHeight()))
                sectionLabel.text = NSLocalizedString("Title for Section Header", comment: "")
                sectionLabel.backgroundColor = UIColor.clearColor()
                sectionLabel.textAlignment = .Center
                sectionLabel.font = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline)
                reusableview.addSubview(sectionLabel)
                return reusableview
            }
        }
        
        assert(false, "The view was of an unknown kind")
        return UICollectionReusableView()
        
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UICollectionViewDelegate Methods
    // --------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    }
    
    // --------------------------------------------------------------------------------
    // MARK: -
    // MARK: UICollectionViewDelegateFlowLayout Methods
    // --------------------------------------------------------------------------------
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return isHorizontalCell(indexPath) ? horizontalCellSize() : verticalCellSize()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: headerHeight())
    }
}

