Class {
	#name : 'CFEditableIconExample',
	#superclass : 'Object',
	#instVars : [
		'icon'
	],
	#category : 'BVC-FontAwesome-Core',
	#package : 'BVC-FontAwesome-Core'
}

{ #category : 'accessing' }
CFEditableIconExample >> icon [
	^ icon
]

{ #category : 'accessing' }
CFEditableIconExample >> icon: anObject [
	icon := anObject
]

{ #category : 'as yet unclassified' }
CFEditableIconExample >> iconDescription [
	<magritteDescription>
	^ CFMaFontAwesomeIconDescription new
		accessor: #icon;
		label: 'Icon';
		default: #addressCard;
		priority: 5;
		styleName: 'duotone';
		iconHeight: 32;
		yourself
]
