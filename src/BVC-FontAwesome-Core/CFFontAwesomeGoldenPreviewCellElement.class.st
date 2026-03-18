Class {
	#name : 'CFFontAwesomeGoldenPreviewCellElement',
	#superclass : 'BrFrame',
	#instVars : [
		'iconMetadata',
		'styleName',
		'lastRenderedExtent',
		'lastRenderedStyleName'
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
	lastRenderedExtent := nil.
	self refreshIcon
]

{ #category : 'initialization' }
CFFontAwesomeGoldenPreviewCellElement >> initialize [
	super initialize.
	self
		layout: BlFrameLayout new;
		padding: (BlInsets all: 0);
		when: BlElementExtentChangedEvent do: [ :anEvent | self refreshIcon ]
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewCellElement >> minimumIconExtent [
	^ 12
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewCellElement >> newIconFitting: anExtent [
	| icon |
	icon := CFMaFontAwesomeBuilderUtility
		newFontAwesomeIconForMetadata: iconMetadata
		styleName: styleName
		fitInto: anExtent.
	icon constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	^ icon
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewCellElement >> refreshIcon [
	| currentExtent |
	(iconMetadata isNil or: [ styleName isNil ]) ifTrue: [
		self removeChildren.
		^ self ].

	currentExtent := self extent.
	((currentExtent x <= 0) or: [ currentExtent y <= 0 ]) ifTrue: [
		self removeChildren.
		^ self ].

	((lastRenderedExtent = currentExtent)
		and: [ lastRenderedStyleName = styleName ]) ifTrue: [ ^ self ].

	lastRenderedExtent := currentExtent.
	lastRenderedStyleName := styleName.
	self removeChildren.

	(currentExtent x min: currentExtent y) < self minimumIconExtent ifTrue: [ ^ self ].
	self addChild: (self newIconFitting: currentExtent)
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewCellElement >> styleName [
	^ styleName
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewCellElement >> styleName: aStyleName [
	styleName := aStyleName.
	lastRenderedStyleName := nil.
	self refreshIcon
]
