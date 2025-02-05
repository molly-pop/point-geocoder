## Geocoder Platform

![Version](https://badgen.net/github/release/kevin-s-guo/point-geocoder) [![Docker](https://badgen.net/badge/icon/docker?icon=docker&label)](https://hub.docker.com/u/ksgi)

### Dependencies
Docker needs to be installed on the host. See [this](https://docs.docker.com/get-docker/) page for Docker installation instructions.

### Docker setup
In order to deploy the geocoder platform, download and extract [the whole repository](https://github.com/kevin-s-guo/point-geocoder/archive/refs/heads/main.zip). In the directory containing the `docker-compose.yml`, run the following command. The app directory contains the Python code for the web container, and changes in files in that directory will be reflected in the web container.

``$ docker compose pull``

This will pull the two images required.

Before the web app will work, the PostgreSQL database will need to be set up.

First, create and start the database container with docker compose.

``$ docker compose up -d db``

Next, run the setup shell script.

``$ docker exec geocoder-platform-db sh load_default.sh``

`load_default.sh` will install PostGIS (the spatial database extension), download 2020 census data, import 2010 block-group boundaries, and create the necessary tables for the web app. Depending on download speed, this may take hours. The full US Census data will take up approximately 100 gigabytes of storage.

When this is done, the Python web server container can be started with the following command.

``$ docker compose up``

If everything worked according to plan, navigating to `localhost:7001/docs` in a web browser should show the API documentation page. Navigating to `localhost:7001/web` will bring up the graphical user interface.

### Loading Built-in SDOH Databases

``$ docker exec geocoder-platform-web python3 sdoh_util.py``

Restart the web server container so that the newly loaded databases are shown.

``$ docker compose restart web``

Navigate to `localhost:7001/web/var_list/` to view the list of geographic variables available along with descriptions and links to source websites.

### Suspending POINT

In order to suspend the application, use the following command.

``$ docker compose stop``

Using `docker compose down` will delete the containers, but if the `-v` flag is not used, the persistent volume (named `gisdata`) where the GIS data is stored will not be deleted.

## Updating POINT

First, make sure that the POINT application is stopped (using `docker compose stop`). In order to preserve the data stored in the database service, use the following two commands to remove only the web container and associated image.

``$ docker rm geocoder-platform-web``  
``$ docker image rm geocoder-platform-web``

Then, restart the whole application with `docker compose`.

``$ docker compose up``

The version tagged `latest` will automatically be downloaded and swapped in from Docker Hub.

---

## Modifications & Improvements

This version of the Geocoder Platform includes several modifications to improve usability and compatibility in secure environments:

- **Static File Handling**: Added static files to streamline data access instead of relying on web routing.
- **New SDOH Utility**: Introduced `sdoh_util_new.py` to work with static files, reducing complexity.
- **Optimized Data Load**: Added `my_load_default.sh` to significantly downsize the amount of Census data required. This modification makes it easier to run on local machines within a secure local environment.
- **Deployment Challenges**: The modified version has successfully run on personal computers but has encountered issues when deployed at Fox Chase due to IT restrictions. 
- **Next Steps**: Future work will focus on troubleshooting IT-related constraints and finding workarounds to enable deployment within institutional environments.

These changes aim to make the platform more accessible while maintaining core functionality.

