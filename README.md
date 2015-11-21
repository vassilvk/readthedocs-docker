## On-Premises ReadTheDocs (RTD) Docker Container

On-premises setup of ReadTheDocs (RTD) with full support of LaTeX-to-PDF and all the other bells-and-whistles installed at readthedocs.org.

Installed packages include:
* LaTeX
* Doxygen
* Dvipng
* Graphviz

This setup allows private GitHub and Visual Studio Online (VSO) Git documentation projects.

GitHub repository URLs are of the form:
https://<your-security-token>:x-oauth-basic@github.com/<your_name>/<your_project>.git

VSO Git repository URLs are of the form:
https://<your-security-token>:x-oauth-basic@<your_name>.visualstudio.com/DefaultCollection/_git/<your_project>

This image also removes the infamous account email verification on user sign-up.

### How to Build the Docker Image
Issue the following command to rebuild the Docker image.
```
docker build -t <your_docker_user_name>/readthedocs:latest --rm=true .
```

Note that you will need access to the Internet while building the machine.
Depending on package site availability the building may take a while.

### How to Run the Container
```
docker run -d -it -p 8000:8000 -e "RTD_PRODUCTION_DOMAIN=my_domain.com:8000" --name readthedocs vassilvk/readthedocs
```

The above example starts the container with the assumption that it will be accessed at http://my_domain.com:8000.
Change the port mappings and environment variable `RTD_PRODUCTION_DOMAIN` to reflect your setup.

You need to run the container only once. After that you only need stop and start it:
```
docker stop readthedocs
```
```
docker start readthedocs
```

When you run the container for the first time, it creates a container volume where it stores the RTD data.
Removing the container will delete the container's volume with all the RTD data. Don't remove it unless you want to re-import your RTD projects from scratch.


### How to Access the Application
To access the web application hosted by the container, navigate to http://my_domain.com:8000/ where "my_domain.com" is the address of the container host.
You can access the site with user `admin`, password `admin`.
