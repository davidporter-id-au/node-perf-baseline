from locust import HttpLocust, TaskSet, task

with open('/tmp/sws') as f:
        line = f.readlines()
        sws = line[0]
        sws = sws.strip()

headers = {"Authorization": str(sws)}

print(headers)

class WebsiteTasks(TaskSet):
    @task
    def index(self):
        self.client.get("/communications/", headers = headers)

class WebsiteUser(HttpLocust):
    task_set = WebsiteTasks
    min_wait = 1000
    max_wait = 1000
