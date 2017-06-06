//
//  AppDelegate.swift
//  testLP
//
//  Created by Darius on 25/03/2017.
//  Copyright © 2017 Darius Prismontas. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        if let window = window {
            window.backgroundColor = UIColor.white
            window.rootViewController = MessagesViewController()
            window.makeKeyAndVisible()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}






extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}












class ChatCollectionViewFlowLayout2: UICollectionViewFlowLayout {
    
    private var topMostVisibleItem    =  Int.max
    private var bottomMostVisibleItem = -Int.max
    
    private var offset: CGFloat = 0.0
    private var visibleAttributes: [UICollectionViewLayoutAttributes]?
    
    private var isInsertingItemsToTop    = false
    private var isInsertingItemsToBottom = false
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Reset each time all values to recalculate them
        // ════════════════════════════════════════════════════════════
        
        // Get layout attributes of all items
        visibleAttributes = super.layoutAttributesForElements(in: rect)
        
        // Erase offset
        offset = 0.0
        
        // Reset inserting flags
        isInsertingItemsToTop    = false
        isInsertingItemsToBottom = false
        
        return visibleAttributes
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        // Check where new items get inserted
        // ════════════════════════════════════════════════════════════
        
        // Get collection view and layout attributes as non-optional object
        guard let collectionView = self.collectionView       else { return }
        guard let visibleAttributes = self.visibleAttributes else { return }
        
        
        // Find top and bottom most visible item
        // ────────────────────────────────────────────────────────────
        
        bottomMostVisibleItem = -Int.max
        topMostVisibleItem    =  Int.max
        
