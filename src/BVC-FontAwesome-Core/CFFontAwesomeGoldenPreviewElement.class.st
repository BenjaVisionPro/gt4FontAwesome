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
		size: 0 @ 0;
		yourself.

	leftCell := self newPreviewCell.
	rightColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		size: 0 @ 0;
		yourself.

	topCompositeRow := BrHorizontalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		size: 0 @ 0;
		yourself.

	leftCompositeColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		size: 0 @ 0;
		yourself.

	lowerBandRow := BrHorizontalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		size: 0 @ 0;
		yourself.

	smallColumn := BrVerticalPane new
		border: self previewDebugBorder;
		cellSpacing: 0;
		size: 0 @ 0;
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
	self applyCellMetadataAndStyle.
	lastLaidOutWidth ifNotNil: [ self refreshCells ]
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
		when: BlElementExtentChangedEvent do: [ :anEvent | self layoutForCurrentWidth ].
	self buildLayout
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> layoutForCurrentWidth [
	| bottomHeight leftCompositeWidth leftWidth lowerBandHeight mediumWidth panelHeight panelWidth rightWidth smallBottomHeight smallColumnWidth smallTopHeight topCompositeHeight topMiddleHeight topRightWidth |
	panelWidth := self extent x asFloat.
	panelWidth <= 0 ifTrue: [ ^ self ].
	lastLaidOutWidth = panelWidth ifTrue: [ ^ self ].

	lastLaidOutWidth := panelWidth.
	panelHeight := panelWidth / self goldenRatio.

	leftWidth := panelHeight.
	rightWidth := panelWidth - leftWidth.
	bottomHeight := rightWidth.
	topCompositeHeight := panelHeight - bottomHeight.
	topRightWidth := topCompositeHeight.
	leftCompositeWidth := rightWidth - topRightWidth.
	topMiddleHeight := leftCompositeWidth.
	lowerBandHeight := topCompositeHeight - topMiddleHeight.
	mediumWidth := lowerBandHeight.
	smallColumnWidth := leftCompositeWidth - mediumWidth.
	smallBottomHeight := smallColumnWidth.
	smallTopHeight := lowerBandHeight - smallBottomHeight.

	root size: panelWidth @ panelHeight.
	leftCell size: leftWidth @ panelHeight.
	rightColumn size: rightWidth @ panelHeight.
	topCompositeRow size: rightWidth @ topCompositeHeight.
	leftCompositeColumn size: leftCompositeWidth @ topCompositeHeight.
	topMiddleCell size: leftCompositeWidth @ topMiddleHeight.
	lowerBandRow size: leftCompositeWidth @ lowerBandHeight.
	mediumCell size: mediumWidth @ lowerBandHeight.
	smallColumn size: smallColumnWidth @ lowerBandHeight.
	smallTopCell size: smallColumnWidth @ smallTopHeight.
	smallBottomCell size: smallColumnWidth @ smallBottomHeight.
	topRightCell size: topRightWidth @ topCompositeHeight.
	bottomRightCell size: rightWidth @ bottomHeight.

	root forceLayout.
	self refreshCells
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> newPreviewCell [
	^ CFFontAwesomeGoldenPreviewCellElement
		forMetadata: iconMetadata
		styleName: styleName
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> previewDebugBorder [
	^ BlBorder paint: (Color blue alpha: 0.6) width: 0
]

{ #category : 'private' }
CFFontAwesomeGoldenPreviewElement >> refreshCells [
	{
		leftCell.
		topMiddleCell.
		mediumCell.
		smallTopCell.
		smallBottomCell.
		topRightCell.
		bottomRightCell }
		do: [ :each | each refreshIcon ]
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewElement >> styleName [
	^ styleName
]

{ #category : 'accessing' }
CFFontAwesomeGoldenPreviewElement >> styleName: aStyleName [
	styleName := aStyleName.
	self applyCellMetadataAndStyle.
	lastLaidOutWidth ifNotNil: [ self refreshCells ]
]
