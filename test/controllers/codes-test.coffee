vows = require 'vows'
assert = require 'assert'
codes = require('../../controllers/code')._internal

SAMPLE_CODE = 'b4c09e3b-4311-4a8d-aa0a-2c2e77924c03'
SAMPLE_HOST = 'example.com'

vows.describe('controllers/codes').addBatch(

  'generating a code':
    topic: () ->
      codes.generate SAMPLE_CODE, SAMPLE_HOST, this.callback

    'should render a template': (template, data) ->
      assert.ok template

    'should pass the correct url': (template, data) ->
      assert.equal data.url, 'http://' + SAMPLE_HOST + '/scan/' + SAMPLE_CODE

  'scanning a new code':
    topic: () ->
      codes.scan SAMPLE_CODE, this.callback

    'should temporarily redirect': (url, method) ->
      assert.equal method, 301

    'should redirect to activate': (url, method) ->
      assert.equal url, '/activate/' + SAMPLE_CODE

).export(module)