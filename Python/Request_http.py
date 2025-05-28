import requests

#Making HTTP Requests

url = "https://api.example.com/data"
try:
    response = requests.get(url)
    response.raise_for_status()  # Raise an exception for bad status codes
    data = response.json()
    print(data)
except requests.exceptions.RequestException as e:
    print(f"Error fetching data: {e}")