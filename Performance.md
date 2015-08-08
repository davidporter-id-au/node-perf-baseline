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
- Max/min wait times for locust users: 1000/1000
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

### 8/8/2015 - Single t2 instance from m4 large @200 users

Circumstance: 
- Webserver running in Docker on a t2 small instance 
- Load-test tool running on an m4.large instance in the same VPC

Tools: 
- Locust.io

Parameters: 
- Users: 200
- Ramp up: 20 per second
- Max/min wait times for locust users: 1000/1000
- provisioned IOPs on index 100
- Fetching a single dynamodb record

Result: 
- Average approximately 100-132 RPS and appears stable
- Peak Provisioned IOPs capcacity consumed: 62
- CPU usage: approximately 52% and apparently stable
- Network in stable at 33099830 (33 Megabytes per 5 minutes or 110.333 KBp/s)
- Network in stable at 23622817 
- CPU Credit usage: stable at 3
- Zero failed requests

Instance is bursting CPU, not yet bound. Appears to be stable and performing better than the laptop test. 
Latency is better than when testing on local laptop with a median response time of 660ms. 

```
| #-failures | Median response-time | Average-response-time | Min-response-time | Max-response-time | Average-Content-Size | Requests/s |
|          0 |                  660 |                   589 |                13 |              2295 |                   29 |     124.75 |
|          0 |                  660 |                   589 |                13 |              2295 |                   29 |     124.75 |
```

RESPONSE time distribution: 
```
| Name | #     | requests | 50% | 66% | 75% | 80% | 90% | 95% | 98% |  99% | 100% |
| GET  | /123  |   211179 | 660 | 700 | 740 | 760 | 820 | 860 | 950 | 1100 | 2969 |
| None | Total |   211179 | 660 | 700 | 740 | 760 | 820 | 860 | 950 | 1100 | 2969 |
```

### 8/8/2015 - Single t2 instance from m4 large @400 users

Circumstance: 
- Webserver running in Docker on a t2 small instance 
- Load-test tool running on an m4.large instance in the same VPC

Tools: 
- Locust.io

Parameters: 
- Users: 400
- Ramp up: 20 per second
- Max/min wait times for locust users: 1000/1000
- provisioned IOPs on index 100
- Fetching a single dynamodb record

Result: 
- Approximately 130-170 requests per second
- Dynamodb IOPs consumption steady at about 77 
- Average CPU utilization steady at 73%
- CPU credit usage steady at 3.73
- zero failures

Doubling the number of concurrent requests has increased total throughput by about 20%. 
Median Latency has increased by about 150%

Instance is bursting CPU and is close to becoming CPU bound already. Median latency has significantly increased in a proportially larger percentage
than the change RPS. I doubt significantly more load can be squeezed out of the instance. Once the CPU credits are consumed fully it's likely performance 
will degrade. 

IOPS are still under the threshold provisioned and are not a problem. 

```
| # requests | # failures | Median response time | Average response time | Min response time | Max response time | Average Content Size | Requests/s |
|     173168 |          0 |                 1700 |                  1581 |                14 |              3412 |                   29 |     153.41 |
|     173168 |          0 |                 1700 |                  1581 |                14 |              3412 |                   29 |     153.41 |
```

```
| Name | #     | requests | 50% | 66% | 75% | 80% | 90% | 95% | 98% |  99% | 100% |
| GET  | /123  |   211179 | 660 | 700 | 740 | 760 | 820 | 860 | 950 | 1100 | 2969 |
| None | Total |   211179 | 660 | 700 | 740 | 760 | 820 | 860 | 950 | 1100 | 2969 |
```
