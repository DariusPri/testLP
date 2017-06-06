
import UIKit

class ConvoViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    
    var items = [
        "Pharetra Dapibus Ornare Sollicitudin Risus",
        "Ultricies Pellentesque",
        "Integer posuere erat a ante venenatis dapibus posuere velit aliquet.",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ullamcorper nulla non metus auctor fringilla. Integer posuere erat a ante venenatis dapibus posuere velit aliquet.",
        "ciao bello",
        "dswedwedew",
        "dwdwewdewdwefewrgergwerf ewrf ewrf wer fwe rfwer f wef er f",
        "dwed dwedwd dwwed wed",
        "dwedw de wedwe d",
        "wfdwed dew dew dw ed",
        "dwde wd edwed",
        "wdwed"
        ]
    
    
    fileprivate let sizingCell:MyCell = MyCell(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(MyCell.self, forCellWithReuseIdentifier: "MyCell")
        self.collectionView?.register(ConversationCellUser.self, forCellWithReuseIdentifier: "cell")
        
        self.collectionView?.backgroundColor = .white
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).sectionInset = UIEdgeInsetsMake(10, 0, 10, 0)
        
        self.collectionView?.reloadData()
        (self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout).invalidateLayout()
        
        self.collectionView?.keyboardDismissMode = .onDrag
        
        // TESTING INSERTIONS
//        DispatchQueue.main.asyncAfter(deadline: .now()+3) { 
//            self.insertNew()
//        }
//        
//        DispatchQueue.main.asyncAfter(deadline: .now()+6) {
//            self.insertNew2()
//        }
    }
    
    func insertNew() {
        let ip = IndexPath(item: 0, section: 0)
        //self.items.append("sdasdasdasdads sd asd asdsad")
        self.items.insert("adasd dwq qw sw s qws qws q", at: 0)

        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [ip])
          }, completion: {_ in
            self.collectionView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        })
        CATransaction.commit()

    }
    
    func insertNew2() {
        let ip = IndexPath(item: items.count, section: 0)
        self.items.insert("adasd dwq qw sw df f fd fd s qws qws q", at: items.count)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: [ip])
            }, completion: {_ in
              //  self.collectionView?.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        })
        CATransaction.commit()
        
    }
    
    func scrollTableDown(animated: Bool) {
        print("HEIGHT: ",self.collectionView?.contentSize.height)
        let height = 700

        self.collectionView?.setContentOffset(CGPoint(x: 0, y: height), animated: true)
    }
    
    // MARK: - UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of items: ", items.count)
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConversationCellUser
        cell.label.text = items[indexPath.item]
        cell.layoutIfNeeded()

        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    /*
     In its capacity as the UICollectionViewDelegateFlowLayout, the view controller
     supplies sizes for cells.
     
     But we want the cells to be responsible for handling their own layout and sizing.
     
     So we ask a cell to compute the sizing for us.
     
     Since sizing depends on content, we actually need to populate a cell with content before we can
     ask it to compute its size.
     
     Since this is a delegate layout method, it is not given a real cell to configure. It's only
     supposed to be supplying sizes. So how do we get the cell to use for calculating the size?
     
     We use a "sizing cell", a cell that is never displayed, and that we hold onto only for the purposes
     of doing layout calculations.
     
     PROS: this lets us keep layout configurations in cell code, using AL.
     CONS: this means we are performing layout calculations twice per cell.
     
     */
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let requiredWidth = collectionView.bounds.size.width
        
        self.sizingCell.label.text = items[indexPath.item]
        let adequateSize = self.sizingCell.preferredLayoutSizeFittingWidth(requiredWidth)
        return CGSize(width: adequateSize.width, height: adequateSize.height + 10)
    }
}





//  CONVERSATION CELL
//


class ConversationCellUser : UICollectionViewCell {

    override class var requiresConstraintBasedLayout : Bool { return true }


    let label = UILabel()
    let mainContainerView = UIView()
    let textContainerView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        return view
    }()

    //var data : MessageInfo? { didSet { updateCell() } }


//    func updateCell() {
//        guard let data = data else { return }
//
//        messageLabel.text = data.text
//
//    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .clear

        clipsToBounds = true

        label.translatesAutoresizingMaskIntoConstraints = false
        textContainerView.translatesAutoresizingMaskIntoConstraints = false
        mainContainerView.translatesAutoresizingMaskIntoConstraints = false
        //contentView.translatesAutoresizingMaskIntoConstraints = false
        //self.translatesAutoresizingMaskIntoConstraints = false

        mainContainerView.addSubview(textContainerView)
        textContainerView.addSubview(label)
        contentView.addSubview(mainContainerView)



        NSLayoutConstraint(item: textContainerView, attribute: .right, relatedBy: .equal, toItem: mainContainerView, attribute: .right, multiplier: 1, constant: -10).isActive = true


        textContainerView.addConstraintsWithFormat(format: "H:|-14-[v0]-14-|", views: label)
        textContainerView.addConstraintsWithFormat(format: "V:|-10-[v0]-10-|", views: label)

        contentView.addConstraintsWithFormat(format: "H:|[v0]|", views: mainContainerView)
        contentView.addConstraintsWithFormat(format: "V:|[v0]|", views: mainContainerView)

        textContainerView.backgroundColor = .lightGray


        //NSLayoutConstraint(item: mainContainerView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.width).isActive = true

        //contentView.widthAnchor.constraint(equalToConstant: 414).isActive = true
        //self.widthAnchor.constraint(equalToConstant: 414).isActive = true

        label.preferredMaxLayoutWidth = 200
        label.numberOfLines = 0

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

