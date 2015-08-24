# Test series 2

API under test for comparison: 

### Test 1 - 200 users for actual api for user with a single communication 

Parameters: 
- 200 users via locust with a hatch-rate of 20. 
- Test user (me) is being fetched. 
- User has a single communication (as per output.json)
- Test running locally on laptop
- Dynamodb IOPs on recipientIndex at 100 
- ADSL connection via Lan cable uninterrupted
- Running iojs 3.0.0

Results: 
- Very steady average of 45 RPS
- CPU usage of around 26-30%
- Dynamodb recipientIndex shows a consistent read consumption of 20
- Median latency of `800`ms, with a significantly higher average of `2050`ms indicating a number of outliers are skewing upwards
- Consistent errors in connection being reported at around 1% of communications
- zero exceptions 

Errors: 
- 45  GET /communications/    ConnectionError(ProtocolError('Connection aborted.', BadStatusLine("''",)),)
- 56  GET /communications/    ConnectionError(ProtocolError('Connection aborted.', gaierror(8, 'nodename nor servname provided, or not known')),)

Statistics

```
Type    Name    # requests  # fails Median  Average Min Max Content Size    # reqs/sec
GET /communications/    18065   522 790 2530    189 119595  1001    46.1
Total   18065   522 790 2530    189 119595  1001    46.1
```

### Test 2 - 400 users for actual PI for user with single communication

Parameters: 
- 400 users via locust with a hatch-rate of 20. 
- Test user (me) is being fetched. 
- User has a single communication (as per output.json)
- Test running locally on laptop
- Dynamodb IOPs on recipientIndex at 100 
- ADSL connection via Lan cable uninterrupted
- Running iojs 3.0.0

Results: 
- Very steady average of 45 RPS (that's correct, unchanged from 200 users)
- CPU usage of around 36%
- 77% of requests are failing 
- Median response time is 1000ms with average of 3000

Note: There was possibly a misconfiguration of the shell variables for this test, so it's validity is questionable. 
I'll redo it. 

### Test 3 - 400 users for actual PI for user with single communication

Parameters: 
- 400 users via locust with a hatch-rate of 20. 
- Test user (me) is being fetched. 
- User has a single communication (as per output.json)
- Test running locally on laptop
- Dynamodb IOPs on recipientIndex at 100 
- ADSL connection via Lan cable uninterrupted
- Running iojs 3.0.0

Results: 
- Very steady average of 40 RPS 
- CPU usage of around 26-36%
- Some errors (around 1%)
- Dynamodb read capacity approximately 20 for the recipientIndex
- Median response time of 2700ms with an average of 7.1 seconds. 

Errors: 
- 141 GET /communications/    ConnectionError(ProtocolError('Connection aborted.', BadStatusLine("''",)),)

Statistics: 

```
Type    Name    # requests  # fails Median  Average Min Max Content Size    # reqs/sec
GET /communications/    13291   141 2700    7149    173 119606  1001    39.7
Total   13291   141 2700    7149    173 119606  1001    39.7
```
