import psutil
import time
from prometheus_client import start_http_server, Gauge

# Define Prometheus metrics for process information
PROCESS_CPU_USAGE = Gauge(
    'process_cpu_usage', 
    'CPU usage percentage for a specific process', 
    ['pid', 'process_name']
)

PROCESS_MEMORY_USAGE = Gauge(
    'process_memory_usage_bytes', 
    'Memory usage in bytes for a specific process', 
    ['pid', 'process_name']
)

PROCESS_OPEN_FILES = Gauge(
    'process_open_files', 
    'Number of open files for a specific process', 
    ['pid', 'process_name']
)

PROCESS_THREADS = Gauge(
    'process_threads', 
    'Number of threads for a specific process', 
    ['pid', 'process_name']
)

def collect_process_metrics():
    """
    Collect metrics for all running processes
    """
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            # Get process details
            pid = proc.info['pid']
            process_name = proc.info['name']

            # Collect CPU usage
            cpu_usage = proc.cpu_percent(interval=0.1)
            PROCESS_CPU_USAGE.labels(pid=pid, process_name=process_name).set(cpu_usage)

            # Collect Memory Usage
            memory_info = proc.memory_info()
            PROCESS_MEMORY_USAGE.labels(pid=pid, process_name=process_name).set(memory_info.rss)

            # Collect Open Files
            try:
                open_files_count = len(proc.open_files())
                PROCESS_OPEN_FILES.labels(pid=pid, process_name=process_name).set(open_files_count)
            except (psutil.AccessDenied, psutil.NoSuchProcess):
                pass

            # Collect Thread Count
            thread_count = proc.num_threads()
            PROCESS_THREADS.labels(pid=pid, process_name=process_name).set(thread_count)

        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            # Handle cases where process might have terminated
            pass

def main():
    # Start up the server to expose the metrics
    start_http_server(8000)
    
    # Collect metrics periodically
    while True:
        collect_process_metrics()
        time.sleep(15)  # Collect metrics every 15 seconds

if __name__ == '__main__':
    main()
