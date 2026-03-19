"
I am a context-menu content element that lets the user choose the default style for an icon library.

## Responsibilities
- I list the available imported styles of an icon library.
- I present a preview and label for each style choice.
- I update the selected default style through the icon library API.

I am typically opened from a GT action associated with {{gtClass:FontAwesomeIcons}}.
"
Class {
	#name : 'FontAwesomeDefaultStyleMenuElement',
	#superclass : 'GtAbstractCoderContextMenuContent',
	#instVars : [
		'iconLibraryClass',
		'menuModel'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'instance creation' }
FontAwesomeDefaultStyleMenuElement class >> menuActionIconFor: anIconLibraryClass [
	^ [
		| icon |
		icon := (anIconLibraryClass style: 'brands') icon: #fontAwesomeFlag.
		BlElement new
			size: 16 @ 16;
			layout: BlFrameLayout new;
			addChild: (icon asScalableElementSized: (icon extentForHeight: 14)) ]
		asStencil
]

{ #category : 'instance creation' }
FontAwesomeDefaultStyleMenuElement class >> menuContentFor: anIconLibraryClass button: aButton menuModel: anExplicitMenu [
	| aMenuElement |
	aMenuElement := self new
		iconLibraryClass: anIconLibraryClass;
		menuModel: anExplicitMenu;
		initializeItems;
		yourself.

	^ aMenuElement
		background: aButton theme default contentBackground;
		addAptitude: (BrGlamorousPopoverPinnableAptitude new
				withAllPinActions;
				menuModel: anExplicitMenu);
		yourself
]

{ #category : 'private' }
FontAwesomeDefaultStyleMenuElement class >> menuItemGroup [
	^ BrMenuItemGroupConfiguration new
		name: 'Font Awesome';
		priority: 44;
		yourself
]

{ #category : 'private' }
FontAwesomeDefaultStyleMenuElement class >> previewSelectorForStyleNamed: aStyleName [
	aStyleName = 'brands' ifTrue: [ ^ #fontAwesomeFlag ].
	^ #star
]

{ #category : 'private' }
FontAwesomeDefaultStyleMenuElement class >> shouldShowActionFor: anIconLibraryClass [
	^ anIconLibraryClass hasImportedIcons
		and: [ anIconLibraryClass styleName isNil
		and: [ anIconLibraryClass availableStyles size > 1 ]
		]
]

{ #category : 'private' }
FontAwesomeDefaultStyleMenuElement class >> styleLabelFor: aStyleName [
	^ aStyleName asString capitalized
]

{ #category : 'accessing' }
FontAwesomeDefaultStyleMenuElement >> iconLibraryClass: aClass [
	iconLibraryClass := aClass
]

{ #category : 'initialization' }
FontAwesomeDefaultStyleMenuElement >> initializeItems [
	self items: iconLibraryClass availableStyles
]

{ #category : 'accessing' }
FontAwesomeDefaultStyleMenuElement >> itemPadding [
	^ BlInsets top: 4 bottom: 4 left: 2 right: 2
]

{ #category : 'private' }
FontAwesomeDefaultStyleMenuElement >> menuItemStencil [
	^ [ :aStyleName :aRowIndex |
		| anElement |
		anElement := BrHorizontalPane new
			hMatchParent;
			vFitContent;
			alignCenter;
			addAptitude: self selectionAptitude;
			padding: self itemPadding;
			when: BlClickEvent
				do: [ :anEvent |
					anEvent consumed: true.
					self selectStyleNamed: aStyleName ].

		anElement
			addChild: (self previewIconElementForStyleNamed: aStyleName);
			addChild: (self itemLabelFor: (self class styleLabelFor: aStyleName)).

		anElement ]
]

{ #category : 'accessing' }
FontAwesomeDefaultStyleMenuElement >> menuModel: aMenuModel [
	menuModel := aMenuModel
]

{ #category : 'private' }
FontAwesomeDefaultStyleMenuElement >> previewIconElementForStyleNamed: aStyleName [
	| aSelector anIcon |
	aSelector := self class previewSelectorForStyleNamed: aStyleName.
	aSelector ifNil: [ ^ BlElement new size: 16 @ 16 ].

	anIcon := [
		(iconLibraryClass style: aStyleName) icon: aSelector ]
			on: Error
			do: [ :anError | ^ BlElement new size: 16 @ 16 ].
	^ (anIcon asScalableElementSized: (anIcon extentForHeight: 16))
		margin: (BlInsets right: 8);
		yourself
]

{ #category : 'actions' }
FontAwesomeDefaultStyleMenuElement >> selectStyleNamed: aStyleName [
	iconLibraryClass defaultStyleName = aStyleName ifFalse: [
		iconLibraryClass defaultStyleName: aStyleName ].
	menuModel
		ifNil: [ self fireEvent: BrContextMenuHideWish new ]
		ifNotNil: [ menuModel hideAll ]
]
