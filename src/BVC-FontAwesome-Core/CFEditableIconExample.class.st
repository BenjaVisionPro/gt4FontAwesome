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
		accessor: #icon;         "Icons are stored as a selector symbol"
		label: '';
		default: #addressCard;
		priority: 5;
		styleName: 'light';      "Optional if you want to override the default style"
		iconHeight: 64;          "Shouldn't be here and will go away. just being lazy. TODO: descriptions have no knowledge of presentation"
		yourself
]