        let container = CGRect(x: collectionView.contentOffset.x,
                               y: collectionView.contentOffset.y,
                               width:  collectionView.frame.size.width,
                               height: (collectionView.frame.size.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)))
        
        for attributes in visibleAttributes {
            
            // Check if cell frame is inside container frame
            if attributes.frame.intersects(container) {
                let item = attributes.indexPath.item
                if item < topMostVisibleItem    { topMostVisibleItem    = item }
                if item > bottomMostVisibleItem { bottomMostVisibleItem = item }
            }
            
            // NEW
            //attributes.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        }
        
        
        // Call super after first calculations
        super.prepare(forCollectionViewUpdates: updateItems)
        
        
        // Calculate offset of inserting items
        // ────────────────────────────────────────────────────────────
        
        var willInsertItemsToTop    = false
        var willInsertItemsToBottom = false
        
        // Iterate over all new items and add their height if they go inserted
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                if 5000 + updateItems.count > updateItem.indexPathAfterUpdate!.item {
                    if let newAttributes = self.layoutAttributesForItem(at: updateItem.indexPathAfterUpdate!) {
                        
                        offset += (newAttributes.size.height + self.minimumLineSpacing)
                        willInsertItemsToTop = true
                    }
                    
                } else if bottomMostVisibleItem <= updateItem.indexPathAfterUpdate!.item {
                    if let newAttributes = self.layoutAttributesForItem(at: updateItem.indexPathAfterUpdate!) {
                        
                        offset += (newAttributes.size.height + self.minimumLineSpacing)
                        willInsertItemsToBottom = true
                    }
                }
                
            case.delete:
                // TODO: Handle removal of items
                break
                
            default:
                break
            }
        }
        
        
        // Pass on information if items need more than one screen
        // ────────────────────────────────────────────────────────────
        
        // Just continue if one flag is set
        if willInsertItemsToTop || willInsertItemsToBottom {
            
            // Get heights without top and bottom
            let collectionViewContentHeight = collectionView.contentSize.height
            let collectionViewFrameHeight   = collectionView.frame.size.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
            
            // Continue only if the new content is higher then the frame
            // If it is not the case the collection view can display all cells on one screen
            if collectionViewContentHeight + offset > collectionViewFrameHeight {
                
                if willInsertItemsToTop {
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    isInsertingItemsToTop = true
                    
                } else if willInsertItemsToBottom {
                    isInsertingItemsToBottom = true
                }
            }
        }
    }
    
    
    
    override func finalizeCollectionViewUpdates() {
        
        // Set final content offset with animation or not
        // ════════════════════════════════════════════════════════════
        
        // Get collection view as non-optional object
        guard let collectionView = self.collectionView else { return }
        
        if isInsertingItemsToTop {
            
            print("### inserting top")
            
            // Calculate new content offset
            let newContentOffset = CGPoint(x: collectionView.contentOffset.x,
                                           y: collectionView.contentOffset.y + offset)
            
            // Set new content offset without animation
            collectionView.contentOffset = newContentOffset
            
            // Commit/end transaction
            CATransaction.commit()
            
        } else if isInsertingItemsToBottom {
            
            print("### inserting bottom with content offset : \(collectionView.contentOffset.y)")
            
            let currentOffset = collectionView.contentOffset
            
            if currentOffset.y <= 0.0 {
                print("### BAD INSERT! ")
                
                
                //                CATransaction.begin()
                //                CATransaction.setDisableActions(true)
                // self.collectionView?.performBatchUpdates({
                //self.collectionView?.insertItems(at: [indexPath, indexPath2])
                //self.collectionView?.reloadData()
                //self.collectionView?.setContentOffset(CGPoint(x: 0, y: currentOffset), animated: false)
                
                //                    let contentY = self.collectionView?.contentSize.height
                //                    let offsetY = self.collectionView?.contentOffset.y
                //                    print(" ((\(offsetY!) - (\(contentHeight) - \(contentY!))))")
                //                    let y = ((offsetY! - (contentHeight - contentY!)))
                //                    print("### Y: ",y)
                //                    print("### (\(self.collectionView!.contentSize.height) - \(self.collectionView!.frame.size.height))")
                
                //self.collectionView?.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
                //  }, completion: {_ in
                // self.scrollTableDown(animated: true)
                //                        self.collectionView?.reloadData()
                // self.collectionView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                // })
                
                //let newContentOffset = CGPoint(x: collectionView.contentOffset.x,
                //                               y: collectionView.contentOffset.y + offset)
                
                // Set new content offset without animation
                //collectionView.contentOffset = newContentOffset
                collectionView.contentOffset = currentOffset
                // CATransaction.commit()
                
                //let newContentOffset = CGPoint(x: 0, y: 0)
                //collectionView.setContentOffset(newContentOffset, animated: true)
                //CATransaction.commit()
                
            } else {
                print("### GOOOD INSERT! ")
                let newContentOffset = CGPoint(x: 0, y: 0)
                
                //CGPoint(x: collectionView.contentOffset.x,
                //y: 0)
                // y: collectionView.contentSize.height + offset - collectionView.frame.size.height + collectionView.contentInset.bottom)
                
                collectionView.setContentOffset(newContentOffset, animated: true)
                
            }
            
            // Calculate new content offset
            // Always scroll to bottom
                        let newContentOffset = CGPoint(x: collectionView.contentOffset.x,
                                                       //y: 0)
            
                                                       y: collectionView.contentSize.height + offset - collectionView.frame.size.height + collectionView.contentInset.bottom)
            
                        // Set new content offset with animation
            
            
                        collectionView.setContentOffset(newContentOffset, animated: true)
        }
    }
    
    //    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    //        //let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
    //
    //
    //        let attributes = self.layoutAttributesForItem(at: itemIndexPath)
    //        //attributes?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    //        self.invalidateLayout()
    //        return attributes
    //
    //
    //        print("@@@ APPEARING CELLS! ")
    //
    //        attributes?.transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    //        self.invalidateLayout()
    //        return attributes
    //
    //        //attributes?.transform = CGAffineTransform(scaleX: 0.2, y: 0.2).rotated(by: CGFloat(M_PI));
    //        //attributes?.center = CGPoint(x: (self.collectionView?.bounds)!.midX, y: (self.collectionView?.bounds)!.maxY);
    //        //attributes?.transform = CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
    //
    //        //return attributes
    //    }
    
    
    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        
//        return false
//        
//        if !newBounds.size.equalTo(collectionView!.bounds.size) {
//            itemSize.width = 200
//            collectionView?.layoutIfNeeded()
//            
//            return true
//        }
//        return false
//    }
    
    
}






class ChatCollectionViewFlowLayout3: UICollectionViewFlowLayout {
    
    private var topMostVisibleItem    =  Int.max
    private var bottomMostVisibleItem = -Int.max
    
    private var offset: CGFloat = 0.0
    private var visibleAttributes: [UICollectionViewLayoutAttributes]?
    
