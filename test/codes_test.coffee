vows = require 'vows'
assert = require 'assert'
codes = require '../models/codes'

vows.describe('Codes').addBatch(
  'when a single code is being generated': 
    topic: () ->
      codes.generate 1
    'it should generate a single code': (result) ->
      assert.equal 1, result.length
  'when 100 codes are being generated': 
    topic: () ->
      codes.generate 100
    'it should return 100 codes': (result) ->
      assert.equal 100, result.length
    'all codes should be unique': (result) ->
      container = {}
      result.forEach (x) ->
        container[x] = x
      i = 0
      i++ for x of container
      assert.equal 100, i
  'when an invalid number of results are requested':
    topic: () ->
      codes.generate -1
    'it should return an empty array': (result) ->
      assert.equal 0, result.length
).export module