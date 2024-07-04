# Advanced HTTP Flood DoS Script

## Introduction
This script is designed to simulate an HTTP Flood type of Denial of Service (DoS) attack to help test and evaluate the resilience of web servers against high loads and varied request types. It supports multiple advanced features including HTTPS, custom HTTP headers, random user agents, mixed request methods, and optional random delays between requests.

### Author
- **w01f** from Myanmar, with a foundation in practical cybersecurity experiences.

## Requirements
- `curl`: Tool for transferring data with URLs.
- `parallel`: Tool for executing jobs in parallel.
- `bash`: Unix shell for running the script.

## Installation
### Dependencies
You need to install `curl` and `GNU parallel`. Here's how you can install these on a Debian-based system (like Ubuntu):

```bash
sudo apt-get update
sudo apt-get install curl parallel
```

For Red Hat-based systems (like CentOS), you can install these tools using

```bash
sudo yum install curl parallel
```

### Script Setup
1. Download or create the script file on your server.
2. Make the script executable

```bash
chmod +x advanced_dos_script.sh
```

## Usage
To run the script, you need to specify the target URLs, the number of concurrent requests, the duration of the attack, and optionally enable mixed HTTP methods and random delays.

```bash
./advanced_dos_script.sh -u http://example.com,https://securetest.com -c 10 -t 60 -m -d
```

Here is the breakdown of the command line options:
- `-u`: URLs to target, separated by commas.
- `-c`: Number of concurrent requests.
- `-t`: Duration of the attack in seconds.
- `-m`: Enable mixed HTTP methods (GET and POST).
- `-d`: Enable random delays between requests.

## Detailed Explanation
### Features
- **HTTPS Support** The script uses `curl`, which inherently supports HTTPS.
- **Random Delays** Introduces random delays (up to 5 seconds) between requests to simulate realistic user behavior.
- **Custom Headers and User Agents** Randomizes user agents and allows custom headers to mimic different types of browsers and devices.
- **Response Logging**: Logs response statuses to analyze the server's behavior under load.

### Report Generation
After execution, the script provides a summary of response codes
- Successes
- Failures
- Server errors

Logs are stored in `/tmp/dos_log.txt` and the detailed report in `/tmp/dos_report.txt`.

## Disclaimer
This script is intended for educational purposes and should be used only on systems where you have explicit authorization to perform such tests. Misuse of this script can lead to legal and ethical issues.

## Author's Note
The script is based on my experiences in the field of cybersecurity and aims to provide a practical tool for security testing and education.
