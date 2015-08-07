# Performance log: 

This is a record of the quantitative data from the performance tests used by this repo: 

### 7/8/2015 - local test of getting records by id: 

Circumstance: 
- Webserver running locally on laptop with iojs 2.2.1 
- Load-test tool running locally hitting localhost:3000

Tools: 
- Locust.io

Parameters: 
- Users: 200
- Ramp up: 2 per second
- provisioned IOPs on index 100
  
Result: 
- Average approximately 100-121 RPS
- Peak Provisioned IOPs capcacity consumed: 51
- CPU usage: approximately 40-50%

```
| Method | Name  | # requests | # failures | Median response time | Average response time | Min response time | Max response time | Average Content Size | Requests/s |
| GET    | /123  |     133103 |          2 |                  380 |                  1018 |               219 |             93294 |                   29 |      99.14 |
| None   | Total |     133103 |          2 |                  380 |                  1018 |               219 |             93294 |                   29 |      99.14 |
```
