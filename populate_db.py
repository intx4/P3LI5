import requests
import json
import copy
import time

template = json.loads('{"imsi":"999990154321050","security":{"k":"465B5CE8 B199B49F AA5F0A2E E238A6BC","amf":"8000","op_type":0,"op_value":"E8ED289D EBA952E4 283B54E8 8E6183CA","op":null,"opc":"E8ED289D EBA952E4 283B54E8 8E6183CA"},"ambr":{"downlink":{"value":1,"unit":3},"uplink":{"value":1,"unit":3}},"slice":[{"sst":1,"default_indicator":true,"session":[{"name":"internet","type":3,"ambr":{"downlink":{"value":1,"unit":3},"uplink":{"value":1,"unit":3}},"qos":{"index":9,"arp":{"priority_level":8,"pre_emption_capability":1,"pre_emption_vulnerability":1}}}]}]}')

def get_docker_ip(env_path: str):
    with open(env_path, 'r') as f:
        ip = [l for l in f.readlines() if "DOCKER_HOST_IP=" in l][0].split("=")[1].split(" #")[0]
        return ip

def parse_session(session : str):
    #session = '{"clientMaxAge":60000,"csrfToken":"0yQ68haYvW84OO+mgi3A9Ra5DUE2wCll4Bn1o=","user":{"_id":"63c65ef836be63209544152f","username":"admin","__v":0,"roles":["admin"]},"authToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYzYzY1ZWY4MzZiZTYzMjA5NTQ0MTUyZiIsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyJhZG1pbiJdfSwiaWF0IjoxNjczOTQ5ODc5fQ.wnVlLJ2o_yRTkcfsAbSZN666PeWpfKGyGSDJbszn82c","expires":1673949939925}'
    session = json.loads(session)
    
    return session['csrfToken'],session['authToken']

def populate_db(imsi : int, cookie : str, session: str):
    ip = get_docker_ip(".env")
    connect_sid = {"connect.sid":cookie}
    endpoint = "db/Subscriber"
    body = copy.copy(template)
    body['imsi'] = str(imsi)
    print(f" -- Registering {imsi}")
    csrf, auth = parse_session(session=session)
    response = requests.post(url=f"http://{ip}:3000/api/db/Subscriber", data=json.dumps(body), headers={"Authorization":f"Bearer {auth}", "X-CSRF-TOKEN": csrf, "Content-Type":"application/json;charset=utf-8", "Origin":"http://localhost:3000", "Referer":"http://localhost:3000/", "Sec-Fetch-Site":"same-origin", "Sec-Fetch-Mode":"cors", "Sec-Fetch-Dest":"empty", "Host": "localhost:3000"}, cookies=connect_sid)
    if response.status_code != 201:
        if response.status_code == 400 and "duplicate key error" in response.text:
            print("     --- already registered")
            return
        print(f"    --- Fatal {response.status_code}")
        print(f"    --- {response.text}")
        exit(1)
    print("     --- OK")

#populate_db(999990154321052,
# "s%3AVtEIMt8aBsglqte8TwYvssoP-SsT5-1f.52HrVliHyvq6fLICoNClDGD9cn8r5TRv4KVyB%2BJCDhQ", 
# '{"clientMaxAge":60000,"csrfToken":"KC7vfKyqITGQSmsSJQX/hMQET/jOrLSrDMCAo=","user":{"_id":"63c65ef836be63209544152f","username":"admin","__v":0,"roles":["admin"]},"authToken":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyIjp7Il9pZCI6IjYzYzY1ZWY4MzZiZTYzMjA5NTQ0MTUyZiIsInVzZXJuYW1lIjoiYWRtaW4iLCJyb2xlcyI6WyJhZG1pbiJdfSwiaWF0IjoxNjczOTUwOTk4fQ.8GO-ZmO4p62EvnPgny5ESaz_lX0TB8YgF1ZlVkvMt-A","expires":1673951058191}'
#)

import argparse

parser = argparse.ArgumentParser(description="Populate open5gs DB with subscribers. You need to first login at the admin panel of Mongo (if standard open5gs go to http://localhost:3000, user=admin, pw=1423), then with browser console, in storage, please get the connection.sid cookie value and the session value")
parser.add_argument('-i', '--imsi', nargs=1, type=int, help="starting imsi as int (e.g 99970...) (follows UERANSIM progression of IMSIs)")
parser.add_argument('-n', '--num', nargs=1,type=int, help="number of subscribers. The first will have the starting IMSI, then IMSI +1 and so on...")
parser.add_argument('-c', '--cookie', nargs=1, type=str, help="connection.sid cookie for MongoDB")
parser.add_argument('-s', '--session', nargs=1, type=str, help="session json string for MongoDB. [!] Put it around brackets '...' !!")

if __name__ == "__main__":
    args = vars(parser.parse_args())
    
    for i in range(0, args['num'][0]):
        populate_db(args['imsi'][0]+i, args['cookie'][0], args['session'][0])
        time.sleep(0.01)