import os
import json
import time
import requests
import psutil
from watchdog.observers import Observer
from watchdog.events import FileSystemEventHandler
import logging
import urllib3
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


class StatsFileHandler(FileSystemEventHandler):
    def __init__(self, file_path, upload_url):
        self.file_path = file_path
        self.upload_url = upload_url

    def on_modified(self, event):
        if event.src_path == self.file_path:
            self.upload_file()

    def upload_file(self):
        try:
            with open(self.file_path, "r") as file:
                data = json.load(file)
                headers = {"X-API-Key": API_KEY}
                # REMOVE VERIFY=FALSE IN PRODUCTION
                response = requests.post(
                    self.upload_url, json=data, headers=headers, verify=False
                )
                if response.status_code == 200:
                    logging.info(
                        f"Uploaded data from {os.path.basename(self.file_path)}"
                    )
                else:
                    logging.error(
                        f"Failed to upload {os.path.basename(self.file_path)}. Status: {response.status_code}"
                    )
        except Exception as e:
            logging.error(
                f"Error uploading {os.path.basename(self.file_path)}: {str(e)}"
            )


def is_factorio_running():
    return "factorio.exe" in (p.name().lower() for p in psutil.process_iter(["name"]))


def main():
    time.sleep(10)

    script_dir = os.path.dirname(os.path.abspath(__file__))
    stats_file = os.path.join(script_dir, "..", "script-output", "stats.json")
    server_url = "https://localhost:3000/upload"

    event_handler = StatsFileHandler(stats_file, server_url)

    observer = Observer()
    observer.schedule(event_handler, path=os.path.dirname(stats_file), recursive=False)
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
