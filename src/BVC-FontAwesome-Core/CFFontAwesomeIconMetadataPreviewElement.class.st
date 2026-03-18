Class {
	#name : 'CFFontAwesomeIconMetadataPreviewElement',
	#superclass : 'BrVerticalPane',
	#instVars : [
		'iconMetadata',
		'currentStyleName',
		'samplesContainer',
		'renderedSamplesWidth'
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
		yourself.

	samplesContainer := BrFrame new
		constraintsDo: [ :c |
			c horizontal matchParent.
			c vertical fitContent ];
		when: BlElementExtentChangedEvent do: [ :anEvent | self refreshSamplesForExtentChange ];
		yourself.
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
		padding: (BlInsets all: 2)
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
CFFontAwesomeIconMetadataPreviewElement >> newGoldenPreviewForStyleName: aStyleName width: aWidth [
	| bottomHeight bottomRightCell height largeCell leftWidth lowerBandHeight mediumCell mediumWidth rightColumn rightWidth root smallBottomCell smallBottomHeight smallColumn smallColumnWidth smallTopCell smallTopHeight topHeight topMiddleCell topMiddleHeight topMiddleWidth topRightCell topRightWidth topRow |
	height := (aWidth / self goldenRatio) floor.
	height <= 0 ifTrue: [ ^ BrFrame new fitContent ].

	leftWidth := height min: aWidth.
	rightWidth := aWidth - leftWidth.
	bottomHeight := rightWidth.
	topHeight := height - bottomHeight.
	topRightWidth := topHeight.

	rightWidth <= 0 ifTrue: [ ^ self newPreviewCellWidth: aWidth height: height styleName: aStyleName ].

	topRightWidth := topRightWidth max: 0.
	topHeight := topHeight max: 0.

	topMiddleWidth := (rightWidth - topRightWidth) max: 0.
	topMiddleHeight := topMiddleWidth.
	lowerBandHeight := (topHeight - topMiddleHeight) max: 0.
	mediumWidth := lowerBandHeight.
	smallColumnWidth := (topMiddleHeight - mediumWidth) max: 0.
	smallBottomHeight := smallColumnWidth.
	smallTopHeight := (lowerBandHeight - smallBottomHeight) max: 0.

	root := BrHorizontalPane new
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: aWidth.
			c vertical exact: height ];
		yourself.

	largeCell := self newPreviewCellWidth: leftWidth height: height styleName: aStyleName.
	rightColumn := BrVerticalPane new
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: rightWidth.
			c vertical exact: height ];
		yourself.

	topRow := BrHorizontalPane new
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: rightWidth.
			c vertical exact: topHeight ];
		yourself.

	topMiddleCell := BrVerticalPane new
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: topMiddleWidth.
			c vertical exact: topHeight ];
		yourself.
	topMiddleCell addChild: (self newPreviewCellWidth: topMiddleWidth height: topMiddleHeight styleName: aStyleName).

	smallColumn := BrVerticalPane new
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: smallColumnWidth.
			c vertical exact: lowerBandHeight ];
		yourself.
	smallTopCell := self newPreviewCellWidth: smallColumnWidth height: smallTopHeight styleName: aStyleName.
	smallBottomCell := self newPreviewCellWidth: smallColumnWidth height: smallBottomHeight styleName: aStyleName.
	smallColumn addChildren: { smallTopCell. smallBottomCell }.

	mediumCell := self newPreviewCellWidth: mediumWidth height: lowerBandHeight styleName: aStyleName.
	topMiddleCell addChild: (BrHorizontalPane new
		cellSpacing: 0;
		constraintsDo: [ :c |
			c horizontal exact: topMiddleWidth.
			c vertical exact: lowerBandHeight ];
		addChildren: { mediumCell. smallColumn };
		yourself).

	topRightCell := self newPreviewCellWidth: topRightWidth height: topHeight styleName: aStyleName.
	bottomRightCell := self newPreviewCellWidth: rightWidth height: bottomHeight styleName: aStyleName.

	topRow addChildren: { topMiddleCell. topRightCell }.
	rightColumn addChildren: { topRow. bottomRightCell }.
	root addChildren: { largeCell. rightColumn }.
	^ root
]

{ #category : 'private - instance creation' }
CFFontAwesomeIconMetadataPreviewElement >> newPreviewCellWidth: aWidth height: aHeight styleName: aStyleName [
	| cell contentExtent icon |
	cell := BrFrame new
		padding: (BlInsets all: 6);
		layout: BlFrameLayout new;
		constraintsDo: [ :c |
			c horizontal exact: (aWidth max: 0).
			c vertical exact: (aHeight max: 0) ];
		yourself.

	contentExtent := ((aWidth - 12) max: 0) @ ((aHeight - 12) max: 0).
	(contentExtent x min: contentExtent y) < self minimumPreviewIconExtent ifTrue: [ ^ cell ].

	icon := CFMaFontAwesomeBuilderUtility
		newFontAwesomeIconForMetadata: iconMetadata
		styleName: aStyleName
		fitInto: contentExtent.
	icon constraintsDo: [ :c |
		c frame horizontal alignCenter.
		c frame vertical alignCenter ].
	cell addChild: icon.
	^ cell
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

{ #category : 'private - updating' }
CFFontAwesomeIconMetadataPreviewElement >> refreshSamples [
	| availableWidth |
	samplesContainer ifNil: [ ^ self ].
	availableWidth := self samplesWidth.
	availableWidth <= 0 ifTrue: [ ^ self ].

	samplesContainer removeChildren.
	samplesContainer addChild: (self newGoldenPreviewForStyleName: currentStyleName width: availableWidth).
	renderedSamplesWidth := availableWidth
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
	samplesContainer ifNil: [ ^ 0 ].
	width := samplesContainer extent x rounded.
	width > 0 ifTrue: [ ^ width ].
	^ self extent x rounded
]
