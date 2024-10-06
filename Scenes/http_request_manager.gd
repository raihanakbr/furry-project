extends Node2D

signal request_completed(result, response_code, headers, body)
signal request_timeout()

var http_request : HTTPRequest
var timeout_duration : float = 5
var request_timer : Timer


func _ready():
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	request_timer = Timer.new()
	request_timer.wait_time = timeout_duration
	request_timer.one_shot = true
	request_timer.connect("timeout", Callable(self, "_on_request_timeout"))
	add_child(request_timer)


func send_request(url: String, method: int = HTTPClient.METHOD_GET, request_data: Dictionary = {}, headers: Array = []):
	print(url)
	if method == HTTPClient.METHOD_POST:
		var body_data = JSON.stringify(request_data)
		headers.append("Content-Type: application/json")
		http_request.request(url, headers, method, body_data)
	else:
		http_request.request(url, headers, method)
	request_timer.start()

func _http_request_completed(result, response_code, headers, body):
	emit_signal("request_completed", result, response_code, headers, body)

	http_request.disconnect("request_completed", Callable(self, "_on_request_completed"))
	
func _on_request_timeout():
	print("konz")
	emit_signal("request_timeout")

	http_request.cancel_request()
