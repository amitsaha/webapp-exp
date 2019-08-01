package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
)

type testData struct {
	Name string
}

func healthcheck(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "OK")
}

func handlePostRequest(w http.ResponseWriter, r *http.Request) {
	contentType := r.Header.Get("Content-Type")
	switch contentType {
	case "multipart/form-data":
		fmt.Fprintf(w, "You sent me multipart/form-data")
	case "application/x-www-form-urlencoded":
		r.ParseForm()
		fmt.Fprintf(w, "Hello %s", r.FormValue("name"))
	case "application/json":
		body, err := ioutil.ReadAll(r.Body)
		if err != nil {
			fmt.Fprintf(w, "Couldn't read the JSON body")
		} else {
			var data testData
			err = json.Unmarshal(body, &data)
			if err != nil {
				fmt.Fprintf(w, "Error parsing JSON")
			} else {
				fmt.Fprintf(w, "Hello %s", data.Name)
			}
		}
	default:
		fmt.Fprintf(w, "Invalid Content-Type: %s", contentType)
	}
}

func rootHandler(w http.ResponseWriter, r *http.Request) {

	switch r.Method {
	case "GET":
		fmt.Fprintf(w, "Hi there! Received request for %s", r.URL.Path)
	case "POST":
		handlePostRequest(w, r)
	default:
		http.Error(w, http.StatusText(http.StatusMethodNotAllowed), http.StatusMethodNotAllowed)
	}
}

func main() {
	// Setup handlers
	http.HandleFunc("/", rootHandler)
	http.HandleFunc("/ping/", healthcheck)
	http.HandleFunc("/ping", healthcheck)

	// Check if the address to listen on was
	// specified
	listenAddr := os.Getenv("LISTEN_ADDRESS")
	if listenAddr == "" {
		listenAddr = ":8080"
	}

	// nil argument here specifies using the DefaultServeMux
	log.Fatal(http.ListenAndServe(listenAddr, nil))
}
