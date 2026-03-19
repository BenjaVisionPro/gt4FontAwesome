"
I am a Magritte description specialized for choosing and rendering Font Awesome icons.

## Responsibilities
- I describe a field whose value is a Font Awesome selector symbol.
- I know which icon library class and style should be used to obtain available icons.
- I provide sizing-related properties used by custom stencil builders.
- I support Magritte visitors so UI builders can render me as an icon selector.

## Example usage
```smalltalk
FontAwesomeIconDescription new
	accessor: #icon;
	label: 'Icon';
	iconLibraryClass: FontAwesomeIcons;
	styleName: 'light';
	yourself
```

I am typically embedded in a Magritte-described object rather than used on my own.
"
Class {
	#name : 'FontAwesomeIconDescription',
	#superclass : 'GtMagritteIconDescription',
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'visiting' }
FontAwesomeIconDescription >> acceptMagritte: aVisitor [
	^ aVisitor visitFontAwesomeIconDescription: self
]

{ #category : 'icons' }
FontAwesomeIconDescription >> applySizingToIconElement: anElement [
	| width height |
	width := self explicitIconWidth.
	height := self explicitIconHeight.

	(width notNil and: [ height notNil ]) ifTrue: [
		^ anElement fitInto: width @ height ].
	width notNil ifTrue: [ ^ anElement width: width ].
	height notNil ifTrue: [ ^ anElement height: height ].
	^ anElement height: self defaultIconHeight
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> availableIconAssociations [
	^ self availableIcons 
		asSortedCollection: [ :a :b | a key asString < b key asString ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> availableIcons [
	^ self iconLibraryClass availableIconsForStyleNamed: self styleName
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> blocStencil [
	^ self propertyAt: #blocStencil ifAbsent: [ FontAwesomeIconStencilBuilder new ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> chooseIconLabel [
	^ self propertyAt: #chooseIconLabel ifAbsent: [ 'Choose icon' ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> chooseIconLabel: aString [
	self propertyAt: #chooseIconLabel put: aString
]

{ #category : 'accessing-defaults' }
FontAwesomeIconDescription >> defaultIconHeight [
	^ 16
]

{ #category : 'accessing-defaults' }
FontAwesomeIconDescription >> defaultSelectorExtent [
	^ 420 @ 320
]

{ #category : 'icons' }
FontAwesomeIconDescription >> displayExtentForIntrinsicExtent: anExtent [
	| width height xScale yScale scale |
	width := self explicitIconWidth.
	height := self explicitIconHeight.

	(width notNil and: [ height notNil ]) ifTrue: [
		((anExtent x isZero) or: [ anExtent y isZero ]) ifTrue: [ ^ width @ height ].
		xScale := width asFloat / anExtent x asFloat.
		yScale := height asFloat / anExtent y asFloat.
		scale := xScale min: yScale.
		^ (anExtent x asFloat * scale) @ (anExtent y asFloat * scale) ].
	width notNil ifTrue: [
		(anExtent x isZero) ifTrue: [ ^ anExtent ].
		^ width @ (anExtent y asFloat * (width asFloat / anExtent x asFloat)) ].
	height notNil ifTrue: [
		(anExtent y isZero) ifTrue: [ ^ anExtent ].
		^ (anExtent x asFloat * (height asFloat / anExtent y asFloat)) @ height ].
	(anExtent y isZero) ifTrue: [ ^ anExtent ].
	^ (anExtent x asFloat * (self defaultIconHeight asFloat / anExtent y asFloat)) @ self defaultIconHeight
]

{ #category : 'private' }
FontAwesomeIconDescription >> explicitIconHeight [
	^ self propertyAt: #iconHeight ifAbsent: [ nil ]
]

{ #category : 'private' }
FontAwesomeIconDescription >> explicitIconWidth [
	^ self propertyAt: #iconWidth ifAbsent: [ nil ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconHeight [
	| explicitHeight |
	explicitHeight := self explicitIconHeight.
	explicitHeight ifNotNil: [ ^ explicitHeight ].
	self explicitIconWidth ifNotNil: [ ^ nil ].
	^ self defaultIconHeight
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconHeight: aNumber [
	self propertyAt: #iconHeight put: aNumber
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconLibraryClass [
	^ self propertyAt: #iconLibraryClass ifAbsent: [ FontAwesomeIcons ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconLibraryClass: aClass [
	self propertyAt: #iconLibraryClass put: aClass
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconSize [
	| width height |
	width := self explicitIconWidth.
	height := self explicitIconHeight.
	(width notNil and: [ height notNil ]) ifTrue: [ ^ width @ height ].
	width notNil ifTrue: [ ^ width ].
	height notNil ifTrue: [ ^ height ].
	^ self defaultIconHeight
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconSize: anObject [
	anObject isPoint
		ifTrue: [
			self iconWidth: anObject x.
			self iconHeight: anObject y ]
		ifFalse: [
			self iconWidth: nil.
			self iconHeight: anObject ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconWidth [
	^ self propertyAt: #iconWidth ifAbsent: [ nil ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> iconWidth: aNumber [
	self propertyAt: #iconWidth put: aNumber
]

{ #category : 'testing' }
FontAwesomeIconDescription >> isFontAwesomeIconDescription [
	^ true
]

{ #category : 'icons' }
FontAwesomeIconDescription >> scaledElementForIcon: aFontAwesomeIcon [
	^ self applySizingToIconElement: aFontAwesomeIcon
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> selectorExtent [
	^ self propertyAt: #selectorExtent ifAbsent: [ self defaultSelectorExtent ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> selectorExtent: anExtent [
	self propertyAt: #selectorExtent put: anExtent
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> styleName [
	^ self propertyAt: #styleName ifAbsent: [ nil ]
]

{ #category : 'accessing' }
FontAwesomeIconDescription >> styleName: aStyleName [
	self propertyAt: #styleName put: aStyleName
]
