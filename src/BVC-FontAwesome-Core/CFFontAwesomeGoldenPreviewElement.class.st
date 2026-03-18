Class {
	#name : 'CFFontAwesomeGoldenPreviewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconMetadata',
		'styleName',
		'root',
		'leftCell',
		'rightColumn',
		'topRow',
		'topMiddleColumn',
		'lowerBandRow',
		'smallColumn',
		'topMiddleCell',
		'mediumCell',
		'smallTopCell',
		'smallBottomCell',
		'topRightCell',
		'bottomRightCell',
		'lastLaidOutWidth'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'instance creation' }
CFFontAwesomeGoldenPreviewElement class >> forMetadata: anIconMetadata styleName: aStyleName [
	^ self new
		iconMetadata: anIconMetadata;
		styleName: aStyleName;
		yourself
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> applyCellMetadataAndStyle [
	{
		leftCell.
		topMiddleCell.
		mediumCell.
		smallTopCell.
		smallBottomCell.
		topRightCell.
		bottomRightCell }
		do: [ :each |
			each
				iconMetadata: iconMetadata;
				styleName: styleName ]
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> buildLayout [
	root := BrHorizontalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	leftCell := self newPreviewCell.
	leftCell constraintsDo: [ :c |
		c vertical matchParent.
		c linear weight: self goldenRatio ].

	rightColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c vertical matchParent.
			c linear weight: 1 ];
		yourself.

	topRow := BrHorizontalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c linear weight: 1 ];
		yourself.

	topMiddleColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c vertical matchParent.
			c linear weight: 1 ];
		yourself.

	lowerBandRow := BrHorizontalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c linear weight: 1 ];
		yourself.

	smallColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c vertical matchParent.
			c linear weight: 1 ];
		yourself.

	topMiddleCell := self newPreviewCell.
	topMiddleCell constraintsDo: [ :c |
		c horizontal matchParent.
		c linear weight: self goldenRatio ].

	mediumCell := self newPreviewCell.
	mediumCell constraintsDo: [ :c |
		c vertical matchParent.
		c linear weight: self goldenRatio ].

	smallTopCell := self newPreviewCell.
	smallTopCell constraintsDo: [ :c |
		c horizontal matchParent.
		c linear weight: 1 ].

	smallBottomCell := self newPreviewCell.
	smallBottomCell constraintsDo: [ :c |
		c horizontal matchParent.
		c linear weight: self goldenRatio ].

	topRightCell := self newPreviewCell.
	topRightCell constraintsDo: [ :c |
		c vertical matchParent.
		c linear weight: self goldenRatio ].

	bottomRightCell := self newPreviewCell.
	bottomRightCell constraintsDo: [ :c |
		c horizontal matchParent.
		c linear weight: self goldenRatio ].

	smallColumn addChildren: { smallTopCell. smallBottomCell }.
	lowerBandRow addChildren: { mediumCell. smallColumn }.
	topMiddleColumn addChildren: { topMiddleCell. lowerBandRow }.
	topRow addChildren: { topMiddleColumn. topRightCell }.
	rightColumn addChildren: { topRow. bottomRightCell }.
	root addChildren: { leftCell. rightColumn }.
	self addChild: root.
	self applyCellMetadataAndStyle
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> goldenRatio [
	^ 1.61803398875
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewElement >> iconMetadata [
	^ iconMetadata
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewElement >> iconMetadata: anIconMetadata [
	iconMetadata := anIconMetadata.
	self applyCellMetadataAndStyle
]

{ #category : 'initialization' }
CFFontAwesomeGoldenPreviewElement >> initialize [
	super initialize.
	self
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 0);
		when: BlElementExtentChangedEvent do: [ :anEvent | self layoutForCurrentWidth ].
	self buildLayout
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> layoutForCurrentWidth [
	| currentWidth desiredHeight |
	currentWidth := self extent x.
	currentWidth <= 0 ifTrue: [ ^ self ].
	lastLaidOutWidth = currentWidth ifTrue: [ ^ self ].

	lastLaidOutWidth := currentWidth.
	desiredHeight := currentWidth / self goldenRatio.
	root constraintsDo: [ :c |
		c horizontal matchParent.
		c vertical exact: desiredHeight ]
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> previewDebugBorder [
	^ BlBorder paint: (Color blue alpha: 0.6) width: 1
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> newPreviewCell [
	^ (CFFontAwesomeGoldenPreviewCellElement
		forMetadata: iconMetadata
		styleName: styleName)
			yourself
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewElement >> styleName [
	^ styleName
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewElement >> styleName: aStyleName [
	styleName := aStyleName.
	self applyCellMetadataAndStyle
]
