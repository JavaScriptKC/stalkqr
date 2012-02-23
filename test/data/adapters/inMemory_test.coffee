vows = require 'vows'
should = require 'should'
InMemoryDataAdapter = require '../../../data/adapters/inMemory'

vows.describe('In-memory store (data/adapters/inMemory)').addBatch(
  '': {
    topic: () -> new InMemoryDataAdapter(),

    'it should require no constructor arguments': (adapter) ->
      should.exist(adapter)
    
    'it should be empty when nothing has been added': (adapter) ->
      adapter.items.should.eql({})
    
    'when saving a new item': {
      topic: (adapter) ->
        adapter.save('testObjects', sampleObjects[0], @callback)
      
      'it should pass back the original attributes': (err, attributes) ->
        should.not.exist(err)
        attributes.test.should.be.true
        attributes.numeric.should.equal(52)
        attributes.items.should.eql(['one', 'two'])

      'it should not simply use the same object in memory': (err, attributes) ->
        # standard equal compares memory addresses
        attributes.should.not.equal(sampleObjects[0]) 

      'it should add an _id attribute': (err, attributes) ->
        attributes.should.have.property('_id')
        attributes._id.should.equal(0)      
    }
    
    'when updating an existing item': {
      topic: (adapter) ->
        adapter.save('testObjects', {
          '_id': 0
          'newObject': sampleObjects[1]
        }, @callback)
      
      'it should pass back the new attributes': (err, attributes) ->
        should.not.exist(err)
        should.exist(attributes)
        attributes._id.should.equal(0)
        attributes.newObject.should.eql(sampleObjects[1])
    }

    'when finding an object by real id': {
      topic: (adapter) ->
        adapter.find('testObjects', {
          '_id': 0
        }, @callback)

      'it should return the object stored': (err, items) ->
        should.not.exist(err)
        should.exist(items)
        items.should.have.length(1)
        items[0]._id.should.equal(0)
        items[0].newObject.should.eql(sampleObjects[1])
    }

    'when finding an object by a fake id': {
      topic: (adapter) ->
        adapter.find('testObjects', {
          '_id': 1
        }, @callback)

      'it should not return any items': (err, items) ->
        should.not.exist(err)
        should.exist(items)
        items.should.have.length(0)
    }

    'when finding an object in a non-existent collection': {
      topic: (adapter) ->
        adapter.find('noTestObjects', {
          '_id': 0
        }, @callback)
      
      'it should not return any items': (err, items) ->
        should.not.exist(err)
        should.exist(items)
        items.should.have.length(0)
    }

    'when searching with no parameters': {
      topic: (adapter) ->
        adapter.find('testObjects', {}, @callback)
      
      'it should return all items in the collection': (err, items) ->
        should.not.exist(err)
        should.exist(items)
        items.should.have.length(1)
        items[0]._id.should.equal(0)
        items[0].newObject.should.eql(sampleObjects[1])
    }
  }
).export(module)

sampleObjects = [
  { 'test': true, 'numeric': 52, 'items': ['one', 'two'] },
  { 'one': true, 'two': false }
]
