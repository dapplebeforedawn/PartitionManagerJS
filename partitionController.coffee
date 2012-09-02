#Mark J. Lorenz - August 2012
#
#partitions the screen into various size chunks, and allows you to reserve sections without conflict
#requires underscore.js

class RangeBlock
  constructor: (position, height, controller)->
    @controller = controller
    @position = position
    @height = height
  free: ()->
    @controller.freeRange(@)
  
class PartitionController
  constructor: (sizes, windowHeight)->
    @sizes = sizes
    @windowHeight = windowHeight
    @partitionSize = 1
    @partitions = @._fillPartitions()
  anyFreeRangeOfSize: (requestedSize)-> #returns false if no free range exists
    rangePosition = null
    #try some ranges at random
    maxRandomTries = 3
    validTryPositions = _.chain(_.keys(@partitions)).map (stringPartition)=>
      parseInt stringPartition
    .filter (position) =>
      position + requestedSize <= @windowHeight && @partitions[position.toString()]
    .value()
    while maxRandomTries && !rangePosition
      tryPosition = _.chain(validTryPositions).shuffle().first().value()
      if @._isRangeFree(tryPosition, requestedSize)
        rangePosition = tryPosition
      maxRandomTries--
    #if free one not found just walk it
    if !rangePosition
      _(validTryPositions).all (position)=>
        if @._isRangeFree position, requestedSize
          rangePosition = position
        !rangePosition

    #build rangeBlock object or return false
    return false if !rangePosition
    @._createRange rangePosition, requestedSize

  anyFreeRange: ()-> #returns false if no free range exists
    range = false
    _.chain(@sizes).shuffle().all (size)=>
      range = @.anyFreeRangeOfSize size
      !range
    .value()
    range
  freeRange: (range)->
    for i in [range.position..range.position+range.height-1] by @partitionSize
      @partitions[i.toString()] = true
  updateWindowHeight: (newHeight)->
      @windowHeight = newHeight
      oldPartitions = _.clone(@partitions)
      @partitions = {}
			return if @windowHeight == 0
      for i in [0..@windowHeight-parseInt(@partitionSize)] by parseInt(@partitionSize)
        if typeof(oldPartitions[i.toString()]) == "undefined" #if we're going bigger mark it true
          @partitions[i.toString()] = true
        else #common partitions get coppied
          @partitions[i.toString()] = oldPartitions[i.toString()]
  _createRange: (position, requestedSize)->
    for i in [position..position+requestedSize-1] by @partitionSize
      @partitions[i.toString()] = false
    new RangeBlock position, requestedSize, @
  _fillPartitions: ()->
    partitions = {}
		return if @windowHeight == 0
    for i in [0..@windowHeight-@partitionSize] by @partitionSize
      partitions[i.toString()] = true
    partitions
  _isRangeFree: (position, size)->
    for i in [position..position+size] by @partitionSize
      return false if !@partitions[i.toString()]
    true

