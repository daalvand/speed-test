package main;
import (
    "fmt"
    "log"
    "net/http"
)
func main() {
    http.HandleFunc("/hello-world", func(w http.ResponseWriter, r *http.Request){
        fmt.Fprintf(w, "Hello World")
    })
    fmt.Printf("Server running (port=80), route: http://localhost:80/hello-world\n")
    if err := http.ListenAndServe(":80", nil); err != nil {
        log.Fatal(err)
    }
}