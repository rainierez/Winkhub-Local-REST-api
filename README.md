# Winkhub-Local-REST-api
A local RESTful api using the slim framework on a rooted Wink Hub. This is limited to 'HA dimmable lights' and  'On/Off Output' devices for right now. I will expand it as I go.

*Tested on a rooted Wink hub with version .56*

##Install
1. Put the contents of the 'www' folder onto the wink hub in the '/var/www/' folder.
2. Run the following commands to make the bash scripts executable
```
$ chmod u+x /var/www/statuscheck.sh
$ chmod u+x /var/www/changestate.sh
$ chmod u+x /var/www/changelevel.sh
```

##Usage

Method | Path | Parameters | outputs
--- | --- | --- | ---
GET | `/devices/` | `<deviceid>` | status and level
GET | `/devices/all` | `<optional max range>` | Loops from 1 to max range (defaults to 25 if nothing passed) and returns status and level for each device
PUT | `/devices/` | `<deviceid>, <status>` | returns confirmation of change
PUT | `/devices/` | `<deviceid>, <level>` | returns confirmation of change
PUT | `/devices/` | `<deviceid>, <status>, <level>` | returns confirmation of change. For status 1 = ON and 0 = OFF. For level 10 = dimmest and 255 = brightest

###Examples

####To get the status of one device
```
$ curl -i -H "Accept: application/json" http://<IP of Wink Hub>/api.php/devices/1
```

Returns

```
{"1":{"Status": "ON","Level": "255"}}
```

---
####To get the status of multiple devices, this time limiting it to the first 4
```
$ curl -i -H "Accept: application/json" http://<IP of Wink Hub>/api.php/devices/all/4
```

Returns

```
{"1":{"Status": "ON","Level": "255"},"2":{"Status": "OFF","Level": "125"},"3":{"Status": "OFF","Level": "255"},"4":{"Status": "OFF","Level": "156"}}
```
---
####Turning the light on and dimming it to a bit less then 50% 
```
$ curl -H "Accept: application/json" -X PUT http://192.168.0.1/index.php -d '{"deviceid":"1","status":"1","level":"100"}'
```

Returns

```
{"State":"Update device with master ID 1, setting value ON for attribute 1","Level":"Update device with master ID 1, setting value 100 for attribute 2"}
```
---
####Turning the light off
```
$ curl -H "Accept: application/json" -X PUT http://192.168.0.1/index.php -d '{"deviceid":"1","status":"0"}'
```

Returns

```
{"State":"Update device with master ID 1, setting value OFF for attribute 1"}
```
