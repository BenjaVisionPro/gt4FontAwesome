"
I am a small Magritte example model that demonstrates editing a Font Awesome icon selection.

## Responsibilities
- I provide a simple object with an icon-valued slot.
- I define a {{gtClass:FontAwesomeIconDescription}} for that slot.
- I act as a lightweight usage example for the Font Awesome/Magritte integration.

## Example usage
Inspect an instance of me and explore the Magritte form generated from my icon description.
"
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
