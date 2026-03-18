Class {
	#name : 'CFFontAwesomeGoldenPreviewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconMetadata',
		'styleName',
		'root',
		'leftCell',
		'rightColumn',
		'topCompositeRow',
		'leftCompositeColumn',
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
			c horizontal exact: 0.
			c vertical exact: 0 ];
		yourself.

	leftCell := self newPreviewCell.
	rightColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: 0.
			c vertical exact: 0 ];
		yourself.

	topCompositeRow := BrHorizontalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: 0.
			c vertical exact: 0 ];
		yourself.

	leftCompositeColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: 0.
			c vertical exact: 0 ];
		yourself.

	lowerBandRow := BrHorizontalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: 0.
			c vertical exact: 0 ];
		yourself.

	smallColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: 0.
			c vertical exact: 0 ];
		yourself.

	topMiddleCell := self newPreviewCell.
	mediumCell := self newPreviewCell.
	smallTopCell := self newPreviewCell.
	smallBottomCell := self newPreviewCell.
	topRightCell := self newPreviewCell.
	bottomRightCell := self newPreviewCell.

	smallColumn addChildren: { smallTopCell. smallBottomCell }.
	lowerBandRow addChildren: { mediumCell. smallColumn }.
	leftCompositeColumn addChildren: { topMiddleCell. lowerBandRow }.
	topCompositeRow addChildren: { leftCompositeColumn. topRightCell }.
	rightColumn addChildren: { topCompositeRow. bottomRightCell }.
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
	| bottomHeight currentWidth desiredHeight leftCompositeWidth leftWidth lowerBandHeight mediumWidth rightWidth smallBottomHeight smallColumnWidth smallTopHeight topCompositeHeight topMiddleHeight topRightWidth |
	currentWidth := self extent x asFloat.
	currentWidth <= 0 ifTrue: [ ^ self ].
	lastLaidOutWidth = currentWidth ifTrue: [ ^ self ].

	lastLaidOutWidth := currentWidth.
	desiredHeight := currentWidth / self goldenRatio.

	leftWidth := desiredHeight.
	rightWidth := currentWidth - leftWidth.
	bottomHeight := rightWidth.
	topCompositeHeight := desiredHeight - bottomHeight.
	topRightWidth := topCompositeHeight.
	leftCompositeWidth := rightWidth - topRightWidth.
	topMiddleHeight := leftCompositeWidth.
	lowerBandHeight := topCompositeHeight - topMiddleHeight.
	mediumWidth := lowerBandHeight.
	smallColumnWidth := leftCompositeWidth - mediumWidth.
	smallBottomHeight := smallColumnWidth.
	smallTopHeight := lowerBandHeight - smallBottomHeight.

	root constraintsDo: [ :c |
		c horizontal exact: currentWidth.
		c vertical exact: desiredHeight ].
	leftCell constraintsDo: [ :c |
		c horizontal exact: leftWidth.
		c vertical exact: desiredHeight ].
	rightColumn constraintsDo: [ :c |
		c horizontal exact: rightWidth.
		c vertical exact: desiredHeight ].
	topCompositeRow constraintsDo: [ :c |
		c horizontal exact: rightWidth.
		c vertical exact: topCompositeHeight ].
	leftCompositeColumn constraintsDo: [ :c |
		c horizontal exact: leftCompositeWidth.
		c vertical exact: topCompositeHeight ].
	topMiddleCell constraintsDo: [ :c |
		c horizontal exact: leftCompositeWidth.
		c vertical exact: topMiddleHeight ].
	lowerBandRow constraintsDo: [ :c |
		c horizontal exact: leftCompositeWidth.
		c vertical exact: lowerBandHeight ].
	mediumCell constraintsDo: [ :c |
		c horizontal exact: mediumWidth.
		c vertical exact: lowerBandHeight ].
	smallColumn constraintsDo: [ :c |
		c horizontal exact: smallColumnWidth.
		c vertical exact: lowerBandHeight ].
	smallTopCell constraintsDo: [ :c |
		c horizontal exact: smallColumnWidth.
		c vertical exact: smallTopHeight ].
	smallBottomCell constraintsDo: [ :c |
		c horizontal exact: smallColumnWidth.
		c vertical exact: smallBottomHeight ].
	topRightCell constraintsDo: [ :c |
		c horizontal exact: topRightWidth.
		c vertical exact: topCompositeHeight ].
	bottomRightCell constraintsDo: [ :c |
		c horizontal exact: rightWidth.
		c vertical exact: bottomHeight ]
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> newPreviewCell [
	^ CFFontAwesomeGoldenPreviewCellElement
		forMetadata: iconMetadata
		styleName: styleName
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> previewDebugBorder [
	^ BlBorder paint: (Color blue alpha: 0.6) width: 1
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
