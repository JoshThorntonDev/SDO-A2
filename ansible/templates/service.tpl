[Unit]
Description=ToDoApp
Requires=network-online.target
After=network-online.target

[Service]
Environment=DB_URL={{ db_url }}
Environment=SESSION_SECRET=secret
WorkingDirectory=/home/ec2-user
Type=simple
ExecStart=npm run start
Restart=on-failure

[Install]
WantedBy=multi-user.target
