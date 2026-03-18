Class {
	#name : 'FontAwesomeSpotterPreviewCellElement',
	#superclass : 'BrFrame',
	#instVars : [
		'iconMetadata',
		'styleName',
		'iconElement',
		'isIconVisible'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'instance creation' }
FontAwesomeSpotterPreviewCellElement class >> forMetadata: anIconMetadata styleName: aStyleName [
	^ self new
		iconMetadata: anIconMetadata;
		styleName: aStyleName;
		yourself
]

{ #category : 'accessing' }
FontAwesomeSpotterPreviewCellElement >> iconMetadata [
	^ iconMetadata
]

{ #category : 'accessing' }
FontAwesomeSpotterPreviewCellElement >> iconMetadata: anIconMetadata [
	iconMetadata := anIconMetadata.
	iconElement := nil.
	self removeChildren.
	isIconVisible := false
]

{ #category : 'private' }
FontAwesomeSpotterPreviewCellElement >> iconPadding [
	^ 4
]

{ #category : 'initialization' }
FontAwesomeSpotterPreviewCellElement >> initialize [
	super initialize.
	isIconVisible := false.
	self
		border: self previewDebugBorder;
		layout: BlFrameLayout new;
		when: BlElementExtentChangedEvent do: [ :anEvent | self refreshIcon ]
]

{ #category : 'private' }
FontAwesomeSpotterPreviewCellElement >> minimumIconExtent [
	^ 12
]

{ #category : 'private' }
FontAwesomeSpotterPreviewCellElement >> newIconElement [
	| icon |
	icon := iconMetadata iconLibraryClass
		icon: iconMetadata selectorSymbol
		styleName: styleName.
	icon color: Color black.
	icon constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	^ icon
]

{ #category : 'private' }
FontAwesomeSpotterPreviewCellElement >> previewDebugBorder [
	^ BlBorder paint: (Color red alpha: 0.6) width: 0
]

{ #category : 'private' }
FontAwesomeSpotterPreviewCellElement >> refreshIcon [
	| availableExtent paddingInset |
	(iconMetadata isNil or: [ styleName isNil ])
		ifTrue: [ self removeChildren.
			iconElement := nil.
			isIconVisible := false.
			^ self ].
	paddingInset := (self iconPadding * 2) @ (self iconPadding * 2).
	availableExtent := self extent - paddingInset.
	(availableExtent x <= 0 or: [ availableExtent y <= 0 ])
		ifTrue: [ self removeChildren.
			isIconVisible := false.
			^ self ].

	(availableExtent x min: availableExtent y) < self minimumIconExtent
		ifTrue: [ isIconVisible
				ifTrue: [ self removeChildren.
					isIconVisible := false ].
			^ self ].

	iconElement ifNil: [ iconElement := self newIconElement ].
	iconElement fitInto: availableExtent.

	isIconVisible
		ifFalse: [ self addChild: iconElement.
			isIconVisible := true ]
]

{ #category : 'accessing' }
FontAwesomeSpotterPreviewCellElement >> styleName [
	^ styleName
]

{ #category : 'accessing' }
FontAwesomeSpotterPreviewCellElement >> styleName: aStyleName [
	styleName := aStyleName.
	iconElement := nil.
	self removeChildren.
	isIconVisible := false
]
