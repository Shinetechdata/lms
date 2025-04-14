

cd /home/$USER

echo "Updateing system and installing dependencies..."
apt update && apt upgrade -y

# Install PHP and required extensions
echo "tzdata tzdata/Areas select America" |  debconf-set-selections
echo "tzdata tzdata/Zones/America select Santo_Domingo" |  debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt install tzdata -y

apt install php-cli -y
apt install php-pgsql -y
apt install php8.3-fpm -y
apt install unzip -y
sudo apt install postgresql -y
apt install nginx -y

# Download moodle
curl -L -o moodle.zip https://github.com/moodle/moodle/archive/refs/tags/v4.5.4.zip
unzip moodle.zip 

# Rename the extracted folder
mv moodle-4.5.4 moodle

# Move moodle to the web server root directory
mv moodle /var/www/html/moodle

# Set permissions
chown -R www-data:www-data /var/www/html/moodle
chmod -R 755 /var/www/html/moodle

# Create moodledata directory
mkdir /var/moodledata

# Set permissions for moodledata
chown -R www-data:www-data /var/moodledata
chmod -R 755 /var/moodledata

# Configure Nginx
cat <<EOL > /etc/nginx/conf.d/moodle.conf
server {
    listen 80;
    root /var/www/html/moodle;
    index index.php index.html index.htm;


    client_max_body_size 100M;
    autoindex off;
    location / {
        try_files \$uri \$uri/ =404;
    }

    location /dataroot/ {
        internal;
        alias /var/www/html/moodledata/;
    }

    location ~ [^/].php(/|\$) {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.3-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOL


nginx -t
nginx restart
