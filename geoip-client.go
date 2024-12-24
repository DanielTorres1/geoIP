// Save this as main.go
package main

import (
	"fmt"
	"os"
	"strings"
	"geoip/geoip"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Println("Usage:\n geoip 1.2.3.4")
		os.Exit(1)
	}

	ip := os.Args[1]
	geoIP := geoip.New()

	response, err := geoIP.GetData(ip)
	if err != nil {
		fmt.Println("")
		os.Exit(1)
	}

	// Clean up fields
	isp := strings.ReplaceAll(response.Org, ",", " ")
	regionName := strings.ReplaceAll(response.RegionName, ",", " ")
	hostingType := "On-Premise"

	if response.Hosting {
		hostingType = "Hosting"
	}

	// Check for major cloud providers
	ispLower := strings.ToLower(isp)
	if strings.Contains(ispLower, "amazon") || 
	   strings.Contains(ispLower, "microsoft") || 
	   strings.Contains(ispLower, "google") {
		hostingType = "On-Premise"
	}

	fmt.Printf("%s,%s (%s),%s\n", isp, regionName, response.Country, hostingType)
}