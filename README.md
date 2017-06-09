# WP AWS Server Side Auto Config Backup Script
Auto-config WordPress Backups via AWS S3. This is tested on Debian 8 x64 and Ubuntu 16.04 and later

**Please verify that the backups are being created! This is BETA software.**

## Before running, you must:

* Have already set up a WordPress install
* Have an AWS Account
* Set up an S3 bucket
* Create a programatic user with IAM with full S3 Access
* Have the id and secret key for the user in the last step
* (See below if you are unsure how to do any of the above)

## Installation

    sudo apt-get install git -y
    cd ~
    git clone https://github.com/duplaja/wp-aws-auto-backup
    cd wp-aws-auto-backup
    nano setup-aws.sh
    <enter correct values for the 6 variables at the top (may not need to change SITE_DIR)>
    <Variables are: AWS_ID, AWS_SECRET, AWS_REGION, DOMAIN, SITE_DIR, S3_BUCKET_AND_SUBFOLDER>
    <ctrl + o to write out and save changes>
    sudo bash setup-aws.sh

## What This Does

* Installs and Configures AWS CLI
* Compiles a Backup Script that builds a tar.gz backup of your files and database
* Adds the backup script to a nightly cron at 1:05 am server time

## Useful Links


* [Creating a New AWS Bucket](http://docs.aws.amazon.com/AmazonS3/latest/UG/CreatingaBucket.html)
* [Creating a New AWS User (Programatic)](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_users_create.html#id_users_create_console)

## Suggestions and Ideas

* Look into setting up a S3 bucket lifecycle to auto remove files older than x days
* You can also choose to move older backups into long term storage via Glacier
* Although costs are low, don't forget that you're paying for AWS! It's about $0.03 / GB in most US regions, so if you don't version, you will eventually build up some significant costs.
* With 30 day versioning, a 1gb site can expect to pay $0.90 / month for backups.
* You can always run your script manually, by navigating to /var/other-scripts and using bash backup-script.sh