//    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
//        super.apply(layoutAttributes)
//
//
//        UIView.performWithoutAnimation {
//            transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
//            updateConstraints()
//            setNeedsUpdateConstraints()
//        }
//    }

    //    override func prepareForReuse() {
    //        super.prepareForReuse()
    //
    //        print("REUSING ! ")
    //
    //        messageLabel.text = ""
    //
    //
    //
    //        layoutIfNeeded()
    //        setNeedsDisplay()
    //        setNeedsUpdateConstraints()
    //    }

//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        self.contentView.layoutIfNeeded()
//        label.preferredMaxLayoutWidth = 200
//    }

    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        //transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
        
    }


    func preferredLayoutSizeFittingWidth(_ targetWidth:CGFloat) -> CGSize {
        NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:):ENTRY: called with targetWidth=%@", NSNumber(value: Float(targetWidth) as Float))
        // save original frame and preferredMaxLayoutWidth of the
        let originalFrame = self.frame
        let originalPreferredMaxLayoutWidth : CGFloat = 200.0//  self.label.preferredMaxLayoutWidth
        
        // assert: targetSize.width has the required width of the cell
        
        // step1: set the cell.frame to use that width, and an excessive height
        var frame = self.frame
        frame.size = CGSize(width: targetWidth, height: 30000)
        self.frame = frame
        
        // step2: layout the cell's subviews, based on the required width and excessive height
        NSLog("MyCell.preferredLayoutSizeFittingWidth(targetWidth:): about to call layoutIfNeeded on the sizing cell")
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.label.preferredMaxLayoutWidth = self.label.bounds.size.width
        
        // assert: the cell.label.bounds.size.width has now been set to the width required by the cell.bounds.size.width
        
        // step3: compute how tall the cell needs to be
        
        // this causes the cell to compute the height it needs, which it does by asking the
        // label what height it needs to wrap within its current bounds (which we just set).
        // (note that the label is getting its wrapping width from its bounds, not preferredMaxLayoutWidth)
        NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:): about to call systemLayoutSizeFittingSize on the sizing cell")
        let computedSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        // assert: computedSize has the needed height for the cell
        
        // Apple: "Only consider the height for cells, because the contentView isn't anchored correctly sometimes."
        let newSize = CGSize(width:targetWidth,height:computedSize.height)
        
        // restore old frame
        self.frame = originalFrame
        self.label.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
        
        NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:): EXIT: returning size=%@",NSStringFromCGSize(newSize))
        return newSize
    }

}





class MyCell: UICollectionViewCell
{
    
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override class var requiresConstraintBasedLayout : Bool { return true }
    
    class var classReuseIdentifier : String { return "MyCell" }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.label.numberOfLines = 0
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.label)
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label(<=200)]-(>=0)-|", options: [], metrics: nil, views: ["label":self.label]))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[label]-|", options: [], metrics: nil, views: ["label":self.label]))
        
        
        self.backgroundColor = UIColor.gray // seeing gray => Apple bug.
        self.contentView.backgroundColor = UIColor.green
        self.label.backgroundColor = UIColor.yellow
        
        //self.label.preferredMaxLayoutWidth = 200
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        
//        self.contentView.layoutIfNeeded()
//        label.preferredMaxLayoutWidth = 200
//    }
    
    /*
     Computes the size the cell needs to be, if it must be a given width
     
     @param targetWidth width the cell must be
     
     the returned size will have the same width, and the height which is
     calculated by Auto Layout so that the contents of the cell (i.e., text in the label)
     can fit within that width.
     
     */
    func preferredLayoutSizeFittingWidth(_ targetWidth:CGFloat) -> CGSize {
        NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:):ENTRY: called with targetWidth=%@", NSNumber(value: Float(targetWidth) as Float))
        // save original frame and preferredMaxLayoutWidth of the
        let originalFrame = self.frame
        let originalPreferredMaxLayoutWidth : CGFloat = 200.0//  self.label.preferredMaxLayoutWidth
        
        // assert: targetSize.width has the required width of the cell
        
        // step1: set the cell.frame to use that width, and an excessive height
        var frame = self.frame
        frame.size = CGSize(width: targetWidth, height: 30000)
        self.frame = frame
        
        // step2: layout the cell's subviews, based on the required width and excessive height
        NSLog("MyCell.preferredLayoutSizeFittingWidth(targetWidth:): about to call layoutIfNeeded on the sizing cell")
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.label.preferredMaxLayoutWidth = self.label.bounds.size.width
        
        // assert: the cell.label.bounds.size.width has now been set to the width required by the cell.bounds.size.width
        
        // step3: compute how tall the cell needs to be
        
        // this causes the cell to compute the height it needs, which it does by asking the
        // label what height it needs to wrap within its current bounds (which we just set).
        // (note that the label is getting its wrapping width from its bounds, not preferredMaxLayoutWidth)
        NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:): about to call systemLayoutSizeFittingSize on the sizing cell")
        let computedSize = self.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        // assert: computedSize has the needed height for the cell
        
        // Apple: "Only consider the height for cells, because the contentView isn't anchored correctly sometimes."
        let newSize = CGSize(width:targetWidth,height:computedSize.height)
        
        // restore old frame
        self.frame = originalFrame
        self.label.preferredMaxLayoutWidth = originalPreferredMaxLayoutWidth
        
        NSLog("MyCell.preferredLayoutSizeFittingSize(targetSize:): EXIT: returning size=%@",NSStringFromCGSize(newSize))
        return newSize
    }
}

