# Test series 3

### Test 1 - 200 users locally using stripped-down API

Taking a dynamodb query and isolating it from the rest of the application logic to determine if the 
problem is dynamodb or the application. 

Parameters: 
- 200 users at hatch-rate of 20
- Single user with one notification on the actual applicaiton table (same as test 2)
- Running locally on laptop, under identical conditions to test-series 2. 
- No application logic, purely a hardcoded query being passed straight to the AWS SDK

Results: 
- Low CPU usage at around 30%
- 45 RPS, nearly idendical behaviour to the application
- Median latency of 800 ms with an average of 2700 ms
- Small quantity of failures in the same manner as before at 1% of requests
- Low recipientIndex consumption in Dynamodb at around 20
- Query latency of about 5 ms

This fairly conclusively proves that the query is the limiting factor and not the application code as was thought. 


### Test 1 - 400 users locally using stripped-down API

Doubling the pressure just to be sure

Parameters: 
- 400 users at hatch-rate of 20
- Single user with one notification on the actual applicaiton table (same as test 2)
- Running locally on laptop, under identical conditions to test-series 2. 
- No application logic, purely a hardcoded query being passed straight to the AWS SDK

Results: 
- Low CPU usage at around 30%
- 35-30 RPS, nearly idendical behaviour to the application
- Median latency of 3.1 seconds with an average of about 8 seconds 
- Small quantity of failures in the same manner as before at 1% of requests
- Low recipientIndex consumption in Dynamodb at around 20
- Query latency of about 6 ms

In this instance performance actually degraded in terms of RPS. Everything else was unchanged. 
