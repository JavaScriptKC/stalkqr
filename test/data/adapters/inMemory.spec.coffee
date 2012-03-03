should = require 'should'
InMemoryDataAdapter = require '../../../data/adapters/inMemory'

sampleObjects = [
  { 'test': true, 'numeric': 52, 'items': ['one', 'two'] },
  { 'one': true, 'two': false }
]

describe 'When using a In-memory store (data/adapters/inMemory)', ->
  
  beforeEach ->
    @adapter = new InMemoryDataAdapter()
  
  it 'should require no constructor arguments', ->
    should.exist(@adapter)
  
  it 'should be empty when nothing has been added', ->
    @adapter.items.should.eql({})

  describe 'when saving a new item', ->

    beforeEach (done) ->
      @adapter.save 'testObjects', sampleObjects[0], (e, a) => 
        @attributes = a
        @err = e
        done()
    
    it 'should pass back the original attributes', ->
      should.not.exist(@err)
      @attributes.test.should.be.true
      @attributes.numeric.should.equal(52)
      @attributes.items.should.eql(['one', 'two'])

    it 'should not simply use the same object in memory', ->
      # standard equal compares memory addresses
      @attributes.should.not.equal(sampleObjects[0]) 

    it 'should add an _id attribute', ->
      @attributes.should.have.property('_id')
      @attributes._id.should.equal(0)      
    
    describe 'when updating an existing item', ->

      beforeEach (done) ->
        @adapter.save 'testObjects', {
          '_id': 0
          'newObject': sampleObjects[1]
        }, (e, a) => 
          @err = e
          @attributes = a
          done()
        
      it 'should pass back the new attributes', ->
        should.not.exist(@err)
        should.exist(@attributes)
        @attributes._id.should.equal(0)
        @attributes.newObject.should.eql(sampleObjects[1])
      
    describe 'When finding an object by real id', ->
      
      beforeEach (done) ->
        @adapter.find 'testObjects', {'_id': 0}, (e, i) =>
          @err = e
          @foundItems = i
          done()

      it 'should return the object stored', ->
        should.not.exist(@err)
        should.exist(@foundItems)
        @foundItems.should.have.length(1)
        @foundItems[0]._id.should.equal(0)

    describe 'when finding an object by a fake id', ->
        
      beforeEach (done) ->  
        @adapter.find 'testObjects', {'_id': 1}, (e, i) =>
          @err = e
          @foundItems = i
          done()

      it 'should not return any items', ->
        should.not.exist(@err)
        should.exist(@foundItems)
        @foundItems.should.have.length(0)

    describe 'when finding an object in a non-existent collection', ->
      
      beforeEach (done) ->  
        @adapter.find 'notestObjects', {'_id': 0}, (e, i) =>
          @err = e
          @foundItems = i
          done()

      it 'should not return any items', ->
        should.not.exist(@err)
        should.exist(@foundItems)
        @foundItems.should.have.length(0)

    describe 'when searching with no parameters', ->
        
      beforeEach (done) ->  
        @adapter.find 'testObjects', {}, (e, i) =>
          @err = e
          @foundItems = i
          done()                       
                                                        
      it 'should return all items in the collection', ->
        should.not.exist(@err)
        should.exist(@foundItems)
        @foundItems.should.have.length(1)
        @foundItems[0]._id.should.equal(0)
