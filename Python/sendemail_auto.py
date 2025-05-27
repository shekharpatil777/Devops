import smtplib
from email.mime.text import MIMEText

#send automatic email

sender_email = "your_email@example.com"
sender_password = "your_password"
receiver_email = "recipient@example.com"
subject = "Alert: High CPU Usage"
body = "CPU usage on your server has exceeded 90%."

message = MIMEText(body)
message['Subject'] = subject
message['From'] = sender_email
message['To'] = receiver_email

try:
    with smtplib.SMTP_SSL('smtp.example.com', 465) as server:
        server.login(sender_email, sender_password)
        server.sendmail(sender_email, receiver_email, message.as_string())
    print("Email sent successfully")
except Exception as e:
    print(f"Error sending email: {e}")