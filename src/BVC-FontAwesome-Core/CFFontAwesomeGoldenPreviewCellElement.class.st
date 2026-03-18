Class {
	#name : 'CFFontAwesomeGoldenPreviewCellElement',
	#superclass : 'BrFrame',
	#instVars : [
		'iconMetadata',
		'styleName',
		'iconElement',
		'isIconVisible'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'instance creation' }
CFFontAwesomeGoldenPreviewCellElement class >> forMetadata: anIconMetadata styleName: aStyleName [
	^ self new
		iconMetadata: anIconMetadata;
		styleName: aStyleName;
		yourself
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewCellElement >> iconMetadata [
	^ iconMetadata
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewCellElement >> iconMetadata: anIconMetadata [
	iconMetadata := anIconMetadata.
	iconElement := nil.
	self removeChildren.
	isIconVisible := false.
	self refreshIcon
]

{ #category : 'initialization' }
CFFontAwesomeGoldenPreviewCellElement >> initialize [
	super initialize.
	isIconVisible := false.
	self
		border: self previewDebugBorder;
		layout: BlFrameLayout new;
		padding: (BlInsets all: 0);
		when: BlElementExtentChangedEvent do: [ :anEvent | self refreshIcon ]
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewCellElement >> minimumIconExtent [
	^ 12
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewCellElement >> newIconElement [
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
CFFontAwesomeGoldenPreviewCellElement >> previewDebugBorder [
	^ BlBorder paint: (Color red alpha: 0.6) width: 1
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewCellElement >> refreshIcon [
	| currentExtent |
	(iconMetadata isNil or: [ styleName isNil ]) ifTrue: [
		self removeChildren.
		iconElement := nil.
		isIconVisible := false.
		^ self ].

	currentExtent := self extent.
	((currentExtent x <= 0) or: [ currentExtent y <= 0 ]) ifTrue: [ ^ self ].

	(currentExtent x min: currentExtent y) < self minimumIconExtent
		ifTrue: [
			isIconVisible ifTrue: [
				self removeChildren.
				isIconVisible := false ].
			^ self ].

	iconElement ifNil: [
		iconElement := self newIconElement ].
	iconElement fitInto: currentExtent.

	isIconVisible ifFalse: [
		self addChild: iconElement.
		isIconVisible := true ]
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewCellElement >> styleName [
	^ styleName
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewCellElement >> styleName: aStyleName [
	styleName := aStyleName.
	iconElement := nil.
	self removeChildren.
	isIconVisible := false.
	self refreshIcon
]
