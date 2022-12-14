sudo apt update
sudo apt upgrade
sudo dpkg --configure -a
sudo apt install git -y
cd /home/alireza
git clone https://github.com/Alirezabg/cyf-first-api.git 
sudo apt install npm -y
sudo apt install node -y
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
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection "upgrade";

    }
}
NGINXCONFIG
sudo ln -s /etc/nginx/sites-available/myserver.config /etc/nginx/sites-enabled/
sudo systemctl restart nginx
sudo npm install pm2 -g -y
sudo pm2 start /home/alireza/cyf-first-api/index.js