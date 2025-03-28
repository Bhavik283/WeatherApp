//
//  CustomButton.swift
//  weatherApp
//
//  Created by Bhavik Goyal on 15/04/24.
//

import Foundation
import UIKit

public class CustomButton: UIButton {
    public enum Size { case zero, small, medium, large }
    public enum Kind { case primary, secondary, tertiary }
    public enum State { case normal, destructive, positive }
    
    override public var isEnabled: Bool {
        didSet {
            if oldValue != isEnabled {
                isUserInteractionEnabled = isEnabled
                alpha = isEnabled ? 1.0 : 0.5
            }
        }
    }
    
    public var pButtonKind: Kind = .primary
    private var pButtonSize: Size = .medium
    private var pButtonState: State = .normal
    private var pButtonImage: String = "play.circle"
    private var pButtonRadius: CGFloat = 0.0
    private var ptext: String = "Button"
    private var height: CGFloat = 50
    private var heightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    private var contentView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.isUserInteractionEnabled = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private var labelText: UILabel = {
        let label = UILabel()
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private var buttonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    public func setKindValue(_ kind: Kind){
        if(pButtonKind != kind){
            pButtonKind = kind
            configure(change: true, changeSize: false, changeImage: false, changeRadius: false, changeText: false)
        }
    }
    
    public func setStateValue(_ state: State){
        if(pButtonState != state){
            pButtonState = state
            configure(change: true, changeSize: false, changeImage: false, changeRadius: false, changeText: false)
        }
    }
    
    public func setSizeValue(_ size: Size) {
        if pButtonSize != size {
            pButtonSize = size
            configure(change: false, changeSize: true, changeImage: false, changeRadius: false, changeText: false)
        }
    }
    
    public func setImageValue(_ image: String){
        if (image != pButtonImage){
            pButtonImage = image
            configure(change: false, changeSize: false, changeImage: true, changeRadius: false, changeText: false)
        }
    }
    
    public func setRadiusValue(_ value: CGFloat){
        if (value != pButtonRadius){
            pButtonRadius = value
            configure(change: false, changeSize: false, changeImage: false, changeRadius: true, changeText: false)
        }
    }
    
    public func setTextValue(_ text: String){
        ptext = text
        setAccessibility()
        configure(change: false, changeSize: false, changeImage: false, changeRadius: false, changeText: true)
    }
    
    private func configure(change: Bool, changeSize: Bool, changeImage: Bool, changeRadius: Bool, changeText: Bool){
        if(changeRadius){
            layer.cornerRadius = (pButtonRadius * height)/100
        }
        if(changeText){
            labelText.text = ptext
        }
        if(changeSize){
            switch pButtonSize {
                case .zero:
                    height = 0
                case .small:
                    height = 30
                case .medium:
                    height = 50
                case .large:
                    height = 70
                }
            
            heightConstraint.constant = height
            layer.cornerRadius = (pButtonRadius * height)/100
        }
        if(changeImage){
            buttonImage.image = UIImage(systemName: pButtonImage)
        }
        if(change){
            switch pButtonKind {
                case .primary:
                    layer.borderWidth = 0
                    switch pButtonState {
                    case .normal:
                        backgroundColor = .blue
                        labelText.textColor = .white
                        buttonImage.tintColor = .white
                    case .destructive:
                        backgroundColor = .red
                        labelText.textColor = .brown
                        buttonImage.tintColor = .brown
                    case .positive:
                        backgroundColor = .green
                        labelText.textColor = .systemTeal
                        buttonImage.tintColor = .systemTeal
                    }
                case .secondary, .tertiary:
                    layer.borderWidth = (pButtonKind == .secondary) ? 1 : 0
                    backgroundColor = .clear
                        
                    switch pButtonState {
                    case .normal:
                        labelText.textColor = .blue
                        buttonImage.tintColor = .blue
                    case .destructive:
                        labelText.textColor = .brown
                        buttonImage.tintColor = .brown
                    case .positive:
                        labelText.textColor = .systemTeal
                        buttonImage.tintColor = .systemTeal
                    }
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addArrangedSubview(buttonImage)
        contentView.addArrangedSubview(labelText)
        addSubview(contentView)
        heightConstraint = contentView.heightAnchor.constraint(equalToConstant: height)
        heightConstraint.isActive = true
        applyConstraints()
        accessibilityElements = [labelText, buttonImage]
        configure(change: true, changeSize: true, changeImage: true, changeRadius: true, changeText: true)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = true
        isUserInteractionEnabled = true
    }
}

extension CustomButton {
    private func applyConstraints(){
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }
    
    private func setAccessibility() {
        accessibilityLabel = ptext
        accessibilityIdentifier = "customButton"
    }
}
