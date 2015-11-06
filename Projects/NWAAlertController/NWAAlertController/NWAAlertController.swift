import Foundation
import UIKit

//@available(iOS 8.0, *)
//enum UIAlertActionStyle : Int {
//    
//    case Default
//    case Cancel
//    case Destructive
//}

//@available(iOS 8.0, *)
//enum UIAlertControllerStyle : Int {
//    
//    case ActionSheet
//    case Alert
//}

//@available(iOS 8.0, *)
//class UIAlertAction : NSObject, NSCopying {
//    
//    convenience init(title: String?, style: UIAlertActionStyle, handler: ((UIAlertAction) -> Void)?)
//    
//    var title: String? { get }
//    var style: UIAlertActionStyle { get }
//    var enabled: Bool
//}

// MARK: - NWAAlertAction

@available(iOS 9.0, *)
public class NWAAlertAction {
    
    var title: String?
    var style: UIAlertActionStyle = .Default
    var handler: ((NWAAlertAction) -> Void)?
    
    public init() {}
    public init(title: String?, style: UIAlertActionStyle, handler: ((NWAAlertAction) -> Void)?)
    {
        self.title = title
        self.style = style
        self.handler = handler
    }
}

// MARK: - NWAAlertController

@available(iOS 9.0, *)
public class NWAAlertController : UIViewController
{
    public var overlayBackgroundColor: UIColor = UIColor.blackColor().colorWithAlphaComponent(0.4)
    public var alertBackgroundColor: UIColor = UIColor(white: 0.97, alpha: 1.0)
    
    public var defaultTitleColor: UIColor?
    public var defaultBackgroundColor: UIColor?
    public var cancelTitleColor: UIColor?
    public var cancelBackgroundColor: UIColor?
    public var destructiveTitleColor: UIColor? = UIColor.redColor()
    public var destructiveBackgroundColor: UIColor?
    
    private var actionMapping: Dictionary<UIButton, NWAAlertAction> = [:]
    
    // Private variables for read only getters.
    private var __preferredStyle: UIAlertControllerStyle
    private var __actions: [NWAAlertAction] = []
    
    // MARK: UIAlertController Public methods
    
    public convenience init(title: String?, message: String?, preferredStyle: UIAlertControllerStyle)
    {
        self.init(preferredStyle: preferredStyle)
        self.message = message
        self.title = title
        
        self.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        self.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
    }
    
    init(preferredStyle: UIAlertControllerStyle)
    {
        self.__preferredStyle = preferredStyle
        super.init(nibName: nil, bundle: nil)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addAction(action: NWAAlertAction)
    {
        __actions += [action]
    }
    
    public var actions: [NWAAlertAction] {
        get {
            return __actions
        }
    }
    
    public var preferredAction: NWAAlertAction?
    
    public func addTextFieldWithConfigurationHandler(configurationHandler: ((UITextField) -> Void)?)
    {
        fatalError("addTextFieldWithConfigurationHandler: has not been implemented yet")
    }
    
    public var textFields: [UITextField]? {
        get {
            print("TextFields are not implemented yet.")
            return nil
        }
    }
    
    public var message: String?
    
    public var preferredStyle: UIAlertControllerStyle {
        get {
            return __preferredStyle
        }
    }
    
    // MARK: Creating the view
    
    public override func loadView()
    {
        let view = UIView(frame: CGRectZero)
        view.backgroundColor = UIColor.clearColor()
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = overlayBackgroundColor
        view.insertSubview(backgroundView, atIndex: 0)
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))

        setupDismissTapGestureRecognizerOnView(backgroundView)
        
        let alertView = alertViewWithTitle(self.title, message: self.message, actions: self.actions)
        alertView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alertView)
        
        alertView.addConstraint(NSLayoutConstraint(item: alertView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 270));
        view.addConstraint(NSLayoutConstraint(item: alertView, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        view.addConstraint(NSLayoutConstraint(item: alertView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        self.view = view
    }
    
    private func alertViewWithTitle(title: String?, message: String?, actions: [NWAAlertAction]) -> UIView
    {
        var subviews: [UIView] = []
        
        if let title = title {
            let label = UILabel(frame: CGRectZero)
            label.textAlignment = NSTextAlignment.Center
            label.text = title
            label.font = UIFont.boldSystemFontOfSize(17)
            subviews += [label]
        }

        if let message = message {
            let label = UILabel(frame: CGRectZero)
            label.textAlignment = NSTextAlignment.Center
            label.text = message
            label.font = UIFont.systemFontOfSize(13)
            label.numberOfLines = 0
            subviews += [label]
        }
        
        for action in actions {
            let button = NWAButton(type: .System)
            button.setTitle(action.title, forState: .Normal)
            button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            subviews += [button]
            actionMapping[button] = action
            
            if action.style == .Default || action.style == .Cancel {
                // We check for .Cancel here as well, in case the user hasn't set .Cancel explicitly. In that case, the color should be the same as in the default case.
                if let color = defaultTitleColor {
                    button.setTitleColor(color, forState: .Normal)
                }
                if let color = defaultBackgroundColor {
                    button.normalBackgroundColor = color
                }
            }
            if action.style == .Cancel {
                // We repeat .Cancel here, in case the user has set this explicitly.
                if let color = cancelTitleColor {
                    button.setTitleColor(color, forState: .Normal)
                }
                if let color = cancelBackgroundColor {
                    button.normalBackgroundColor = color
                }
            }
            if action.style == .Destructive {
                button.setTitleColor(destructiveTitleColor, forState: .Normal)
                if let color = destructiveBackgroundColor {
                    button.normalBackgroundColor = color
                }
            }
        }
        
        let stackView = UIStackView(arrangedSubviews: subviews)
        stackView.userInteractionEnabled = true
        stackView.spacing = 12.0
        stackView.layoutMargins = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        stackView.layoutMarginsRelativeArrangement = true
        stackView.axis = .Vertical
        
        let backgroundView = UIView()
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = alertBackgroundColor
        backgroundView.layer.cornerRadius = 10.0
        stackView.insertSubview(backgroundView, atIndex: 0)
        
        stackView.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Width, relatedBy: .Equal, toItem: stackView, attribute: .Width, multiplier: 1.0, constant: 0.0))
        stackView.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .Height, relatedBy: .Equal, toItem: stackView, attribute: .Height, multiplier: 1.0, constant: 0.0))
        stackView.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .CenterX, relatedBy: .Equal, toItem: stackView, attribute: .CenterX, multiplier: 1.0, constant: 0.0))
        stackView.addConstraint(NSLayoutConstraint(item: backgroundView, attribute: .CenterY, relatedBy: .Equal, toItem: stackView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        return stackView
    }
    
    // MARK: Perform actions and dismiss alert controller
    
    func dismiss()
    {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func buttonTapped(sender: UIButton)
    {
        if let action = actionMapping[sender], let handler = action.handler {
            handler(action)
        }
        dismiss()
    }
    
    private func setupDismissTapGestureRecognizerOnView(view: UIView)
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapGestureRecognizerTriggered:")
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func tapGestureRecognizerTriggered(sender: UITapGestureRecognizer)
    {
        dismiss()
    }
}
