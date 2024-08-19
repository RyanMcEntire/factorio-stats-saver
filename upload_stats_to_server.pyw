import os
import json
import requests
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler

class StatsFileHandler(FileSystemEventHandler):
    def __init__(self, file_path, upload_url):
        self.file_path = file_path
        self.upload_url = upload_url

    def on_modified(self, event):
        if event.src_path == self.file_path:
            self.upload_file()

    def upload_file(self):
        with open(self.file_path, 'r') as file:
            data = json.load(file)
            response = requests.post(self.upload_url, json=data)

def main():
    production_file = '/script-output/production_stats.json'
    consumption_file = '/script-output/consumption_stats.json'
    server_url = 'https://temp-server-link.com/upload'

    event_handler_prod = StatsFileHandler(production_file, server_url)
    event_handler_cons = StatsFileHandler(consumption_file, server_url)
    observer = Observer()
    observer.schedule(event_handler_prod, path=os.path.dirname(production_file), recursive=False)
    observer.schedule(event_handler_cons, path=os.path.dirname(consumption_file), recursive=False)
    observer.start()

    try:
        while True:
            pass
    except KeyboardInterrupt:
        observer.stop()
    observer.join()

if __name__ == "__main__":
    main()