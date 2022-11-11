sudo apt install git 
git clone https://github.com/Alirezabg/cyf-first-api.git 
cd cyf-first-api
sudo npm install pm2@latest -g 
sudo install nginx
sudo unlink /etc/nginx/sites-available/default
cd /etc/nginx/sites-available
cat <<NGINXCONFIG >> myserver.config
server{
    listen 80;
    server_name wach.quest;
    location / {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $host;
        proxy_pass http://127.0.0.1:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";

    }
}
NGINXCONFIG

pm2 index.js