#!/bin/bash
for i in {1000..2000}
do
    curl localhost:3000/$i -X PUT -H "content-type: application/json"  -d '{"lookup":"123","data":"bar"}'
done
