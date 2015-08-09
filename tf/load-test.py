from locust import HttpLocust, TaskSet, task
import random

class WebsiteTasks(TaskSet):
    @task
    def index(self):
        self.client.get("/" + str((int)(random.random() * 1000 + 1000)))

class WebsiteUser(HttpLocust):
    task_set = WebsiteTasks
    min_wait = 1000
    max_wait = 1000
