!#/bin/bash

# Go to the home directory
cd /home/$USER

echo "Updateing system and installing dependencies..."
apt update && apt upgrade -y

# Install PHP and required extensions
echo "tzdata tzdata/Areas select America" |  debconf-set-selections
echo "tzdata tzdata/Zones/America select Santo_Domingo" |  debconf-set-selections
DEBIAN_FRONTEND=noninteractive apt install tzdata -y

apt install php-pgsql php-fpm php-common php-mysql php-gmp php-curl php-intl php-mbstring php-soap php-xmlrpc php-gd php-xml php-cli php-zip unzip nginx curl -y


# Update PHP configuration
cat <<EOL >> /etc/php/8.3/fpm/php.ini
memory_limit = 256M
cgi.fix_pathinfo = 0
upload_max_filesize = 100M
max_execution_time = 360
date.timezone = America/Santo_Domingo
max_input_vars = 5000
EOL

# restarts php-fpm
service php8.3-fpm restart
# Configure PostgreSQL to allow external connections
cat <<EOL > /etc/postgresql/*/main/postgresql.conf
listen_addresses = '*'
EOL

# Download moodlea
curl -L -o moodle.zip https://github.com/moodle/moodle/archive/refs/tags/v4.5.4.zip
unzip moodle.zip 

# Rename the extracted folder
mv moodle-4.5.4 moodle

# Move moodle to the web server root directory
mv moodle /var/www/html/moodle

# Set permissions
mkdir -p /var/www/html/moodledata
chown -R www-data:www-data /var/www/html/moodle
chmod -R 755 /var/www/html/*
chown www-data:www-data /var/www/html/moodledata

# Configure Nginx
cat <<EOL > /etc/nginx/conf.d/moodle.conf
server {
    listen 3000;
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

# Test Nginx configuration and restart
nginx -t
nginx
nginx -s stop
nginx
