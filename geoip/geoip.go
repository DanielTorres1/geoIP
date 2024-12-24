// Save this as pkg/geoip/geoip.go
package geoip

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"time"
)

// GeoIP represents the client for making IP lookups
type GeoIP struct {
	ProxyHost string
	ProxyPort string
	ProxyUser string
	ProxyPass string
	client    *http.Client
}

// IPResponse represents the response from ip-api.com
type IPResponse struct {
	Status     string `json:"status"`
	Message    string `json:"message"`
	Org        string `json:"org"`
	Country    string `json:"country"`
	RegionName string `json:"regionName"`
	Hosting    bool   `json:"hosting"`
}

// New creates a new GeoIP client
func New() *GeoIP {
	return &GeoIP{
		client: buildHTTPClient("", "", "", ""),
	}
}

// NewWithProxy creates a new GeoIP client with proxy settings
func NewWithProxy(proxyHost, proxyPort, proxyUser, proxyPass string) *GeoIP {
	return &GeoIP{
		ProxyHost: proxyHost,
		ProxyPort: proxyPort,
		ProxyUser: proxyUser,
		ProxyPass: proxyPass,
		client:    buildHTTPClient(proxyHost, proxyPort, proxyUser, proxyPass),
	}
}

// GetData retrieves IP information for the given IP address
func (g *GeoIP) GetData(ip string) (*IPResponse, error) {
	url := fmt.Sprintf("http://ip-api.com/json/%s?fields=status,message,org,country,regionName,hosting", ip)
	
	resp, err := g.client.Get(url)
	if err != nil {
		return nil, fmt.Errorf("failed to make request: %v", err)
	}
	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read response: %v", err)
	}

	var result IPResponse
	if err := json.Unmarshal(body, &result); err != nil {
		return nil, fmt.Errorf("failed to parse JSON: %v", err)
	}

	return &result, nil
}

func buildHTTPClient(proxyHost, proxyPort, proxyUser, proxyPass string) *http.Client {
	client := &http.Client{
		Timeout: 10 * time.Second,
	}

	if proxyHost != "" {
		var proxyURL *url.URL
		var err error

		if proxyHost == "tor" {
			proxyURL, err = url.Parse("socks5://localhost:9050")
		} else {
			proxyStr := ""
			if proxyUser != "" && proxyPass != "" {
				proxyStr = fmt.Sprintf("http://%s:%s@%s:%s", proxyUser, proxyPass, proxyHost, proxyPort)
			} else {
				proxyStr = fmt.Sprintf("http://%s:%s", proxyHost, proxyPort)
			}
			proxyURL, err = url.Parse(proxyStr)
		}

		if err == nil {
			client.Transport = &http.Transport{
				Proxy: http.ProxyURL(proxyURL),
			}
		}
	}

	return client
}