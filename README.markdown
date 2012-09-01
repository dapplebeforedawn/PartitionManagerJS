#PartitionController.js

This is a little javascript class that is able to manage partitions of the screen width.  You request a partition of a given size, or any random partition from the list of possible sizes, and it will return the starting coordinate and a height.

Concretely, this was designed to manage a fish bowl type animation where text of various sizes would scroll across the screen, but never overlap.

requires [Underscore.js](http://underscorejs.org/)
