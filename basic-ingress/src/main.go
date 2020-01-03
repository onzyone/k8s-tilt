package main

import (
	"html/template"
	"log"
	"net/http"
	"time"
	"net"
)

type PageVariables struct {
	Date 		string
	Time 		string
	LocalAddr 	string
}

func main(){
	http.HandleFunc("/", HomePage)
	log.Fatal(http.ListenAndServe(":5000", nil))
}

func HomePage(w http.ResponseWriter, r *http.Request){
	
	now := time.Now() // get the current time

		conn, err := net.Dial("udp", "8.8.8.8:80")
		if err !=nil {
			log.Fatal(err)
		}
		defer conn.Close()
	
	localAddr := conn.LocalAddr().(*net.UDPAddr)

	HomePageVars := PageVariables{
		Date: 		now.Format("02-01-2006"),
		Time: 		now.Format("15:04:05"),
		LocalAddr: 	localAddr.IP.String(),
	}

	t, err := template.ParseFiles("homepage.html")
	if err != nil {
		log.Print("template parsing error: ", err)
	}
	err = t.Execute(w, HomePageVars)
	if err != nil {
		log.Print("template executing error: ", err)
	}
}