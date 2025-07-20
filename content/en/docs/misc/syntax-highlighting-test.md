---
title: "Syntax Highlighting Test Page"
linkTitle: "Syntax Test"
description: "This page demonstrates code syntax highlighting capabilities across different programming languages."
author: llm-kun
date: 2025-07-16
---

## Python Examples

### Basic Function

```python
def fibonacci(n):
    """Calculate the nth Fibonacci number."""
    if n <= 1:
        return n
    return fibonacci(n-1) + fibonacci(n-2)

# Test the function
for i in range(10):
    print(f"F({i}) = {fibonacci(i)}")
```

### Class Definition

```python
class Transformer:
    def __init__(self, num_layers, d_model):
        self.num_layers = num_layers
        self.d_model = d_model
        self.layers = []
        
    def forward(self, x):
        for layer in self.layers:
            x = layer(x)
        return x
    
    def add_layer(self, layer):
        self.layers.append(layer)
```

## JavaScript Examples

### Async Function

```javascript
async function fetchUserData(userId) {
    try {
        const response = await fetch(`/api/users/${userId}`);
        if (!response.ok) {
            throw new Error('User not found');
        }
        return await response.json();
    } catch (error) {
        console.error('Error fetching user:', error);
        return null;
    }
}

// Usage
fetchUserData(123).then(user => {
    console.log('User:', user);
});
```

### React Component

```jsx
import React, { useState, useEffect } from 'react';

function UserProfile({ userId }) {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    
    useEffect(() => {
        fetchUserData(userId)
            .then(userData => {
                setUser(userData);
                setLoading(false);
            });
    }, [userId]);
    
    if (loading) return <div>Loading...</div>;
    if (!user) return <div>User not found</div>;
    
    return (
        <div className="user-profile">
            <h2>{user.name}</h2>
            <p>{user.email}</p>
        </div>
    );
}
```

## Go Examples

### HTTP Server

```go
package main

import (
    "encoding/json"
    "log"
    "net/http"
)

type User struct {
    ID    int    `json:"id"`
    Name  string `json:"name"`
    Email string `json:"email"`
}

func handleUsers(w http.ResponseWriter, r *http.Request) {
    users := []User{
        {ID: 1, Name: "Alice", Email: "alice@example.com"},
        {ID: 2, Name: "Bob", Email: "bob@example.com"},
    }
    
    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(users)
}

func main() {
    http.HandleFunc("/api/users", handleUsers)
    log.Fatal(http.ListenAndServe(":8080", nil))
}
```

### Goroutine Example

```go
package main

import (
    "fmt"
    "sync"
    "time"
)

func worker(id int, jobs <-chan int, results chan<- int, wg *sync.WaitGroup) {
    defer wg.Done()
    for job := range jobs {
        fmt.Printf("Worker %d processing job %d\n", id, job)
        time.Sleep(time.Second)
        results <- job * 2
    }
}

func main() {
    jobs := make(chan int, 100)
    results := make(chan int, 100)
    
    var wg sync.WaitGroup
    
    // Start workers
    for w := 1; w <= 3; w++ {
        wg.Add(1)
        go worker(w, jobs, results, &wg)
    }
    
    // Send jobs
    for j := 1; j <= 9; j++ {
        jobs <- j
    }
    close(jobs)
    
    wg.Wait()
    close(results)
    
    // Collect results
    for result := range results {
        fmt.Printf("Result: %d\n", result)
    }
}
```

## Rust Examples

### Basic Struct

```rust
#[derive(Debug, Clone)]
struct Point {
    x: f64,
    y: f64,
}

impl Point {
    fn new(x: f64, y: f64) -> Self {
        Point { x, y }
    }
    
    fn distance(&self, other: &Point) -> f64 {
        let dx = self.x - other.x;
        let dy = self.y - other.y;
        (dx * dx + dy * dy).sqrt()
    }
}

fn main() {
    let p1 = Point::new(0.0, 0.0);
    let p2 = Point::new(3.0, 4.0);
    println!("Distance: {}", p1.distance(&p2));
}
```

## SQL Examples

### Complex Query

```sql
WITH user_stats AS (
    SELECT 
        u.id,
        u.name,
        COUNT(p.id) as post_count,
        AVG(p.rating) as avg_rating
    FROM users u
    LEFT JOIN posts p ON u.id = p.user_id
    WHERE u.created_at >= '2024-01-01'
    GROUP BY u.id, u.name
)
SELECT 
    name,
    post_count,
    ROUND(avg_rating, 2) as avg_rating
FROM user_stats
WHERE post_count > 0
ORDER BY avg_rating DESC
LIMIT 10;
```

## Shell Script Examples

### Bash Script

```bash
#!/bin/bash

# Configuration
BACKUP_DIR="/backup"
LOG_FILE="/var/log/backup.log"
RETENTION_DAYS=30

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Check if backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    mkdir -p "$BACKUP_DIR"
    log_message "Created backup directory: $BACKUP_DIR"
fi

# Perform backup
log_message "Starting backup process..."
tar -czf "$BACKUP_DIR/backup-$(date +%Y%m%d).tar.gz" /data

if [ $? -eq 0 ]; then
    log_message "Backup completed successfully"
else
    log_message "Backup failed with exit code $?"
    exit 1
fi

# Clean up old backups
find "$BACKUP_DIR" -name "backup-*.tar.gz" -mtime +$RETENTION_DAYS -delete
log_message "Cleaned up backups older than $RETENTION_DAYS days"
```

## YAML Examples

### Docker Compose

```yaml
version: '3.8'

services:
  web:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx.conf:/etc/nginx/nginx.conf
      - ./ssl:/etc/nginx/ssl
    environment:
      - NGINX_HOST=localhost
      - NGINX_PORT=80
    depends_on:
      - app

  app:
    build: .
    environment:
      - DATABASE_URL=postgresql://user:pass@db:5432/myapp
      - REDIS_URL=redis://redis:6379
    depends_on:
      - db
      - redis

  db:
    image: postgres:13
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: pass
    volumes:
      - postgres_data:/var/lib/postgresql/data

  redis:
    image: redis:alpine
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

volumes:
  postgres_data:
  redis_data:
```

## HTML/CSS Examples

### Responsive Layout

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Responsive Layout</title>
    <style>
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
        }
        
        .card {
            background: #fff;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        @media (max-width: 768px) {
            .grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="grid">
            <div class="card">
                <h3>Card 1</h3>
                <p>This is a responsive card layout.</p>
            </div>
            <div class="card">
                <h3>Card 2</h3>
                <p>Cards will stack on mobile devices.</p>
            </div>
        </div>
    </div>
</body>
</html>
```

This demonstrates syntax highlighting for various programming languages and markup formats on your KintaroAI documentation site! 