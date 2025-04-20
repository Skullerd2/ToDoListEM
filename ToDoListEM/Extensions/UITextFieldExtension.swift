import UIKit

extension UITextField {
    func setPlaceholder(_ placeholderText: String, leftIcon: UIImage? = nil, rightIcon: UIImage? = nil, padding: CGFloat = 16) {
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding + (leftIcon == nil ? 0 : 24), height: self.frame.height))
        self.leftView = leftPaddingView
        self.leftViewMode = .always
        
        if let leftIcon = leftIcon {
            let leftIconView = UIImageView(frame: CGRect(x: padding, y: 0, width: 20, height: 20))
            leftIconView.image = leftIcon
            leftIconView.contentMode = .scaleAspectFit
            leftIconView.tintColor = .fromHex("8E8E8F")
            leftPaddingView.addSubview(leftIconView)
            leftIconView.center.y = leftPaddingView.center.y
        }
        
        let rightPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding + (rightIcon == nil ? 0 : 24) , height: self.frame.height))
        self.rightView = rightPaddingView
        self.rightViewMode = .always
        
        if let rightIcon = rightIcon {
            let rightIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            rightIconView.image = rightIcon
            rightIconView.contentMode = .scaleAspectFit
            rightIconView.tintColor = .fromHex("8E8E8F")
            rightPaddingView.addSubview(rightIconView)
            rightIconView.center = rightPaddingView.center
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.fromHex("8E8E8F"),
            .paragraphStyle: {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.firstLineHeadIndent = 0
                return paragraphStyle
            }()
        ]
        self.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
    }
}

