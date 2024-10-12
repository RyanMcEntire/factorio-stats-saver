import os
import json
import time
import requests
import psutil
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import logging
import urllib3
import time
from dotenv import load_dotenv

load_dotenv()

urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

log_file = os.path.join(
    os.path.dirname(os.path.abspath(__file__)), "factorio_stats_watcher.log"
)
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
    filename=log_file,
    filemode="a",
)

API_KEY = os.getenv("API_KEY_2")
UPLOAD_SERVER_URL = os.getenv("UPLOAD_SERVER_URL")


class StatsFileHandler(FileSystemEventHandler):
    def __init__(self, file_path, upload_url):
        self.file_path = file_path
        self.upload_url = upload_url
        self.last_modified = 0
        self.debounce_time = 1

    def on_modified(self, event):
        if event.src_path == self.file_path:
            current_time = time.time()
            if current_time - self.last_modified > self.debounce_time:
                self.last_modified = current_time
                self.upload_file()

    def upload_file(self):
        try:
            with open(self.file_path, "r") as file:
                data = json.load(file)
                headers = {"X-API-Key": API_KEY}
                response = requests.post(self.upload_url, json=data, headers=headers)
                if response.status_code == 200:
                    print("Uploaded data from {os.path.basename(self.file_path)}")
                    logging.info(
                        f"Uploaded data from {os.path.basename(self.file_path)}"
                    )
                else:
                    print(
                        "Failed to upload {os.path.basename(self.file_path)}. Status: {response.status_code}"
                    )
                    print(f"Response content: {response.text}")
                    logging.error(
                        f"Failed to upload {os.path.basename(self.file_path)}. Status: {response.status_code}"
                    )
                    logging.error(f"Response content: {response.text}")
        except Exception as e:
            print("Error uploading {os.path.basename(self.file_path)}: {str(e)}")
            logging.error(
                f"Error uploading {os.path.basename(self.file_path)}: {str(e)}"
            )


def is_factorio_running():
    return "factorio.exe" in (p.name().lower() for p in psutil.process_iter(["name"]))


def main():
    time.sleep(5)

    script_dir = os.path.dirname(os.path.abspath(__file__))
    stats_file = os.path.join(script_dir, "..", "script-output", "stats.json")
    server_url = UPLOAD_SERVER_URL

    event_handler = StatsFileHandler(stats_file, server_url)

    observer = Observer()
    observer.schedule(event_handler, path=os.path.dirname(stats_file), recursive=False)
    observer.start()

    print("File watcher started")
    logging.info("File watcher started")

    try:
        while is_factorio_running():
            time.sleep(5)
        print("Factorio stopped. Shutting down watcher")
        logging.info("Factorio stopped. Shutting down watcher")
    except KeyboardInterrupt:
        print("Keyboard interrupt. Shutting down watcher")
        logging.info("Keyboard interrupt. Shutting down watcher")
    finally:
        observer.stop()
        observer.join()
        print("File watcher stopped")
        logging.info("File watcher stopped")


if __name__ == "__main__":
    main()
