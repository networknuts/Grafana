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
    Collect metrics for all running processes with proper CPU calculation
    """
    # Get initial CPU measurements for all processes
    process_dict = {}
    for proc in psutil.process_iter(['pid', 'name']):
        try:
            # Store the process object
            process_dict[proc.pid] = proc
            # Initialize CPU measurement
            proc.cpu_percent(interval=None)
        except (psutil.NoSuchProcess, psutil.AccessDenied, psutil.ZombieProcess):
            pass
    
    # Wait for a short interval to get meaningful CPU measurements
    time.sleep(1)
    
    # Now collect the actual metrics
    for pid, proc in process_dict.items():
        try:
            if not proc.is_running():
                continue
                
            # Get process details
            process_name = proc.name()
            
            # Get accurate CPU usage after the interval
            cpu_usage = proc.cpu_percent(interval=None)
            PROCESS_CPU_USAGE.labels(pid=pid, process_name=process_name).set(cpu_usage)
            
            # Rest of your metrics
            memory_info = proc.memory_info()
            PROCESS_MEMORY_USAGE.labels(pid=pid, process_name=process_name).set(memory_info.rss)
            
            try:
                open_files_count = len(proc.open_files())
                PROCESS_OPEN_FILES.labels(pid=pid, process_name=process_name).set(open_files_count)
            except (psutil.AccessDenied, psutil.NoSuchProcess):
                pass
                
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
