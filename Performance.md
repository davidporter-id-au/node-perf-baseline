# Performance log: 

This is a record of the quantitative data from the performance tests used by this repo: 

### 7/8/2015 - local test of getting records by id:  (test 0)

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

### 8/8/2015 - Single t2 instance from m4 large @200 users (test 1)

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

### 8/8/2015 - Single t2 instance from m4 large @400 users (test 2)

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

### 9/8/2015 - Single t2 instance from m4 large @200 users with 1000 records (test 3)

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
- Fetching dynamodb records [1000..2000] at random


Result:

- Approximately 130 requests per second
- CPU usage stable at 55% 
- IOPS consumption consistent at 65
- Zero exceptions
- Median latency of 620 ms

Results appear to be more or less identical to the single-record. To me this indicates caching or sharding effects are likely not significant at this scale.

```
|       | # requests | # failures | Median response time | Average response time | Min response time | Max response time | Average Content Size | Requests/s |
| Total |     406901 |          0 |                  620 |                   551 |                13 |              2032 |                   29 |     127.68 |
```


### 9/8/2015 - Single t2 instance from m4 large @300 users with 1000 records (test 4)

Circumstance: 
- Webserver running in Docker on a t2 small instance 
- Load-test tool running on an m4.large instance in the same VPC

Tools: 
- Locust.io

Parameters: 
- Users: 300
- Ramp up: 20 per second
- Max/min wait times for locust users: 1000/1000
- provisioned IOPs on index 100
- Fetching dynamodb records [1000..2000] at random

Result: 
- Approximately 130-160 requests per second
- CPU usage stable at 66% 
- IOPS consumption at 68
- Zero exceptions
- CPU credit usage: 2.5
- Median latency of 1200ms

```
| Name  | # requests | # failures | Median response time | Average response time | Min response time | Max response time | Average Content Size | Requests/s |
| Total |     135324 |          0 |                 1200 |                  1106 |                14 |              1969 |                   29 |     141.11 |
```

### 9/8/2015 - Single t2 instance from m4 large @100 users with 1000 records (test 5)

Circumstance: 
- Webserver running in Docker on a t2 small instance 
- Load-test tool running on an m4.large instance in the same VPC

Tools: 
- Locust.io

Parameters: 
- Users: 100
- Ramp up: 20 per second
- Max/min wait times for locust users: 1000/1000
- provisioned IOPs on index 100
- Fetching dynamodb records [1000..2000] at random

Results: 
- 75-90 Requests per second
- Median latency of about 270ms


### 9/8/2015 - Single t2 instance from m4 large @600 users with 1000 records - Exhaused burstable CPU credits (test 6)

Circumstance: 
- Webserver running in Docker on a t2 small instance 
- Load-test tool running on an m4.large instance in the same VPC
- Tests have been running for a while and CPU credits are now exhausted

Tools: 
- Locust.io

Parameters: 
- Users: 100
- Ramp up: 20 per second
- Max/min wait times for locust users: 1000/1000
- provisioned IOPs on index 100
- Fetching dynamodb records [1000..2000] at random

Results: 
- 40-50 Requests per second
- Median latency of 10000ms exactly
- load average: 1.64, 1.67, 1.68
- CPU usage 35%
- Consumed IOPS appears to be varying somewhat, but doesn't appear to exceed 20
- Zero failures

Curling the machine from my laptop I wait a couple of seconds before receiving a reply, but it nonetheless 
completes correctly with the data from dynamodb. 

After the results of test 7 differed so significantly from test-2, it seems likely that this poor performance is a result of  
CPU credits having been consumed due to the serial testing I was performing and not controlling for.  

```
| Name  | # requests | # fails | Median | Average |  Min |   Max | Content Size | # reqs/sec |
| Total |      24167 |       0 |  10000 |   10761 | 7404 | 17425 |           29 |       35.2 |
```

### 9/8/2015 - Single t2 instance from m4 large @400 users with 1000 records - Exhaused burstable CPU credits (test 7)

Circumstance: 
- Webserver running in Docker on a t2 small instance 
- Load-test tool running on an m4.large instance in the same VPC
- Tests have been running for a while and CPU credits are now exhausted

Tools: 
- Locust.io

Parameters: 
- Users: 400
- Ramp up: 20 per second
- Max/min wait times for locust users: 1000/1000
- provisioned IOPs on index 100
- Fetching dynamodb records [1000..2000] at random
- starting CPU Credit Balance: 0

Results: 
- 40-50 Requests per second
- Median latency of about 7900 ms 
- Average CPU usage steady at 20%
- CPU credit usage steady at 1
- Zero failures

This test is a reproduction of test 2 which differes in two ways: 1) the dynamodb key distribution is different and the available CPU credits is 
now zero as opposed to full in test 2.

Operating without the CPU credit that would have been afforted to test 2 under otherwise the same conditions leads me to believe the instance is CPU
bound, but reported as being such due to the way in which burstable infrastructure must operate.  

```
| Name  | # requests | # failures | Median response time | Average response time | Min response time | Max response time | Average Content Size | Requests/s |
| Total |      19544 |          0 |                 8200 |                  7805 |                28 |              9742 |                   29 |      45.82 |
```

### 9/8/2015 - Single t2 instance from m4 large @200 users with 1000 records - Exhaused burstable CPU credits (test 8)

Circumstance: 
- Webserver running in Docker on a t2 small instance 
- Load-test tool running on an m4.large instance in the same VPC
- Tests have been running for a while and CPU credits are now exhausted

Tools: 
- Locust.io

Parameters: 
- Users: 200
- Ramp up: 20 per second
- Max/min wait times for locust users: 1000/1000
- provisioned IOPs on index 100
- Fetching dynamodb records [1000..2000] at random
- starting CPU Credit Balance: 0

Results: 
- 40-50 Requests per second
- CPU % usage approximately 17%
- CPU credit usage steady at 0.88
- CPU credit balance at 0.12
- Zero failures

At 200 users, the latency is still high, performance is not significantly increased or even changed from the results of test 7. 

```
| Name  | # requests | # fails | Median | Average | Min |  Max | Content Size | # reqs/sec |
| Total |      18497 |       0 |   3800 |    3845 |  16 | 8522 |           29 |       40.4 |
```
