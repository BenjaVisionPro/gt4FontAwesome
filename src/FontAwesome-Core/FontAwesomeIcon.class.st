"
I am a Bloc scalable element that renders a Font Awesome icon.

My extent is the space assigned to the icon by normal Bloc sizing and layout. I scale
my Font Awesome drawing uniformly to fit that space, preserving the icon's nominal
viewBox proportions. Font Awesome paths are allowed to paint outside that nominal
viewBox without changing the icon's layout extent.

I am typically produced through {{gtClass:FontAwesomeIcons}}.

## Example usage
```smalltalk
(FontAwesomeIcons icon: #addressCard)
    size: 32 @ 32;
    color: Color black
```
"
Class {
	#name : 'FontAwesomeIcon',
	#superclass : 'BlScalableElement',
	#instVars : [
		'drawingElement',
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
		| element role color opacity actualColor |
		element := pathElements at: index.
		role := pathRoles at: index.
		color := (role = #secondary
			ifTrue: [ secondaryColor ]
			ifFalse: [ primaryColor ])
			blocResolveColorForTheme: self theme.
		opacity := pathOpacities at: index ifAbsent: [ 1.0 ].
		actualColor := color alpha: (color alpha * opacity).
		element background: actualColor asBlBackground ]
]


{ #category : 'private - styling' }
FontAwesomeIcon >> applyColorsIfThemeIsEffective [
	(self hasParent or: [ self isAttachedToSceneGraph ])
		ifTrue: [ self applyColors ]
]

{ #category : 'accessing' }
FontAwesomeIcon >> color: aColor [
	primaryColor := aColor.
	secondaryColor := aColor.
	self applyColorsIfThemeIsEffective.
	^ self
]

{ #category : 'styling' }
FontAwesomeIcon >> duotoneColorsPrimary: aPrimaryColor secondary: aSecondaryColor [
	primaryColor := aPrimaryColor.
	secondaryColor := aSecondaryColor.
	self applyColorsIfThemeIsEffective.
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

	self
		clipChildren: false;
		size: aRectangle extent.

	pathElements := OrderedCollection new.
	pathRoles := OrderedCollection new.
	pathOpacities := OrderedCollection new.

	drawingElement := BlElement new
		size: aRectangle extent;
		clipChildren: false;
		yourself.

	pathSpecs do: [ :eachSpec |
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

	self contentElement: drawingElement.

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


{ #category : 'hooks - children' }
FontAwesomeIcon >> onAddedToParent [
	super onAddedToParent.
	self applyColors
]

{ #category : 'hooks - scene graph' }
FontAwesomeIcon >> onAddedToSceneGraph [
	super onAddedToSceneGraph.
	self applyColors
]

{ #category : 'hooks - theme' }
FontAwesomeIcon >> onThemeChanged [
	super onThemeChanged.
	pathElements ifNotNil: [ self applyColors ]
]

{ #category : 'styling' }
FontAwesomeIcon >> primaryColor: aColor [
	primaryColor := aColor.
	self applyColorsIfThemeIsEffective.
	^ self
]

{ #category : 'styling' }
FontAwesomeIcon >> secondaryColor: aColor [
	secondaryColor := aColor.
	self applyColorsIfThemeIsEffective.
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
