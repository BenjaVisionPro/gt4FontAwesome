"
I am a Bloc element that renders one or more Font Awesome SVG paths directly.

## Responsibilities
- I represent a concrete Font Awesome icon as a reusable UI element.
- I manage the SVG path elements and their roles, opacities, colors, and sizing.
- I provide convenience API for fitting and scaling the icon into a desired extent.

I am typically produced through {{gtClass:FontAwesomeIcons}} class-side factory methods or through imported metadata.

## Example usage
```smalltalk
FontAwesomeIcons icon: #addressCard
```

```smalltalk
(FontAwesomeIcons icon: #addressCard)
	size: 32;
	color: Color black
```

Use me when you need a real Bloc element that can be embedded directly in another UI.
"
Class {
	#name : 'FontAwesomeIcon',
	#superclass : 'BlElement',
	#instVars : [
		'drawingElement',
		'scalableElement',
		'pathElements',
		'pathRoles',
		'pathOpacities',
		'iconName',
		'styleKey',
		'unicode',
		'label',
		'viewBox',
		'primaryColor',
		'secondaryColor'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'styling' }
FontAwesomeIcon >> applyColors [
	1 to: pathElements size do: [ :index |
		| element role color opacity actualColor background |
		element := pathElements at: index.
		role := pathRoles at: index.
		color := role = #secondary
			ifTrue: [ secondaryColor ]
			ifFalse: [ primaryColor ].
		opacity := pathOpacities at: index ifAbsent: [ 1.0 ].
		actualColor := color alpha: (color alpha * opacity).
		background := BlBackground paint: (BlColorPaint color: actualColor).
		element background: background ]
]

{ #category : 'converting' }
FontAwesomeIcon >> asElement [
	^ self
]

{ #category : 'converting' }
FontAwesomeIcon >> asScalableElementSized: anExtent [
	self size: anExtent.
	^ self
]

{ #category : 'converting' }
FontAwesomeIcon >> asStencil [
	^ [ self ] asStencil
]

{ #category : 'accessing' }
FontAwesomeIcon >> color: aColor [
	primaryColor := aColor.
	secondaryColor := aColor.
	self applyColors.
	^ self
]

{ #category : 'styling' }
FontAwesomeIcon >> duotoneColorsPrimary: aPrimaryColor secondary: aSecondaryColor [
	primaryColor := aPrimaryColor.
	secondaryColor := aSecondaryColor.
	self applyColors.
	^ self
]

{ #category : 'sizing' }
FontAwesomeIcon >> extentFittingInto: anExtent [
	| intrinsic xScale yScale scale |
	intrinsic := self intrinsicExtent.
	((intrinsic x isZero)
		or: [ (intrinsic y isZero)
			or: [ anExtent isNil ] ]) ifTrue: [ ^ intrinsic ].
	xScale := anExtent x asFloat / intrinsic x asFloat.
	yScale := anExtent y asFloat / intrinsic y asFloat.
	scale := xScale min: yScale.
	^ (intrinsic x asFloat * scale) @ (intrinsic y asFloat * scale)
]

{ #category : 'sizing' }
FontAwesomeIcon >> extentForHeight: aNumber [
	| intrinsic scale newWidth |
	intrinsic := self intrinsicExtent.
	(intrinsic y isZero or: [ aNumber isNil ]) ifTrue: [ ^ intrinsic ].
	scale := aNumber asFloat / intrinsic y asFloat.
	newWidth := intrinsic x asFloat * scale.
	^ newWidth @ aNumber
]

{ #category : 'sizing' }
FontAwesomeIcon >> extentForWidth: aNumber [
	| intrinsic scale newHeight |
	intrinsic := self intrinsicExtent.
	(intrinsic x isZero or: [ aNumber isNil ]) ifTrue: [ ^ intrinsic ].
	scale := aNumber asFloat / intrinsic x asFloat.
	newHeight := intrinsic y asFloat * scale.
	^ aNumber @ newHeight
]

{ #category : 'sizing' }
FontAwesomeIcon >> fitInto: anExtent [
	self size: anExtent.
	^ self
]

{ #category : 'sizing' }
FontAwesomeIcon >> height: aNumber [
	self size: (self extentForHeight: aNumber).
	^ self
]

{ #category : 'accessing' }
FontAwesomeIcon >> iconName [
	^ iconName
]

{ #category : 'initialization' }
FontAwesomeIcon >> initializeName: aSelector styleKey: aStyleKey unicode: aUnicodeString label: aLabelString viewBox: aRectangle pathSpecs: pathSpecs [
	iconName := aSelector.
	styleKey := aStyleKey.
	unicode := aUnicodeString.
	label := aLabelString.
	viewBox := aRectangle.

	self layout: BlFrameLayout new.

	pathElements := OrderedCollection new.
	pathRoles := OrderedCollection new.
	pathOpacities := OrderedCollection new.
	drawingElement := BlElement new
		size: aRectangle extent;
		yourself.
	scalableElement := drawingElement asScalableElement.
	self addChild: scalableElement.

	pathSpecs
		do: [ :eachSpec | 
			| element role opacity |
			role := eachSpec at: #role ifAbsent: [ #primary ].
			opacity := eachSpec at: #opacity ifAbsent: [ 1.0 ].
			element := BlElement new
					geometry: (BlSvgPath new svg: (eachSpec at: #path) viewbox: aRectangle);
					size: aRectangle extent;
					yourself.
			drawingElement addChild: element.
			pathElements add: element.
			pathRoles add: role.
			pathOpacities add: opacity ].

	self size: aRectangle extent.

	primaryColor := Color black.
	secondaryColor := Color black.
	self applyColors.
	^ self
]

{ #category : 'accessing' }
FontAwesomeIcon >> intrinsicExtent [
	^ viewBox extent
]

{ #category : 'accessing' }
FontAwesomeIcon >> label [
	^ label
]

{ #category : 'styling' }
FontAwesomeIcon >> primaryColor: aColor [
	primaryColor := aColor.
	self applyColors.
	^ self
]

{ #category : 'styling' }
FontAwesomeIcon >> secondaryColor: aColor [
	secondaryColor := aColor.
	self applyColors.
	^ self
]

{ #category : 'sizing' }
FontAwesomeIcon >> size: anExtent [
	super size: anExtent.
	scalableElement ifNotNil: [ scalableElement size: anExtent ].
	^ self
]

{ #category : 'accessing' }
FontAwesomeIcon >> styleKey [
	^ styleKey
]

{ #category : 'accessing' }
FontAwesomeIcon >> unicode [
	^ unicode
]

{ #category : 'accessing' }
FontAwesomeIcon >> viewBox [
	^ viewBox
]

{ #category : 'sizing' }
FontAwesomeIcon >> width: aNumber [
	self size: (self extentForWidth: aNumber).
	^ self
]
