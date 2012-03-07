should = require('should');
User = require('../../models/user');

expectedAttributes =
  name: 'Abraham Lincoln'
  userSince: Date.parse('April 14, 1865')
  slugs: ['abe', 'penniesrock']
  handles: [{type: 'twitter', handle: 'abelincoln'}]
  credentials: [{provider: 'twitter', id: 1234 }]
  _id: 1234

callsToSave = []

getUser = () ->
  user = new User()
  user._adapter =
    save: (collection, attributes, callback) ->
      callsToSave.push([collection, callback])
      callback(null, @attributes)
  return user

describe('User (models/user)', ->
  describe('when creating a user from attributes', ->
    beforeEach ->
      @user = new User(expectedAttributes)

    it 'should set the correct name', ->
      @user.attributes.name.should.equal(expectedAttributes.name)

    it 'should set the correct user since date', ->
      @user.attributes.userSince.should.equal(expectedAttributes.userSince)

    it 'should set the correct slugs', ->
      @user.attributes.slugs.should.eql(expectedAttributes.slugs)

    it 'should set the correct handles', ->
      @user.attributes.handles.should.eql(expectedAttributes.handles)

    it 'should set the correct credentials', ->
      @user.attributes.credentials.should.eql(expectedAttributes.credentials)

    it 'should set the correct id', ->
      @user.attributes._id.should.equal(expectedAttributes._id)

    describe('and to toJSON() is called', ->
      beforeEach ->
        @userJson = @user.toJSON()

      it 'should set the correct name', ->
        @userJson.name.should.equal(expectedAttributes.name)

      it 'should set the correct user since date', ->
        @userJson.userSince.should.equal(expectedAttributes.userSince)

      it 'should set the correct slugs', ->
        @userJson.slugs.should.eql(expectedAttributes.slugs)

      it 'should set the correct handles', ->
        @userJson.handles.should.eql(expectedAttributes.handles)

      it 'should set the correct credentials', ->
        @userJson.credentials.should.eql(expectedAttributes.credentials)

      it 'should set the correct id', ->
        @userJson._id.should.equal(expectedAttributes._id)
    )
  )

  describe('when creating a user model', ->
    beforeEach ->
      @user = new User()

    it 'should have default values', ->
      should.not.exist(@user.attributes.name)
      should.not.exist(@user.attributes.userSince)
      should.not.exist(@user.attributes._id)

      @user.attributes.slugs.should.be.empty
      @user.attributes.handles.should.be.empty
      @user.attributes.credentials.should.be.empty

    describe('and toJSON() is called', ->
      beforeEach ->
        @userJson = @user.toJSON()

      it 'should not have an id set', ->
        should.not.exist(@userJson._id)

      it 'should not have a user since date', ->
        should.not.exist(@userJson.userSince)

      it 'should not have any slugs', ->
        @userJson.slugs.should.be.empty

      it 'should not have any credentials', ->
        @userJson.credentials.should.be.empty

      it 'should not have any handles', ->
        @userJson.handles.should.be.empty
    )

    describe('and a new credential is added', ->
      beforeEach ->
        @user.setCredential('twitter', 1865)

      it 'should have the newly added credential', ->
        @user.attributes.credentials.length.should.equal(1)
        @user.attributes.credentials[0].provider.should.equal('twitter')
        @user.attributes.credentials[0].id.should.equal(1865)

      describe('and the same credential is added with different casing', ->
        beforeEach ->
          @user.setCredential('Twitter', 1337)

        it 'should not add a new credential to the list', ->
          @user.attributes.credentials.length.should.equal(1)
          @user.attributes.credentials[0].provider.should.equal('twitter')
          @user.attributes.credentials[0].id.should.equal(1337)
      )

      describe('and a completely different credential is added', ->
        beforeEach ->
          @user.setCredential('github', 100)

        it 'should be appended to the credentials', ->
          @user.attributes.credentials.length.should.equal(2)
          @user.attributes.credentials[1].provider.should.equal('github')
          @user.attributes.credentials[1].id.should.equal(100)
      )
    )
  )

  describe('when calling save() on a user', ->
    beforeEach ->
      @user = getUser()
      @user.save(->)

    it 'should call save on the base model', ->
      callsToSave.should.have.length(1)
      callsToSave[0].should.have.length(2)

    it 'should save to the \'users\' collection', ->
      callsToSave[0][0].should.equal('users')
  )
)