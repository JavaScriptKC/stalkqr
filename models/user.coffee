module.exports = 
  find_by_id: (id, callback) ->
    callback null, id: id

  find_by_service: (service, service_id, callback) ->
    callback null, id: service_id