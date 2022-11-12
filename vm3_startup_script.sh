sudo apt update
sudo apt upgrade
sudo dpkg --configure -a
sudo apt install git -y
cd /home/alireza
git clone https://github.com/Alirezabg/week-2-cyf.git
sudo apt install nginx -y
sudo unlink /etc/nginx/sites-available/default
cd /etc/nginx/sites-available
sudo unlink /etc/nginx/sites-enabled/default
cat <<NGINXCONFIG >> myserver.config
server{
    listen 80;
    server_name wach.quest;
    location / {
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header Host \$host;
        proxy_pass http://127.0.0.1:8000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

    }
}
NGINXCONFIG
sudo ln -s /etc/nginx/sites-available/myserver.config /etc/nginx/sites-enabled/
sudo pip install gunicorn -g -y
sudo gunicorn -w 4 -b 0.0.0.0:8000 /Home/alireza/week-2-cyf/app.py:app
sudo systemctl start nginx
sudo systemctl restart nginx
