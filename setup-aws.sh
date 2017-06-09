#!/bin/bash
##############################################
# 
# Variables: Please make sure all are 
# appropriately filled out before running 
#
###############################################

# AWS ID and Secret Should have S3 write permissions at a minimum
# AWS Region should match your bucket region
AWS_ID="ID HERE"
AWS_SECRET="SECRET HERE"
AWS_REGION="us-west-2"

# Your domain without the http/https, absolute site file location and S3 Bucket information
DOMAIN="DOMAINHERE"
SITE_DIR="/var/www/$DOMAIN"
S3_BUCKET_AND_SUBFOLDER="bucket/subfolder"


#Pulls the DB Name, User, and PW from wp-config.php of the site located in SITE_DIR
WP_CONFIG_FILE="${SITE_DIR}/wp-config.php"
DB_NAME=$(cat ${WP_CONFIG_FILE} | grep DB_NAME | cut -d \' -f 4)
DB_USER=$(cat ${WP_CONFIG_FILE} | grep DB_USER | cut -d \' -f 4)
DB_PASSWORD=$(cat ${WP_CONFIG_FILE} | grep DB_PASSWORD | cut -d \' -f 4)

# Installs AWS CLI
apt-get --assume-yes install awscli

# Creates a profile for default using your AWS S3 credentials from above
mkdir ~/.aws
echo '[default]' > ~/.aws/config
echo region=$AWS_REGION >> ~/.aws/config
echo '[default]' > ~/.aws/credentials
echo aws_access_key_id=$AWS_ID >> ~/.aws/credentials
echo aws_secret_access_key=$AWS_SECRET >> ~/.aws/credentials

echo "AWS Configured..."
# Create your customized backup script folder
mkdir /var/other-scripts

# Copy the two partial templates to the folder above
cp templates/backup-site.sh /var/other-scripts/backup-site.sh
cp templates/backuptemplate /var/other-scripts/backuptemplate

# Start filling in the lines for the user-entered variables above
echo "DOMAIN=\"$DOMAIN\"" >> /var/other-scripts/backup-site.sh
echo "SITE_DIR=\"$SITE_DIR\"" >> /var/other-scripts/backup-site.sh
echo "S3_BUCKET_AND_SUBFOLDER=\"$S3_BUCKET_AND_SUBFOLDER\"" >> /var/other-scripts/backup-site.sh

# Copy over database credentials
echo "DB_NAME=\"$DB_NAME\"" >> /var/other-scripts/backup-site.sh
echo "DB_USER=\"$DB_USER\"" >> /var/other-scripts/backup-site.sh
echo "DB_PASSWORD=\"$DB_PASSWORD\"" >> /var/other-scripts/backup-site.sh


# Reads the bulk of the script from the template file into the shell script
cat /var/other-scripts/backuptemplate >> /var/other-scripts/backup-site.sh

# Cleans up the partial template file now that it's no longer needed
rm /var/other-scripts/backuptemplate

# Marks the backup script as executable
chmod +x /var/other-scripts/backup-site.sh

echo "Backup Script Created and Configured at /var/other-scripts/backup-site.sh"

# Adds the backup to crontab nightly at 1:05 am
(crontab -l ; echo "05 01 * * * bash /var/other-scripts/backup-site.sh") | crontab -

echo "Backup Added to Nightly Cron at 1:05 am server time"
