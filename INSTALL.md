## Quick Start

<p><b>WARNING!</b> Before you start, it is recommended that you have a good understanding of Blesta and Docker. This quick start will be going through with using docker-compose.</p>

First make sure that your docker build is up to date (At the time, this works on Docker CE 17.x).


Clone/Download the repository to your local storage.


Rename the provided .env.example as .env

Edit variables to fit your need, such as database password and URL.


Run `docker-compose pull` to pull down the images. After `docker-compose up -d mysql` to start up mysql (Be sure to wait roughly 10-30 seconds to ensure that the database starts up).


When the base is set up, then run `docker-compose up -d blesta`. This may take anywhere from 30 seconds to a few minutes when the panel starts up.



Now login to blesta using the your domain.com/admin and set up Blesta



If you have any problems, refer to `docker-compose logs` to identify any issues.
You should be all set and rocking!

## Updating

Refer to https://docs.blesta.com/display/user/Upgrading+Blesta when updating to a newer version.


## SSL Encryption

Let's Encrypt is supported, just add in certbot from `docker-compose.extra.yml` and volumes to panel.