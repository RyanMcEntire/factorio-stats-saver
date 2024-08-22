import os
import json
import time
import requests
import psutil
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import logging

# Set up logging
log_file = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'factorio_stats_watcher.log')
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(message)s',
    datefmt='%Y-%m-%d %H:%M:%S',
    filename=log_file,
    filemode='a'
)

class StatsFileHandler(FileSystemEventHandler):
    def __init__(self, file_path, upload_url):
        self.file_path = file_path
        self.upload_url = upload_url

    def on_modified(self, event):
        if event.src_path == self.file_path:
            self.upload_file()

    def upload_file(self):
        try:
            with open(self.file_path, 'r') as file:
                data = json.load(file)
                response = requests.post(self.upload_url, json=data)
                if response.status_code == 200:
                    logging.info(f"Uploaded data from {os.path.basename(self.file_path)}")
                else:
                    logging.error(f"Failed to upload {os.path.basename(self.file_path)}. Status: {response.status_code}")
        except Exception as e:
            logging.error(f"Error uploading {os.path.basename(self.file_path)}: {str(e)}")

def is_factorio_running():
    return 'factorio.exe' in (p.name().lower() for p in psutil.process_iter(['name']))

def main():
    production_file = os.path.join(script_dir, '..', 'script-output', 'production_stats.json') 
    consumption_file = os.path.join(script_dir, '..', 'script-output', 'consumption_stats.json')
    server_url = 'https://localhost:3000/upload'

    event_handler_prod = StatsFileHandler(production_file, server_url)
    event_handler_cons = StatsFileHandler(consumption_file, server_url)

    observer = Observer()
    observer.schedule(event_handler_prod, path=os.path.dirname(production_file), recursive=False)
    observer.schedule(event_handler_cons, path=os.path.dirname(consumption_file), recursive=False)
    observer.start()

    logging.info("File watcher started")

    try:
        while is_factorio_running():
            time.sleep(5)
        logging.info("Factorio stopped. Shutting down watcher")
    except KeyboardInterrupt:
        logging.info("Keyboard interrupt. Shutting down watcher")
    finally:
        observer.stop()
        observer.join()
        logging.info("File watcher stopped")

if __name__ == "__main__":
    main()
