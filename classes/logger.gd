extends Node

const couchdb_token = ""
const couchdb_url = ""
const couchdb_port = 5984
const uuid_util = preload("res://classes/uuid.gd")

var req: HTTPRequest = null

func logger(payload = ""):
	if payload == "":
		return

	var error = 0
	if req == null:
		req = HTTPRequest.new()
	add_child(req) #Yikes!
#	req.request_completed.connect(self._on_request_completed)
	
	var id = uuid_util.v4()
	var headers = [
		"Content-Type: application/json",
		"Accept: application/json",
		"Authorization: Basic %s" % couchdb_token,
	]
	var url = "%s:%d/<your_db_name>/%s" % [couchdb_url, couchdb_port, id]
	req.request(url, headers, HTTPClient.METHOD_PUT, payload)
	await req.request_completed
	remove_child(req)

func _on_request_completed(result, response_code, headers, body):
#	print("Result: ", result)
#	print("Code:", response_code)
#	print("Headers: ", headers)
#	print("Body: ", body.get_string_from_utf8())
	pass
