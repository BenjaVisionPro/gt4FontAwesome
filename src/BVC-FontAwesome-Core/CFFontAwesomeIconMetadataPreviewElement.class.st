Class {
	#name : 'CFFontAwesomeIconMetadataPreviewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconMetadata',
		'currentStyleName',
		'samplesContainer',
		'renderedSamplesWidth',
		'previewRoot',
		'previewLargeCell',
		'previewTopMiddleCell',
		'previewMediumCell',
		'previewSmallTopCell',
		'previewSmallBottomCell',
		'previewTopRightCell',
		'previewBottomRightCell',
		'previewRightColumn',
		'previewTopRow',
		'previewTopMiddleColumn',
		'previewLowerBandRow',
		'previewSmallColumn'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'instance creation' }
CFFontAwesomeIconMetadataPreviewElement class >> forMetadata: anIconMetadata [
	^ self new
		iconMetadata: anIconMetadata;
		yourself
]

{ #category : 'initialization' }
CFFontAwesomeIconMetadataPreviewElement >> buildPreview [
	| details previewSection styleToggleGroup |
	self removeChildren.
	renderedSamplesWidth := nil.

	currentStyleName := iconMetadata preferredStyleName.

	previewSection := BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		border: self previewDebugBorder;
		yourself.

	samplesContainer := BrFrame new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		border: self previewDebugBorder;
		yourself.
	self buildSamplesPreview.
	self refreshSamples.

	styleToggleGroup := self newStyleToggleGroup.
	styleToggleGroup constraintsDo: [ :c |
		c linear horizontal alignCenter ].
	previewSection addChildren: { styleToggleGroup. samplesContainer }.

	details := BrVerticalPane new
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		border: self previewDebugBorder;
		yourself.
	details addChildren: {
		(self newDetailRowLabel: 'Selector' value: iconMetadata selectorSymbol asString).
		(self newDetailRowLabel: 'FA name' value: (iconMetadata fontAwesomeName ifNil: [ '' ])).
		(self newDetailRowLabel: 'Categories' value: (' , ' join: iconMetadata categories)).
		(self newDetailRowLabel: 'Search' value: (' , ' join: (iconMetadata searchTerms collect: #asString))) }.

	self addChildren: { previewSection. details }
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadataPreviewElement >> iconMetadata [
	^ iconMetadata
]

{ #category : 'accessing' }
CFFontAwesomeIconMetadataPreviewElement >> iconMetadata: anIconMetadata [
	iconMetadata := anIconMetadata.
	self buildPreview
]

{ #category : 'initialization' }
CFFontAwesomeIconMetadataPreviewElement >> initialize [
	super initialize.
	self
		cellSpacing: 4;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		padding: (BlInsets all: 0);
		when: BlElementExtentChangedEvent do: [ :anEvent | self refreshSamplesForExtentChange ]
]

{ #category : 'private - geometry' }
CFFontAwesomeIconMetadataPreviewElement >> goldenRatio [
	^ 1.61803398875
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newDetailRowLabel: aLabel value: aValue [
	^ self
		newDetailRowLabel: aLabel
		content: (BrLabel new
				aptitude: BrGlamorousLabelAptitude;
				text: aValue;
				constraintsDo: [ :c |
					c horizontal matchParent.
					c vertical fitContent ];
				yourself)
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newDetailRowLabel: aLabel content: aContentElement [
	| row keyLabel |
	row := BrHorizontalPane new
		cellSpacing: 8;
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		yourself.

	keyLabel := BrLabel new
		aptitude: BrLabelAptitude new;
		text: aLabel;
		opacity: 0.6;
		constraintsDo: [ :c |
			c horizontal exact: 92.
			c vertical fitContent ];
		yourself.

	row addChildren: { keyLabel. aContentElement }.
	^ row
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> buildSamplesPreview [
	previewRoot := BrHorizontalPane new
		cellSpacing: 0;
		border: self previewDebugBorder;
		yourself.

	previewLargeCell := self newPreviewCell.
	previewRightColumn := BrVerticalPane new
		cellSpacing: 0;
		border: self previewDebugBorder;
		yourself.
	previewTopRow := BrHorizontalPane new
		cellSpacing: 0;
		border: self previewDebugBorder;
		yourself.
	previewTopMiddleColumn := BrVerticalPane new
		cellSpacing: 0;
		border: self previewDebugBorder;
		yourself.
	previewLowerBandRow := BrHorizontalPane new
		cellSpacing: 0;
		border: self previewDebugBorder;
		yourself.
	previewSmallColumn := BrVerticalPane new
		cellSpacing: 0;
		border: self previewDebugBorder;
		yourself.

	previewTopMiddleCell := self newPreviewCell.
	previewMediumCell := self newPreviewCell.
	previewSmallTopCell := self newPreviewCell.
	previewSmallBottomCell := self newPreviewCell.
	previewTopRightCell := self newPreviewCell.
	previewBottomRightCell := self newPreviewCell.

	previewSmallColumn addChildren: { previewSmallTopCell. previewSmallBottomCell }.
	previewLowerBandRow addChildren: { previewMediumCell. previewSmallColumn }.
	previewTopMiddleColumn addChildren: { previewTopMiddleCell. previewLowerBandRow }.
	previewTopRow addChildren: { previewTopMiddleColumn. previewTopRightCell }.
	previewRightColumn addChildren: { previewTopRow. previewBottomRightCell }.
	previewRoot addChildren: { previewLargeCell. previewRightColumn }.

	samplesContainer addChild: previewRoot
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newPreviewCell [
	^ BrFrame new
		padding: (BlInsets all: 0);
		layout: BlFrameLayout new;
		border: self previewDebugBorder;
		yourself
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newStyleToggleFor: aStyleName [
	| toggle |
	toggle := BrToggle new
		aptitude: BrGlamorousToggleWithIconAptitude new;
		icon: (CFMaFontAwesomeBuilderUtility
				newFontAwesomeIconForMetadata: iconMetadata
				styleName: aStyleName
				fitInto: 14 @ 14);
		label: aStyleName capitalized;
		when: BrToggleActivatedEvent
			do: [ :anEvent | self onStyleActivated: anEvent model ];
		yourself.
	toggle viewModel model: aStyleName.
	aStyleName = currentStyleName ifTrue: [ toggle activate ].
	^ toggle
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newStyleToggleGroup [
	| toggleGroup |
	toggleGroup := BrToggleGroup new
		aptitude: BrGlamorousToggleGroupAptitude new;
		yourself.
	iconMetadata styles do: [ :eachStyleName |
		toggleGroup addToggle: (self newStyleToggleFor: eachStyleName) ].
	^ toggleGroup
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> onStyleActivated: aStyleName [
	currentStyleName := aStyleName.
	renderedSamplesWidth := nil.
	self refreshSamples
]

{ #category : 'private - geometry' }
CFFontAwesomeIconMetadataPreviewElement >> minimumPreviewIconExtent [
	^ 12
]

{ #category : 'private - styling' }
CFFontAwesomeIconMetadataPreviewElement >> previewDebugBorder [
	^ BlBorder paint: (Color blue alpha: 0.45) width: 1
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> refreshSamples [
	| availableWidth |
	samplesContainer ifNil: [ ^ self ].
	availableWidth := self samplesWidth.
	availableWidth <= 0 ifTrue: [ ^ self ].

	renderedSamplesWidth := availableWidth.
	self
		updatePreviewLayoutForWidth: availableWidth;
		updatePreviewIconsForStyleName: currentStyleName.
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> refreshSamplesForExtentChange [
	| availableWidth |
	availableWidth := self samplesWidth.
	availableWidth <= 0 ifTrue: [ ^ self ].
	availableWidth = renderedSamplesWidth ifTrue: [ ^ self ].
	self refreshSamples
]

{ #category : 'private - geometry' }
CFFontAwesomeIconMetadataPreviewElement >> samplesWidth [
	| width |
	width := self extent x rounded.
	width > 0 ifTrue: [ ^ width ].
	samplesContainer ifNil: [ ^ 0 ].
	^ samplesContainer extent x rounded
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> updatePreviewCell: aCell width: aWidth height: aHeight styleName: aStyleName [
	| contentExtent icon |
	aCell constraintsDo: [ :c |
		c horizontal exact: (aWidth max: 0).
		c vertical exact: (aHeight max: 0) ].

	contentExtent := (aWidth max: 0) @ (aHeight max: 0).
	aCell removeChildren.
	(contentExtent x min: contentExtent y) < self minimumPreviewIconExtent ifTrue: [ ^ self ].

	icon := CFMaFontAwesomeBuilderUtility
		newFontAwesomeIconForMetadata: iconMetadata
		styleName: aStyleName
		fitInto: contentExtent.
	icon constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	aCell addChild: icon
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> updatePreviewIconsForStyleName: aStyleName [
	| bottomHeight height leftWidth lowerBandHeight mediumWidth rightWidth smallBottomHeight smallColumnWidth smallTopHeight topHeight topMiddleHeight topMiddleWidth topRightWidth |
	renderedSamplesWidth ifNil: [ ^ self ].

	height := (renderedSamplesWidth / self goldenRatio) floor.
	height <= 0 ifTrue: [ ^ self ].

	leftWidth := height min: renderedSamplesWidth.
	rightWidth := renderedSamplesWidth - leftWidth.
	bottomHeight := rightWidth.
	topHeight := (height - bottomHeight) max: 0.
	topRightWidth := topHeight max: 0.

	rightWidth <= 0 ifTrue: [
		self updatePreviewCell: previewLargeCell width: renderedSamplesWidth height: height styleName: aStyleName.
		^ self ].

	topMiddleWidth := (rightWidth - topRightWidth) max: 0.
	topMiddleHeight := topMiddleWidth.
	lowerBandHeight := (topHeight - topMiddleHeight) max: 0.
	mediumWidth := lowerBandHeight.
	smallColumnWidth := (topMiddleHeight - mediumWidth) max: 0.
	smallBottomHeight := smallColumnWidth.
	smallTopHeight := (lowerBandHeight - smallBottomHeight) max: 0.

	self updatePreviewCell: previewLargeCell width: leftWidth height: height styleName: aStyleName.
	self updatePreviewCell: previewTopMiddleCell width: topMiddleWidth height: topMiddleHeight styleName: aStyleName.
	self updatePreviewCell: previewMediumCell width: mediumWidth height: lowerBandHeight styleName: aStyleName.
	self updatePreviewCell: previewSmallTopCell width: smallColumnWidth height: smallTopHeight styleName: aStyleName.
	self updatePreviewCell: previewSmallBottomCell width: smallColumnWidth height: smallBottomHeight styleName: aStyleName.
	self updatePreviewCell: previewTopRightCell width: topRightWidth height: topHeight styleName: aStyleName.
	self updatePreviewCell: previewBottomRightCell width: rightWidth height: bottomHeight styleName: aStyleName
]

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> updatePreviewLayoutForWidth: aWidth [
	| bottomHeight height leftWidth lowerBandHeight mediumWidth rightWidth smallBottomHeight smallColumnWidth smallTopHeight topHeight topMiddleHeight topMiddleWidth topRightWidth |
	height := (aWidth / self goldenRatio) floor.
	height <= 0 ifTrue: [ ^ self ].

	leftWidth := height min: aWidth.
	rightWidth := aWidth - leftWidth.
	bottomHeight := rightWidth.
	topHeight := (height - bottomHeight) max: 0.
	topRightWidth := topHeight max: 0.
	topMiddleWidth := (rightWidth - topRightWidth) max: 0.
	topMiddleHeight := topMiddleWidth.
	lowerBandHeight := (topHeight - topMiddleHeight) max: 0.
	mediumWidth := lowerBandHeight.
	smallColumnWidth := (topMiddleHeight - mediumWidth) max: 0.
	smallBottomHeight := smallColumnWidth.
	smallTopHeight := (lowerBandHeight - smallBottomHeight) max: 0.

	previewRoot constraintsDo: [ :c |
		c horizontal exact: aWidth.
		c vertical exact: height ].
	previewLargeCell constraintsDo: [ :c |
		c horizontal exact: leftWidth.
		c vertical exact: height ].
	previewRightColumn constraintsDo: [ :c |
		c horizontal exact: rightWidth.
		c vertical exact: height ].
	previewTopRow constraintsDo: [ :c |
		c horizontal exact: rightWidth.
		c vertical exact: topHeight ].
	previewTopMiddleColumn constraintsDo: [ :c |
		c horizontal exact: topMiddleWidth.
		c vertical exact: topHeight ].
	previewLowerBandRow constraintsDo: [ :c |
		c horizontal exact: topMiddleWidth.
		c vertical exact: lowerBandHeight ].
	previewSmallColumn constraintsDo: [ :c |
		c horizontal exact: smallColumnWidth.
		c vertical exact: lowerBandHeight ].
	previewTopMiddleCell constraintsDo: [ :c |
		c horizontal exact: topMiddleWidth.
		c vertical exact: topMiddleHeight ].
	previewMediumCell constraintsDo: [ :c |
		c horizontal exact: mediumWidth.
		c vertical exact: lowerBandHeight ].
	previewSmallTopCell constraintsDo: [ :c |
		c horizontal exact: smallColumnWidth.
		c vertical exact: smallTopHeight ].
	previewSmallBottomCell constraintsDo: [ :c |
		c horizontal exact: smallColumnWidth.
		c vertical exact: smallBottomHeight ].
	previewTopRightCell constraintsDo: [ :c |
		c horizontal exact: topRightWidth.
		c vertical exact: topHeight ].
	previewBottomRightCell constraintsDo: [ :c |
		c horizontal exact: rightWidth.
		c vertical exact: bottomHeight ]
]