    private var isInsertingItemsToTop    = false
    private var isInsertingItemsToBottom = false
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        // Reset each time all values to recalculate them
        // ════════════════════════════════════════════════════════════
        
        // Get layout attributes of all items
        visibleAttributes = super.layoutAttributesForElements(in: rect)
        
        // Erase offset
        offset = 0.0
        
        // Reset inserting flags
        isInsertingItemsToTop    = false
        isInsertingItemsToBottom = false
        
        return visibleAttributes
    }
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        
        // Check where new items get inserted
        // ════════════════════════════════════════════════════════════
        
        // Get collection view and layout attributes as non-optional object
        guard let collectionView = self.collectionView       else { return }
        guard let visibleAttributes = self.visibleAttributes else { return }
        
        
        // Find top and bottom most visible item
        // ────────────────────────────────────────────────────────────
        
        bottomMostVisibleItem = -Int.max
        topMostVisibleItem    =  Int.max
        
        let container = CGRect(x: collectionView.contentOffset.x,
                               y: collectionView.contentOffset.y,
                               width:  collectionView.frame.size.width,
                               height: (collectionView.frame.size.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)))
        
        for attributes in visibleAttributes {
            
            // Check if cell frame is inside container frame
            if attributes.frame.intersects(container) {
                let item = attributes.indexPath.item
                if item < topMostVisibleItem    { topMostVisibleItem    = item }
                if item > bottomMostVisibleItem { bottomMostVisibleItem = item }
            }
        }
        
        
        // Call super after first calculations
        super.prepare(forCollectionViewUpdates: updateItems)
        
        
        // Calculate offset of inserting items
        // ────────────────────────────────────────────────────────────
        
        var willInsertItemsToTop    = false
        var willInsertItemsToBottom = false
        
        // Iterate over all new items and add their height if they go inserted
        for updateItem in updateItems {
            switch updateItem.updateAction {
            case .insert:
                if topMostVisibleItem + updateItems.count > updateItem.indexPathAfterUpdate!.item {
                    if let newAttributes = self.layoutAttributesForItem(at: updateItem.indexPathAfterUpdate!) {
                        
                        offset += (newAttributes.size.height + self.minimumLineSpacing)
                        willInsertItemsToTop = true
                    }
                    
                } else if bottomMostVisibleItem <= updateItem.indexPathAfterUpdate!.item {
                    if let newAttributes = self.layoutAttributesForItem(at: updateItem.indexPathAfterUpdate!) {
                        
                        offset += (newAttributes.size.height + self.minimumLineSpacing)
                        willInsertItemsToBottom = true
                    }
                }
                
            case.delete:
                // TODO: Handle removal of items
                break
                
            default:
                break
            }
        }
        
        
        // Pass on information if items need more than one screen
        // ────────────────────────────────────────────────────────────
        
        // Just continue if one flag is set
        if willInsertItemsToTop || willInsertItemsToBottom {
            
            // Get heights without top and bottom
            let collectionViewContentHeight = collectionView.contentSize.height
            let collectionViewFrameHeight   = collectionView.frame.size.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
            
            // Continue only if the new content is higher then the frame
            // If it is not the case the collection view can display all cells on one screen
            if collectionViewContentHeight + offset > collectionViewFrameHeight {
                
                if willInsertItemsToTop {
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    isInsertingItemsToTop = true
                    
                } else if willInsertItemsToBottom {
                    isInsertingItemsToBottom = true
                }
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        
        // Set final content offset with animation or not
        // ════════════════════════════════════════════════════════════
        
        // Get collection view as non-optional object
        guard let collectionView = self.collectionView else { return }
        
        if isInsertingItemsToTop {
            
            // Calculate new content offset
            let newContentOffset = CGPoint(x: collectionView.contentOffset.x,
                                           y: collectionView.contentOffset.y + offset)
            
            // Set new content offset without animation
            collectionView.contentOffset = newContentOffset
            
            // Commit/end transaction
            CATransaction.commit()
            
        } else if isInsertingItemsToBottom {
            
            // Calculate new content offset
            // Always scroll to bottom
            let newContentOffset = CGPoint(x: collectionView.contentOffset.x,
                                           y: collectionView.contentSize.height + offset - collectionView.frame.size.height + collectionView.contentInset.bottom)
            
            // Set new content offset with animation
            collectionView.setContentOffset(newContentOffset, animated: true)
        }
    }
}

