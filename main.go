package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net"
	"net/http"
	"os/exec"
)

type Configure struct {
	Listen string   `json:"listen"`
	Modes  []string `json:"modes"`
}

var configure = loadConfigure()

func main() {
	if configure == nil {
		fmt.Println("please configure the './configure.json' file.")
		return
	}
	mux := http.NewServeMux()
	mux.Handle("/", http.FileServer(http.Dir("./pages")))
	mux.HandleFunc("/api/switch", handleSwitch)
	mux.HandleFunc("/api/status", handleQueryStatus)
	fmt.Printf("listen address: http://%s\n", configure.Listen)
	if err := http.ListenAndServe(configure.Listen, mux); err != nil {
		fmt.Println("error:", err)
	}
}

func handleSwitch(rw http.ResponseWriter, r *http.Request) {
	if r.Method != "POST" {
		rw.WriteHeader(http.StatusMethodNotAllowed)
		return
	}
	host, _, _ := net.SplitHostPort(r.RemoteAddr)
	modeName := r.FormValue("mode_name")
	if !configure.InMode(modeName) {
		rw.WriteHeader(http.StatusBadRequest)
		return
	}
	cmd := exec.Command("./hooks/switch.sh", host, modeName)
	handleOutput(rw, cmd)
}

func handleQueryStatus(rw http.ResponseWriter, r *http.Request) {
	if r.Method != "GET" {
		rw.WriteHeader(http.StatusMethodNotAllowed)
		return
	}
	host, _, _ := net.SplitHostPort(r.RemoteAddr)
	cmd := exec.Command("./hooks/status.sh", host)
	handleOutput(rw, cmd)
}

func loadConfigure() *Configure {
	data, err := ioutil.ReadFile("./configure.json")
	if err != nil {
		return nil
	}
	conf := new(Configure)
	if err := json.Unmarshal(data, conf); err != nil {
		return nil
	}
	return conf
}

func handleOutput(rw http.ResponseWriter, cmd *exec.Cmd) {
	output, err := cmd.Output()
	if err != nil {
		rw.WriteHeader(http.StatusServiceUnavailable)
		rw.Write([]byte(err.Error()))
		return
	}
	rw.WriteHeader(http.StatusOK)
	rw.Write(output)
}

func (conf *Configure) InMode(name string) bool {
	for _, mode := range conf.Modes {
		if mode == name {
			return true
		}
	}
	return false
}
