## PromQL Queries

---

### 1. System Uptime

**Seconds since the system last booted**

```promql
node_time_seconds - node_boot_time_seconds
```

---

### 2. Total Memory

**Total physical memory (bytes)**

```promql
node_memory_MemTotal_bytes
```

---

### 3. Used Memory

**Used memory (bytes)**

```promql
node_memory_MemTotal_bytes
- node_memory_MemAvailable_bytes
```

**Used memory (%)**

```promql
(
  node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes
)
/
node_memory_MemTotal_bytes * 100
```

---

### 4. Total CPU Cores

**Logical CPU core count**

```promql
count(node_cpu_seconds_total{mode="idle"}) by (instance)
```

---

### 5. Used CPU

**CPU usage percentage**

```promql
100 - (
  avg by (instance) (
    rate(node_cpu_seconds_total{mode="idle"}[5m])
  ) * 100
)
```

---

### 6. Idle CPU

**Idle CPU percentage**

```promql
avg by (instance) (
  rate(node_cpu_seconds_total{mode="idle"}[5m])
) * 100
```

---

### 7. Free Memory

**Available memory (bytes)**

```promql
node_memory_MemAvailable_bytes
```

---

### 8. Total Root Disk

**Root filesystem size (bytes)**

```promql
node_filesystem_size_bytes{mountpoint="/", fstype!~"tmpfs|overlay"}
```

---

### 9. Available Root Disk Space

**Available disk space (bytes)**

```promql
node_filesystem_avail_bytes{mountpoint="/", fstype!~"tmpfs|overlay"}
```

**Used disk (%)**

```promql
(
  node_filesystem_size_bytes{mountpoint="/", fstype!~"tmpfs|overlay"}
  - node_filesystem_avail_bytes{mountpoint="/", fstype!~"tmpfs|overlay"}
)
/
node_filesystem_size_bytes{mountpoint="/", fstype!~"tmpfs|overlay"} * 100
```

---

### 10. Network Usage

**Total network bandwidth (bytes/sec)**

```promql
sum by (instance) (
  rate(node_network_receive_bytes_total{device!~"lo"}[5m])
+
  rate(node_network_transmit_bytes_total{device!~"lo"}[5m])
)
```

---

### 11. Packets Sent

**Packets transmitted per second**

```promql
sum by (instance) (
  rate(node_network_transmit_packets_total{device!~"lo"}[5m])
)
```

---

### 12. Packets Received

**Packets received per second**

```promql
sum by (instance) (
  rate(node_network_receive_packets_total{device!~"lo"}[5m])
)
```

---
