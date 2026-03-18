Class {
	#name : 'FontAwesomeEditableIconExample',
	#superclass : 'Object',
	#instVars : [
		'icon'
	],
	#category : 'FontAwesome-Core',
	#package : 'FontAwesome-Core'
}

{ #category : 'accessing' }
FontAwesomeEditableIconExample >> icon [
	^ icon
]

{ #category : 'accessing' }
FontAwesomeEditableIconExample >> icon: anObject [
	icon := anObject
]

{ #category : 'as yet unclassified' }
FontAwesomeEditableIconExample >> iconDescription [
	<magritteDescription>
	^ FontAwesomeIconDescription new
		accessor: #icon;         "Icons are stored as a selector symbol"
		label: '';
		default: #addressCard;
		priority: 5;
		styleName: 'light';      "Optional if you want to override the default style"
		iconHeight: 64;          "Shouldn't be here and will go away. just being lazy. TODO: descriptions have no knowledge of presentation"
		yourself
]
